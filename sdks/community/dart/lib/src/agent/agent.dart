library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../apply/default.dart';
import '../capabilities.dart';
import '../debug_logger.dart';
import '../apply/json_patch.dart';
import '../enforce/enforce.dart';
import '../events/events.dart';
import '../interrupts/index.dart' show isInterruptExpired;
import '../middleware/middleware.dart';
import '../transform/chunks.dart';
import '../types/base.dart';
import '../types/types.dart';
import '../verify/verify.dart';
import 'subscriber.dart';
import 'types.dart';

abstract class AbstractAgent {
  String? agentId;
  String description;
  String threadId;
  List<Message> messages;
  Object? state;
  List<AgentSubscriber> subscribers = [];
  bool isRunning = false;
  List<Interrupt> pendingInterrupts;
  final List<Middleware> _middlewares = [];
  StreamIterator<BaseEvent>? _activeRunIterator;
  Completer<void>? _activeRunCompletion;
  ResolvedAgentDebugConfig _debug;
  DebugLogger? _debugLogger;
  bool _compatibilityMiddlewaresInitialized = false;

  /// Tool calls started by the current run, in arrival order.
  final List<String> _runToolCallIds = [];

  /// Tool calls of the current run that received a `TOOL_CALL_RESULT`.
  final Set<String> _answeredToolCallIds = {};

  AbstractAgent({
    AgentConfig config = const AgentConfig(),
  })  : agentId = config.agentId,
        description = config.description ?? '',
        threadId = config.threadId ?? _generateId('thread'),
        messages = List<Message>.from(config.initialMessages ?? const []),
        state = cloneJsonValue(config.initialState ?? <String, dynamic>{}),
        pendingInterrupts = <Interrupt>[],
        _debug = resolveAgentDebugConfig(config.debug),
        _debugLogger = createDebugLogger(resolveAgentDebugConfig(config.debug));

  ResolvedAgentDebugConfig get debug => _debug;

  set debug(Object? value) {
    _debug = resolveAgentDebugConfig(value);
    _debugLogger = createDebugLogger(_debug);
  }

  DebugLogger? get debugLogger => _debugLogger;

  set debugLogger(Object? value) {
    _debugLogger = resolveDebugLogger(value);
  }

  /// The protocol version this client speaks.
  ///
  /// This is not the peer ceiling — that is [maxProtocolVersion].
  String get protocolVersion => agUiProtocolVersion;

  /// The ceiling the peer speaks.
  ///
  /// Defaults to the version this client speaks; a subclass that talks down to
  /// an older backend overrides it to pin the ceiling, which is what installs
  /// the matching era shims and what withholds the `protocolVersion`
  /// declaration the peer predates.
  ///
  /// Delegates to [maxVersion] so a subclass still overriding the deprecated
  /// getter keeps pinning the ceiling.
  // ignore: deprecated_member_use_from_same_package
  String get maxProtocolVersion => maxVersion;

  /// The previous name for [maxProtocolVersion], kept so a subclass that
  /// overrides it still pins the peer ceiling. Same value, honest name: this
  /// is the ceiling the PEER speaks, not which protocol this SDK implements.
  ///
  /// The TypeScript SDK defaults this to its package version (a protocol-ish
  /// 1.0.x). This package's version is still the pre-1.0 `0.0.x` series, which
  /// is not a protocol ceiling at all, so the ceiling is the revision this
  /// client actually speaks.
  @Deprecated(
    'Use maxProtocolVersion. Same value, and the new name says whose version '
    'it is and that it is a ceiling.',
  )
  String get maxVersion => agUiProtocolVersion;

  Stream<BaseEvent> run(RunAgentInput input);

  /// Returns the agent's current capabilities.
  ///
  /// Optional — subclasses override this to advertise what they support. The
  /// base answers `null`, which is how a caller tells "not advertised" apart
  /// from an empty capability set; the TypeScript SDK models the same thing as
  /// an optional method that may be absent.
  Future<AgentCapabilities?> getCapabilities() async => null;

  Stream<BaseEvent> connect(RunAgentInput input) =>
      Stream<BaseEvent>.error(const AGUIConnectNotImplementedError());

  AbstractAgent createClone();

  AbstractAgent clone() {
    final cloned = createClone();
    cloned.agentId = agentId;
    cloned.description = description;
    cloned.threadId = threadId;
    cloned.messages = List<Message>.from(messages);
    cloned.state = cloneJsonValue(state);
    cloned.subscribers = List<AgentSubscriber>.from(subscribers);
    cloned.pendingInterrupts = List<Interrupt>.from(pendingInterrupts);
    cloned._debug = _debug;
    cloned._debugLogger = _debugLogger;
    // The middleware list is copied verbatim below, compatibility shims
    // included. Without this flag the clone would install them a second time
    // on its first run.
    cloned._compatibilityMiddlewaresInitialized =
        _compatibilityMiddlewaresInitialized;
    for (final middleware in _middlewares) {
      cloned.use(middleware);
    }
    return cloned;
  }

  AbstractAgent use(dynamic middleware) {
    if (middleware is Middleware) {
      _middlewares.add(middleware);
    } else if (middleware is MiddlewareFunction) {
      _middlewares.add(FunctionMiddleware(middleware));
    } else {
      throw ArgumentError(
          'Unsupported middleware type: ${middleware.runtimeType}');
    }
    return this;
  }

  StreamSubscriptionHandle subscribe(AgentSubscriber subscriber) {
    subscribers.add(subscriber);
    return StreamSubscriptionHandle(
      onUnsubscribe: () => subscribers.remove(subscriber),
    );
  }

  Future<RunAgentResult> runAgent([
    RunAgentParameters parameters = const RunAgentParameters(),
    AgentSubscriber? subscriber,
  ]) {
    return _executeAgentRun(
      parameters,
      subscriber,
      useConnect: false,
    );
  }

  Future<RunAgentResult> connectAgent([
    RunAgentParameters parameters = const RunAgentParameters(),
    AgentSubscriber? subscriber,
  ]) {
    return _executeAgentRun(
      parameters,
      subscriber,
      useConnect: true,
      swallowConnectNotImplemented: true,
    );
  }

  Future<RunAgentResult> _executeAgentRun(
    RunAgentParameters parameters,
    AgentSubscriber? subscriber, {
    required bool useConnect,
    bool swallowConnectNotImplemented = false,
  }) async {
    _ensureCompatibilityMiddlewares();
    isRunning = true;
    agentId ??= _generateId('agent');
    final currentMessageIds = messages.map((message) => message.id).toSet();
    Object? result;
    final allSubscribers = <AgentSubscriber>[
      ...subscribers,
      if (subscriber != null) subscriber,
    ];

    var input = prepareRunAgentInput(parameters);

    try {
      if (!useConnect) {
        _debugLogger?.lifecycle('LIFECYCLE', 'Run started:', {
          'agentId': agentId,
          'threadId': threadId,
        });
      }
      input = await _onInitialize(
        input,
        allSubscribers,
        checkResumeAnswers: !useConnect,
      );

      final stream = useConnect
          ? compatibilityBoundaryOperator(input, connect(input))
          : _runWithMiddlewares(input);
      final processed = verifyEvents(
        transformChunks(
          enforceEvents(stream, debugLogger: _debugLogger),
          debugLogger: _debugLogger,
        ),
        debugLogger: _debugLogger,
      );
      final iterator = StreamIterator(processed);
      _activeRunIterator = iterator;
      _activeRunCompletion = Completer<void>();

      while (await iterator.moveNext()) {
        final event = iterator.current;
        result = await _processEvent(event, input, allSubscribers, result);
      }
    } catch (error) {
      if (swallowConnectNotImplemented &&
          error is AGUIConnectNotImplementedError) {
        return RunAgentResult(
          result: null,
          newMessages: _collectNewMessages(currentMessageIds),
        );
      }
      if (!useConnect) {
        _debugLogger?.lifecycle('LIFECYCLE', 'Run errored:', {
          'agentId': agentId,
          'error': error is Error ? error.toString() : error.toString(),
        });
      }
      final handled = await _onError(input, error, allSubscribers);
      if (!handled) {
        rethrow;
      }
      return RunAgentResult(
        result: null,
        newMessages: _collectNewMessages(currentMessageIds),
      );
    } finally {
      if (!useConnect) {
        _debugLogger?.lifecycle('LIFECYCLE', 'Run finished:', {
          'agentId': agentId,
          'threadId': threadId,
        });
      }
      await _onFinalize(input, allSubscribers);
      _activeRunIterator = null;
      if (_activeRunCompletion != null && !_activeRunCompletion!.isCompleted) {
        _activeRunCompletion!.complete();
      }
      _activeRunCompletion = null;
      isRunning = false;
    }

    return RunAgentResult(
      result: result,
      newMessages: _collectNewMessages(currentMessageIds),
    );
  }

  void abortRun() {}

  Future<void> detachActiveRun() async {
    final iterator = _activeRunIterator;
    if (iterator == null) {
      return;
    }

    final completion = _activeRunCompletion?.future ?? Future<void>.value();
    await iterator.cancel();
    await completion;
  }

  void addMessage(Message message) {
    messages = [...messages, message];
    unawaited(() async {
      await _notifyNewMessageArtifacts([message], input: null);
      await _notifyMessagesChanged(input: null);
    }());
  }

  void addUserMessage({
    String? id,
    String? text,
    List<InputContent>? contentParts,
    String? name,
    String? encryptedValue,
  }) {
    final hasText = text != null;
    final hasContentParts = contentParts != null;
    if (hasText == hasContentParts) {
      throw ArgumentError(
        'Provide exactly one of text or contentParts when adding a user message.',
      );
    }

    addMessage(
      UserMessage(
        id: id ?? _generateId('msg'),
        content: text ?? List<InputContent>.from(contentParts!),
        name: name,
        encryptedValue: encryptedValue,
      ),
    );
  }

  void addMessages(List<Message> newMessages) {
    messages = [...messages, ...newMessages];
    unawaited(() async {
      await _notifyNewMessageArtifacts(newMessages, input: null);
      await _notifyMessagesChanged(input: null);
    }());
  }

  void setMessages(List<Message> value) {
    messages = List<Message>.from(value);
    unawaited(_notifyMessagesChanged(input: null));
  }

  void setState(Object? value) {
    state = cloneJsonValue(value);
    unawaited(_notifyStateChanged(input: null));
  }

  RunAgentInput prepareRunAgentInput(RunAgentParameters parameters) {
    return RunAgentInput(
      threadId: threadId,
      runId: parameters.runId ?? _generateId('run'),
      // Declared only when the peer's ceiling is not pinned below this client:
      // a downgraded peer predates the field, and an unknown input member is
      // exactly what a strict old parser could reject. The threshold is the
      // revision this client speaks rather than a package version — see
      // [maxVersion] — so a peer pinned at 0.0.x withholds the declaration
      // while any 1.0.x ceiling, which is what actually has the field, keeps it.
      protocolVersion:
          _compareVersions(maxProtocolVersion, agUiProtocolVersion) >= 0
              ? agUiProtocolVersion
              : null,
      state: cloneJsonValue(state),
      messages: _messagesForWire(messages),
      tools: List<Tool>.from(parameters.tools ?? const []),
      context: List<Context>.from(parameters.context ?? const []),
      forwardedProps:
          cloneJsonValue(parameters.forwardedProps ?? <String, dynamic>{}),
      resume: parameters.resume == null
          ? null
          : List<ResumeEntry>.from(parameters.resume!),
    );
  }

  /// Builds the message list sent to the backend from the agent's own history.
  ///
  /// Activity messages are the consumer's display state, which no producer
  /// owns, so they never go on the wire. Tool results are re-paired with the
  /// call that issued them: a stored history (or one seeded through
  /// [AgentConfig.initialMessages]) can hold a result away from its call, and
  /// providers reject `tool` before `assistant(tool_call)`. The agent keeps
  /// what it holds — only the input copy is repaired.
  List<Message> _messagesForWire(List<Message> source) {
    return keepToolResultsWithCalls(
      source.where((message) => message.role != MessageRole.activity).toList(),
    );
  }

  /// Runs the initialization subscribers and returns the input the run must
  /// use.
  ///
  /// [checkResumeAnswers] is true only for [runAgent]: starting a run answers
  /// the thread's interrupts, so the resume array must cover them. [connectAgent]
  /// only reads the thread's history and answers nothing, so an interrupted
  /// thread must still connect — the TypeScript SDK draws the same line with
  /// its `runInputs` set.
  ///
  /// A subscriber may replace the message list, and that assignment lands
  /// after [prepareRunAgentInput] already sanitized the input. Re-applying
  /// [_messagesForWire] here is what keeps the activity filter and the
  /// tool-result re-pairing true for the wire copy. The agent keeps the
  /// unfiltered list.
  Future<RunAgentInput> _onInitialize(
    RunAgentInput input,
    List<AgentSubscriber> currentSubscribers, {
    required bool checkResumeAnswers,
  }) async {
    if (checkResumeAnswers && pendingInterrupts.isNotEmpty) {
      final resume = input.resume ?? const <ResumeEntry>[];
      final resumeIds = resume.map((entry) => entry.interruptId).toSet();
      final uncovered = pendingInterrupts
          .where((interrupt) => !resumeIds.contains(interrupt.id))
          .map((interrupt) => interrupt.id)
          .toList();
      if (uncovered.isNotEmpty) {
        throw AGUIError(
          'Thread has pending interrupts not addressed by resume: ${uncovered.join(", ")}',
        );
      }
      for (final interrupt in pendingInterrupts) {
        if (!isInterruptExpired(interrupt)) continue;
        // Expiry forecloses ANSWERING, not resolving the thread: a cancelled
        // entry is the conforming way past an interrupt nobody answered in
        // time. Throwing on mere presence made an expired interrupt block its
        // thread forever, since coverage is mandatory and no entry could ever
        // satisfy the check.
        ResumeEntry? entry;
        for (final candidate in resume) {
          if (candidate.interruptId == interrupt.id) {
            entry = candidate;
            break;
          }
        }
        if (entry?.status != ResumeStatus.cancelled) {
          throw AGUIError(
            'Interrupt ${interrupt.id} expired at ${interrupt.expiresAt} and '
            'can no longer be answered. Cancel it to continue the thread.',
          );
        }
      }
    }

    final mutation = await runSubscribersWithMutation(
      subscribers: currentSubscribers,
      initialMessages: messages,
      initialState: state,
      executor: (subscriber, nextMessages, nextState) =>
          subscriber.onRunInitialized?.call(
        AgentSubscriberContext(
          messages: nextMessages,
          state: nextState,
          agent: this,
          input: input,
        ),
      ),
    );
    await _applyMutation(mutation, input, currentSubscribers);
    final mutatedMessages = mutation.messages;
    final mutatedState = mutation.state;
    if (mutatedMessages == null && mutatedState == null) {
      return input;
    }
    // The agent keeps the state the subscriber produced; the wire copy has to
    // carry it too, or the producer would work from the state the subscriber
    // just corrected.
    return input.copyWith(
      messages:
          mutatedMessages == null ? null : _messagesForWire(mutatedMessages),
      state: mutatedState,
    );
  }

  Future<bool> _onError(
    RunAgentInput input,
    Object error,
    List<AgentSubscriber> currentSubscribers,
  ) async {
    final mutation = await runSubscribersWithMutation(
      subscribers: currentSubscribers,
      initialMessages: messages,
      initialState: state,
      executor: (subscriber, nextMessages, nextState) =>
          subscriber.onRunFailed?.call(
        AgentErrorContext(
          messages: nextMessages,
          state: nextState,
          agent: this,
          input: input,
          error: error,
        ),
      ),
    );
    await _applyMutation(mutation, input, currentSubscribers);
    return mutation.stopPropagation == true;
  }

  Future<void> _onFinalize(
    RunAgentInput input,
    List<AgentSubscriber> currentSubscribers,
  ) async {
    final mutation = await runSubscribersWithMutation(
      subscribers: currentSubscribers,
      initialMessages: messages,
      initialState: state,
      executor: (subscriber, nextMessages, nextState) =>
          subscriber.onRunFinalized?.call(
        AgentSubscriberContext(
          messages: nextMessages,
          state: nextState,
          agent: this,
          input: input,
        ),
      ),
    );
    await _applyMutation(mutation, input, currentSubscribers);
  }

  Stream<BaseEvent> _runWithMiddlewares(RunAgentInput input) {
    // The always-on inbound compatibility boundary runs innermost — closest to
    // the wire — so every other middleware and the verification stage see
    // 1.0-shaped events. Appended per run and never stored, so it is installed
    // exactly once regardless of use() or clone().
    final chain = [..._middlewares, CompatibilityBoundary()];
    AbstractAgent next = this;
    for (final middleware in chain.reversed) {
      next = _MiddlewareAgentProxy(this, next, middleware);
    }
    return next.run(input);
  }

  void _ensureCompatibilityMiddlewares() {
    if (_compatibilityMiddlewaresInitialized) {
      return;
    }
    _compatibilityMiddlewaresInitialized = true;

    final peerCeiling = maxProtocolVersion;
    if (_compareVersions(peerCeiling, '0.0.39') <= 0) {
      _middlewares.insert(0, BackwardCompatibility_0_0_39());
    }
    if (_compareVersions(peerCeiling, '0.0.45') <= 0) {
      _middlewares.insert(0, BackwardCompatibility_0_0_45());
    }
    // Pre-subagent agents: strips subagentRunId and drops SUBAGENT_* events.
    if (_compareVersions(peerCeiling, '0.0.57') <= 0) {
      _middlewares.insert(0, BackwardCompatibility_0_0_57());
    }
  }

  Future<AgentStateMutation> _runEventCallback<T extends BaseEvent>(
    List<AgentSubscriber> currentSubscribers,
    AgentEventContext<T> context,
    FutureOr<AgentStateMutation?> Function(
      AgentSubscriber subscriber,
      AgentEventContext<T> context,
    ) callback,
  ) {
    return runSubscribersWithMutation(
      subscribers: currentSubscribers,
      initialMessages: messages,
      initialState: state,
      executor: (subscriber, nextMessages, nextState) {
        return callback(
          subscriber,
          AgentEventContext<T>(
            messages: nextMessages,
            state: nextState,
            agent: this,
            input: context.input,
            event: context.event,
            textMessageBuffer: context.textMessageBuffer,
            toolCallBuffer: context.toolCallBuffer,
            toolCallName: context.toolCallName,
            partialToolCallArgs: context.partialToolCallArgs,
            toolCallArgs: context.toolCallArgs,
            activityMessage: context.activityMessage,
            existingMessage: context.existingMessage,
            reasoningMessageBuffer: context.reasoningMessageBuffer,
            result: context.result,
            interrupts: context.interrupts,
            outcome: context.outcome,
            pendingToolCallIds: context.pendingToolCallIds,
          ),
        );
      },
    );
  }

  Future<AgentStateMutation> _runSpecificEventSubscribers(
    BaseEvent event,
    RunAgentInput input,
    List<AgentSubscriber> currentSubscribers,
  ) {
    switch (event) {
      case RunStartedEvent():
        return _runEventCallback<RunStartedEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<RunStartedEvent>,
          (s, c) => s.onRunStartedEvent?.call(c),
        );
      case RunFinishedEvent():
        return _runEventCallback<RunFinishedEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<RunFinishedEvent>,
          (s, c) => s.onRunFinishedEvent?.call(c),
        );
      case RunErrorEvent():
        return _runEventCallback<RunErrorEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<RunErrorEvent>,
          (s, c) => s.onRunErrorEvent?.call(c),
        );
      case StepStartedEvent():
        return _runEventCallback<StepStartedEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<StepStartedEvent>,
          (s, c) => s.onStepStartedEvent?.call(c),
        );
      case StepFinishedEvent():
        return _runEventCallback<StepFinishedEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<StepFinishedEvent>,
          (s, c) => s.onStepFinishedEvent?.call(c),
        );
      case SubagentStartedEvent():
        return _runEventCallback<SubagentStartedEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<SubagentStartedEvent>,
          (s, c) => s.onSubagentStartedEvent?.call(c),
        );
      case SubagentFinishedEvent():
        return _runEventCallback<SubagentFinishedEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<SubagentFinishedEvent>,
          (s, c) => s.onSubagentFinishedEvent?.call(c),
        );
      case SubagentErrorEvent():
        return _runEventCallback<SubagentErrorEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<SubagentErrorEvent>,
          (s, c) => s.onSubagentErrorEvent?.call(c),
        );
      case TextMessageStartEvent():
        return _runEventCallback<TextMessageStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<TextMessageStartEvent>,
          (s, c) => s.onTextMessageStartEvent?.call(c),
        );
      case TextMessageContentEvent():
        return _runEventCallback<TextMessageContentEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<TextMessageContentEvent>,
          (s, c) => s.onTextMessageContentEvent?.call(c),
        );
      case TextMessageEndEvent():
        return _runEventCallback<TextMessageEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<TextMessageEndEvent>,
          (s, c) => s.onTextMessageEndEvent?.call(c),
        );
      case ToolCallStartEvent():
        return _runEventCallback<ToolCallStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ToolCallStartEvent>,
          (s, c) => s.onToolCallStartEvent?.call(c),
        );
      case ToolCallArgsEvent():
        return _runEventCallback<ToolCallArgsEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ToolCallArgsEvent>,
          (s, c) => s.onToolCallArgsEvent?.call(c),
        );
      case ToolCallEndEvent():
        return _runEventCallback<ToolCallEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ToolCallEndEvent>,
          (s, c) => s.onToolCallEndEvent?.call(c),
        );
      case ToolCallResultEvent():
        return _runEventCallback<ToolCallResultEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ToolCallResultEvent>,
          (s, c) => s.onToolCallResultEvent?.call(c),
        );
      case StateSnapshotEvent():
        return _runEventCallback<StateSnapshotEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<StateSnapshotEvent>,
          (s, c) => s.onStateSnapshotEvent?.call(c),
        );
      case StateDeltaEvent():
        return _runEventCallback<StateDeltaEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<StateDeltaEvent>,
          (s, c) => s.onStateDeltaEvent?.call(c),
        );
      case MessagesSnapshotEvent():
        return _runEventCallback<MessagesSnapshotEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<MessagesSnapshotEvent>,
          (s, c) => s.onMessagesSnapshotEvent?.call(c),
        );
      case ActivitySnapshotEvent():
        return _runEventCallback<ActivitySnapshotEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ActivitySnapshotEvent>,
          (s, c) => s.onActivitySnapshotEvent?.call(c),
        );
      case ActivityDeltaEvent():
        return _runEventCallback<ActivityDeltaEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ActivityDeltaEvent>,
          (s, c) => s.onActivityDeltaEvent?.call(c),
        );
      case RawEvent():
        return _runEventCallback<RawEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<RawEvent>,
          (s, c) => s.onRawEvent?.call(c),
        );
      case CustomEvent():
        return _runEventCallback<CustomEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<CustomEvent>,
          (s, c) => s.onCustomEvent?.call(c),
        );
      case ReasoningStartEvent():
        return _runEventCallback<ReasoningStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ReasoningStartEvent>,
          (s, c) => s.onReasoningStartEvent?.call(c),
        );
      case ReasoningMessageStartEvent():
        return _runEventCallback<ReasoningMessageStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ReasoningMessageStartEvent>,
          (s, c) => s.onReasoningMessageStartEvent?.call(c),
        );
      case ReasoningMessageContentEvent():
        return _runEventCallback<ReasoningMessageContentEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ReasoningMessageContentEvent>,
          (s, c) => s.onReasoningMessageContentEvent?.call(c),
        );
      case ReasoningMessageEndEvent():
        return _runEventCallback<ReasoningMessageEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ReasoningMessageEndEvent>,
          (s, c) => s.onReasoningMessageEndEvent?.call(c),
        );
      case ReasoningEndEvent():
        return _runEventCallback<ReasoningEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ReasoningEndEvent>,
          (s, c) => s.onReasoningEndEvent?.call(c),
        );
      case ReasoningEncryptedValueEvent():
        return _runEventCallback<ReasoningEncryptedValueEvent>(
          currentSubscribers,
          _buildEventContext(event, input)
              as AgentEventContext<ReasoningEncryptedValueEvent>,
          (s, c) => s.onReasoningEncryptedValueEvent?.call(c),
        );
      default:
        return Future.value(const AgentStateMutation());
    }
  }

  Future<Object?> _processEvent(
    BaseEvent event,
    RunAgentInput input,
    List<AgentSubscriber> currentSubscribers,
    Object? result,
  ) async {
    final genericMutation = await _runEventCallback<BaseEvent>(
      currentSubscribers,
      _buildEventContext<BaseEvent>(event, input),
      (s, context) => s.onEvent?.call(context),
    );
    await _applyMutation(genericMutation, input, currentSubscribers);
    if (genericMutation.stopPropagation == true) {
      return result;
    }

    final specificMutation = await _runSpecificEventSubscribers(
      event,
      input,
      currentSubscribers,
    );
    await _applyMutation(specificMutation, input, currentSubscribers);
    if (specificMutation.stopPropagation == true) {
      return result;
    }

    _tallyToolCalls(event);

    final oldMessages = List<Message>.from(messages);
    final oldState = cloneJsonValue(state);

    final appliedStates = await defaultApplyEvents(
      RunAgentInput(
        threadId: input.threadId,
        runId: input.runId,
        parentRunId: input.parentRunId,
        protocolVersion: input.protocolVersion,
        state: state,
        messages: messages,
        tools: input.tools,
        context: input.context,
        forwardedProps: input.forwardedProps,
        resume: input.resume,
      ),
      Stream<BaseEvent>.value(event),
      debugLogger: _debugLogger,
      // The reducer only sees one event at a time here, so interrupts opened by
      // an earlier event of the same run must be seeded or they would be
      // dropped by every intermediate event.
      initialPendingInterrupts: pendingInterrupts,
    ).toList();

    if (appliedStates.isNotEmpty) {
      final latest = appliedStates.last;
      messages = latest.messages;
      state = latest.state;
      pendingInterrupts = List<Interrupt>.from(latest.pendingInterrupts);
      final artifacts = _completedArtifacts(event, oldMessages);
      await _notifyStateChanges(
        input: input,
        subscribers: currentSubscribers,
        oldMessages: oldMessages,
        oldState: oldState,
        newMessages: artifacts.messages,
        newToolCalls: artifacts.toolCalls,
      );
    }

    if (event is RunFinishedEvent &&
        event.outcome is! RunFinishedInterruptOutcome) {
      pendingInterrupts = [];
      return event.result;
    }
    if (event is RunFinishedEvent &&
        event.outcome is RunFinishedInterruptOutcome) {
      pendingInterrupts = List<Interrupt>.from(
        (event.outcome as RunFinishedInterruptOutcome).interrupts,
      );
    }
    return result;
  }

  /// The message and tool-call artifacts this event completed.
  ///
  /// A message is "new" at its closing event, not at its first: `onNewMessage`
  /// has to hand over the finished text and the values only an end event knows.
  /// `onNewToolCall` similarly waits for `TOOL_CALL_END`, when the arguments
  /// are complete.
  ({List<Message> messages, List<ToolCall> toolCalls}) _completedArtifacts(
    BaseEvent event,
    List<Message> oldMessages,
  ) {
    final completedMessages = <Message>[];
    final completedToolCalls = <ToolCall>[];

    Message? byId(String id) =>
        messages.where((message) => message.id == id).firstOrNull;

    switch (event) {
      case TextMessageEndEvent(:final messageId):
      case ReasoningMessageEndEvent(:final messageId):
        final message = byId(messageId);
        if (message != null && message.role != MessageRole.activity) {
          completedMessages.add(message);
        }
      case ToolCallResultEvent(:final messageId):
        final message = byId(messageId);
        if (message != null && message.role == MessageRole.tool) {
          completedMessages.add(message);
        }
      case ToolCallEndEvent(:final toolCallId):
        for (final message in messages.whereType<AssistantMessage>()) {
          final toolCall = (message.toolCalls ?? const <ToolCall>[])
              .where((toolCall) => toolCall.id == toolCallId)
              .firstOrNull;
          if (toolCall != null) {
            completedToolCalls.add(toolCall);
            break;
          }
        }
      case ActivitySnapshotEvent(:final messageId):
        if (!oldMessages.any((old) => old.id == messageId)) {
          final message = byId(messageId);
          if (message != null) {
            completedMessages.add(message);
          }
        }
      default:
        break;
    }

    return (messages: completedMessages, toolCalls: completedToolCalls);
  }

  /// Keeps the run-scoped tool-call tally that [pendingToolCallIds] reads.
  ///
  /// Pending calls are run-scoped: `RUN_STARTED` starts a fresh tally, so a
  /// call left pending by an earlier run cannot leak into a later one.
  void _tallyToolCalls(BaseEvent event) {
    switch (event) {
      case RunStartedEvent():
        _runToolCallIds.clear();
        _answeredToolCallIds.clear();
      case ToolCallStartEvent():
        if (!_runToolCallIds.contains(event.toolCallId)) {
          _runToolCallIds.add(event.toolCallId);
        }
      case ToolCallResultEvent():
        _answeredToolCallIds.add(event.toolCallId);
      default:
        break;
    }
  }

  AgentEventContext<T> _buildEventContext<T extends BaseEvent>(
      T event, RunAgentInput input) {
    if (event is TextMessageContentEvent) {
      final message =
          messages.where((m) => m.id == event.messageId).firstOrNull;
      return AgentEventContext<TextMessageContentEvent>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        textMessageBuffer: switch (message) {
          UserMessage() => message.textContent ?? '',
          _ when message?.content is String => message!.content as String,
          _ => '',
        },
      ) as AgentEventContext<T>;
    }
    if (event is TextMessageEndEvent) {
      final message =
          messages.where((m) => m.id == event.messageId).firstOrNull;
      return AgentEventContext<TextMessageEndEvent>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        textMessageBuffer: switch (message) {
          UserMessage() => message.textContent ?? '',
          _ when message?.content is String => message!.content as String,
          _ => '',
        },
      ) as AgentEventContext<T>;
    }
    if (event is ToolCallArgsEvent || event is ToolCallEndEvent) {
      final toolCallId = event is ToolCallArgsEvent
          ? event.toolCallId
          : (event as ToolCallEndEvent).toolCallId;
      String buffer = '';
      String? toolName;
      Object? parsed;
      for (final message in messages.whereType<AssistantMessage>()) {
        final toolCall = (message.toolCalls ?? const <ToolCall>[])
            .where((toolCall) => toolCall.id == toolCallId)
            .firstOrNull;
        if (toolCall != null) {
          buffer = toolCall.function.arguments;
          toolName = toolCall.function.name;
          parsed = _tryParseJson(buffer) ?? buffer;
          break;
        }
      }
      return AgentEventContext<T>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        toolCallBuffer: buffer,
        toolCallName: toolName,
        partialToolCallArgs: parsed,
        toolCallArgs: parsed,
      );
    }
    if (event is ReasoningMessageContentEvent ||
        event is ReasoningMessageEndEvent) {
      final messageId = event is ReasoningMessageContentEvent
          ? event.messageId
          : (event as ReasoningMessageEndEvent).messageId;
      final message = messages.where((m) => m.id == messageId).firstOrNull;
      return AgentEventContext<T>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        reasoningMessageBuffer:
            message?.content is String ? message!.content as String : '',
      );
    }
    if (event is ActivitySnapshotEvent || event is ActivityDeltaEvent) {
      final messageId = event is ActivitySnapshotEvent
          ? event.messageId
          : (event as ActivityDeltaEvent).messageId;
      final existing = messages.where((m) => m.id == messageId).firstOrNull;
      return AgentEventContext<T>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        existingMessage: existing,
        activityMessage: existing is ActivityMessage ? existing : null,
      );
    }
    if (event is RunFinishedEvent) {
      // Absent means success; a cancelled run carries neither a result nor
      // anything to answer, so its params stay bare.
      final outcome = event.outcome;
      final isInterrupt = outcome is RunFinishedInterruptOutcome;
      final isCancelled = outcome is RunFinishedCancelledOutcome;
      return AgentEventContext<T>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        outcome: isInterrupt
            ? 'interrupt'
            : isCancelled
                ? 'cancelled'
                : 'success',
        result: isCancelled ? null : event.result,
        interrupts: isInterrupt ? outcome.interrupts : null,
        pendingToolCallIds:
            isInterrupt || isCancelled ? null : _pendingToolCallIdsOf(outcome),
      );
    }
    return AgentEventContext<T>(
      messages: List<Message>.from(messages),
      state: state,
      agent: this,
      input: input,
      event: event,
    );
  }

  /// Tool calls a successful run leaves for the application to answer.
  ///
  /// A producer that names `outcome.pendingToolCallIds` is trusted over the
  /// tally; otherwise the specification lets a consumer derive the list from
  /// the stream — every call this run started that got no `TOOL_CALL_RESULT`.
  List<String> _pendingToolCallIdsOf(RunFinishedOutcome? outcome) {
    if (outcome is RunFinishedSuccessOutcome &&
        outcome.pendingToolCallIds.isNotEmpty) {
      return List<String>.from(outcome.pendingToolCallIds);
    }
    return [
      for (final id in _runToolCallIds)
        if (!_answeredToolCallIds.contains(id)) id,
    ];
  }

  Future<void> _applyMutation(
    AgentStateMutation mutation,
    RunAgentInput input,
    List<AgentSubscriber> currentSubscribers,
  ) async {
    final oldMessages = List<Message>.from(messages);
    final oldState = cloneJsonValue(state);
    if (mutation.messages != null) {
      messages = List<Message>.from(mutation.messages!);
    }
    if (mutation.state != null) {
      state = cloneJsonValue(mutation.state);
    }
    if (mutation.messages != null || mutation.state != null) {
      await _notifyStateChanges(
        input: input,
        subscribers: currentSubscribers,
        oldMessages: oldMessages,
        oldState: oldState,
        forceMessagesChanged: mutation.messages != null,
        forceStateChanged: mutation.state != null,
      );
    }
  }

  Future<void> _notifyStateChanges({
    required RunAgentInput input,
    required List<AgentSubscriber> subscribers,
    required List<Message> oldMessages,
    required Object? oldState,
    bool forceMessagesChanged = false,
    bool forceStateChanged = false,
    List<Message>? newMessages,
    List<ToolCall>? newToolCalls,
  }) async {
    final messagesChanged = forceMessagesChanged ||
        !_jsonEquals(
          oldMessages.map((m) => m.toJson()).toList(),
          messages.map((m) => m.toJson()).toList(),
        );
    // Artifacts are announced explicitly on the run path: a message is "new"
    // once its final event closed it, not when its first byte arrived. Callers
    // that mutate the list directly fall back to the id diff.
    final explicitArtifacts = newMessages != null || newToolCalls != null;
    if (explicitArtifacts) {
      for (final message in newMessages ?? const <Message>[]) {
        await _notifyNewMessage(
          message,
          input: input,
          subscribers: subscribers,
        );
      }
      for (final toolCall in newToolCalls ?? const <ToolCall>[]) {
        await _notifyNewToolCall(
          toolCall,
          input: input,
          subscribers: subscribers,
        );
      }
    }
    if (messagesChanged) {
      if (!explicitArtifacts) {
        await _notifyNewMessageArtifacts(
          messages
              .where((message) =>
                  !oldMessages.any((old) => old.id == message.id))
              .toList(),
          input: input,
          subscribersOverride: subscribers,
        );
      }
      await _notifyMessagesChanged(
          input: input, subscribersOverride: subscribers);
    }
    final stateChanged = forceStateChanged || !_jsonEquals(oldState, state);
    if (stateChanged) {
      await _notifyStateChanged(input: input, subscribersOverride: subscribers);
    }
  }

  Future<void> _notifyMessagesChanged({
    required RunAgentInput? input,
    List<AgentSubscriber>? subscribersOverride,
  }) async {
    for (final subscriber in subscribersOverride ?? subscribers) {
      await subscriber.onMessagesChanged?.call(
        AgentSubscriberContext(
          messages: List<Message>.from(messages),
          state: state,
          agent: this,
          input: input,
        ),
      );
    }
  }

  Future<void> _notifyStateChanged({
    required RunAgentInput? input,
    List<AgentSubscriber>? subscribersOverride,
  }) async {
    for (final subscriber in subscribersOverride ?? subscribers) {
      await subscriber.onStateChanged?.call(
        AgentSubscriberContext(
          messages: List<Message>.from(messages),
          state: state,
          agent: this,
          input: input,
        ),
      );
    }
  }

  Future<void> _notifyNewMessageArtifacts(
    List<Message> newMessages, {
    required RunAgentInput? input,
    List<AgentSubscriber>? subscribersOverride,
  }) async {
    final targetSubscribers = subscribersOverride ?? subscribers;
    for (final message in newMessages) {
      await _notifyNewMessage(
        message,
        input: input,
        subscribers: targetSubscribers,
      );
      if (message is AssistantMessage && message.toolCalls != null) {
        for (final toolCall in message.toolCalls!) {
          await _notifyNewToolCall(
            toolCall,
            input: input,
            subscribers: targetSubscribers,
          );
        }
      }
    }
  }

  Future<void> _notifyNewMessage(
    Message message, {
    required RunAgentInput? input,
    required List<AgentSubscriber> subscribers,
  }) async {
    for (final subscriber in subscribers) {
      await subscriber.onNewMessage?.call(
        NewMessageContext(
          message: message,
          messages: List<Message>.from(messages),
          state: state,
          agent: this,
          input: input,
        ),
      );
    }
  }

  Future<void> _notifyNewToolCall(
    ToolCall toolCall, {
    required RunAgentInput? input,
    required List<AgentSubscriber> subscribers,
  }) async {
    for (final subscriber in subscribers) {
      await subscriber.onNewToolCall?.call(
        NewToolCallContext(
          toolCall: toolCall,
          messages: List<Message>.from(messages),
          state: state,
          agent: this,
          input: input,
        ),
      );
    }
  }

  static bool _jsonEquals(Object? left, Object? right) {
    return jsonEncode(normalizeJsonValue(left)) ==
        jsonEncode(normalizeJsonValue(right));
  }

  static Object? _tryParseJson(String value) {
    if (value.isEmpty) {
      return '';
    }
    try {
      return jsonDecode(value);
    } catch (_) {
      return null;
    }
  }

  static String _generateId(String prefix) {
    final random = Random().nextInt(1 << 32);
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-$random';
  }

  static int _compareVersions(String left, String right) {
    final leftParts =
        left.split('.').map((part) => int.tryParse(part) ?? 0).toList();
    final rightParts =
        right.split('.').map((part) => int.tryParse(part) ?? 0).toList();
    final length = max(leftParts.length, rightParts.length);

    for (var i = 0; i < length; i++) {
      final leftValue = i < leftParts.length ? leftParts[i] : 0;
      final rightValue = i < rightParts.length ? rightParts[i] : 0;
      if (leftValue != rightValue) {
        return leftValue.compareTo(rightValue);
      }
    }

    return 0;
  }

  List<Message> _collectNewMessages(Set<String> existingMessageIds) {
    return messages
        .where((message) => !existingMessageIds.contains(message.id))
        .toList();
  }
}

class StreamSubscriptionHandle {
  final void Function() onUnsubscribe;

  const StreamSubscriptionHandle({
    required this.onUnsubscribe,
  });

  void unsubscribe() => onUnsubscribe();
}

class _MiddlewareAgentProxy extends AbstractAgent {
  final AbstractAgent owner;
  final AbstractAgent next;
  final Middleware middleware;

  _MiddlewareAgentProxy(this.owner, this.next, this.middleware) : super();

  @override
  AbstractAgent createClone() => owner.createClone();

  @override
  Stream<BaseEvent> run(RunAgentInput input) => middleware.run(input, next);
}
