library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../apply/default.dart';
import '../debug_logger.dart';
import '../apply/json_patch.dart';
import '../events/events.dart';
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

  AbstractAgent({
    AgentConfig config = const AgentConfig(),
  }) : agentId = config.agentId,
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

  String get maxVersion => '0.0.53';

  Stream<BaseEvent> run(RunAgentInput input);

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
      throw ArgumentError('Unsupported middleware type: ${middleware.runtimeType}');
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

    final input = prepareRunAgentInput(parameters);

    try {
      if (!useConnect) {
        _debugLogger?.lifecycle('LIFECYCLE', 'Run started:', {
          'agentId': agentId,
          'threadId': threadId,
        });
      }
      await _onInitialize(input, allSubscribers);

      final stream = useConnect ? connect(input) : _runWithMiddlewares(input);
      final processed = verifyEvents(
        transformChunks(stream, debugLogger: _debugLogger),
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
      if (swallowConnectNotImplemented && error is AGUIConnectNotImplementedError) {
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
    final sanitizedMessages = messages
        .where((message) => message.role != MessageRole.activity)
        .toList();
    return RunAgentInput(
      threadId: threadId,
      runId: parameters.runId ?? _generateId('run'),
      state: cloneJsonValue(state),
      messages: sanitizedMessages,
      tools: List<Tool>.from(parameters.tools ?? const []),
      context: List<Context>.from(parameters.context ?? const []),
      forwardedProps: cloneJsonValue(parameters.forwardedProps ?? <String, dynamic>{}),
      resume: parameters.resume == null ? null : List<ResumeEntry>.from(parameters.resume!),
    );
  }

  Future<void> _onInitialize(
    RunAgentInput input,
    List<AgentSubscriber> currentSubscribers,
  ) async {
    if (pendingInterrupts.isNotEmpty) {
      final resumeIds = (input.resume ?? const <ResumeEntry>[])
          .map((entry) => entry.interruptId)
          .toSet();
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
        if (_isInterruptExpired(interrupt)) {
          throw AGUIError('Interrupt ${interrupt.id} expired at ${interrupt.expiresAt}');
        }
      }
    }

    final mutation = await runSubscribersWithMutation(
      subscribers: currentSubscribers,
      initialMessages: messages,
      initialState: state,
      executor: (subscriber, nextMessages, nextState) => subscriber.onRunInitialized?.call(
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

  Future<bool> _onError(
    RunAgentInput input,
    Object error,
    List<AgentSubscriber> currentSubscribers,
  ) async {
    final mutation = await runSubscribersWithMutation(
      subscribers: currentSubscribers,
      initialMessages: messages,
      initialState: state,
      executor: (subscriber, nextMessages, nextState) => subscriber.onRunFailed?.call(
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
      executor: (subscriber, nextMessages, nextState) => subscriber.onRunFinalized?.call(
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
    if (_middlewares.isEmpty) {
      return run(input);
    }

    AbstractAgent next = this;
    for (final middleware in _middlewares.reversed) {
      next = _MiddlewareAgentProxy(this, next, middleware);
    }
    return next.run(input);
  }

  void _ensureCompatibilityMiddlewares() {
    if (_compatibilityMiddlewaresInitialized) {
      return;
    }
    _compatibilityMiddlewaresInitialized = true;

    if (_compareVersions(maxVersion, '0.0.39') <= 0) {
      _middlewares.insert(0, BackwardCompatibility_0_0_39());
    }
    if (_compareVersions(maxVersion, '0.0.45') <= 0) {
      _middlewares.insert(0, BackwardCompatibility_0_0_45());
    }
    if (_compareVersions(maxVersion, '0.0.47') <= 0) {
      _middlewares.insert(0, BackwardCompatibility_0_0_47());
    }
  }

  Future<AgentStateMutation> _runEventCallback<T extends BaseEvent>(
    List<AgentSubscriber> currentSubscribers,
    AgentEventContext<T> context,
    FutureOr<AgentStateMutation?> Function(
      AgentSubscriber subscriber,
      AgentEventContext<T> context,
    )
    callback,
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
          _buildEventContext(event, input) as AgentEventContext<RunStartedEvent>,
          (s, c) => s.onRunStartedEvent?.call(c),
        );
      case RunFinishedEvent():
        return _runEventCallback<RunFinishedEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<RunFinishedEvent>,
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
          _buildEventContext(event, input) as AgentEventContext<StepStartedEvent>,
          (s, c) => s.onStepStartedEvent?.call(c),
        );
      case StepFinishedEvent():
        return _runEventCallback<StepFinishedEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<StepFinishedEvent>,
          (s, c) => s.onStepFinishedEvent?.call(c),
        );
      case TextMessageStartEvent():
        return _runEventCallback<TextMessageStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<TextMessageStartEvent>,
          (s, c) => s.onTextMessageStartEvent?.call(c),
        );
      case TextMessageContentEvent():
        return _runEventCallback<TextMessageContentEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<TextMessageContentEvent>,
          (s, c) => s.onTextMessageContentEvent?.call(c),
        );
      case TextMessageEndEvent():
        return _runEventCallback<TextMessageEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<TextMessageEndEvent>,
          (s, c) => s.onTextMessageEndEvent?.call(c),
        );
      case ToolCallStartEvent():
        return _runEventCallback<ToolCallStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ToolCallStartEvent>,
          (s, c) => s.onToolCallStartEvent?.call(c),
        );
      case ToolCallArgsEvent():
        return _runEventCallback<ToolCallArgsEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ToolCallArgsEvent>,
          (s, c) => s.onToolCallArgsEvent?.call(c),
        );
      case ToolCallEndEvent():
        return _runEventCallback<ToolCallEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ToolCallEndEvent>,
          (s, c) => s.onToolCallEndEvent?.call(c),
        );
      case ToolCallResultEvent():
        return _runEventCallback<ToolCallResultEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ToolCallResultEvent>,
          (s, c) => s.onToolCallResultEvent?.call(c),
        );
      case StateSnapshotEvent():
        return _runEventCallback<StateSnapshotEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<StateSnapshotEvent>,
          (s, c) => s.onStateSnapshotEvent?.call(c),
        );
      case StateDeltaEvent():
        return _runEventCallback<StateDeltaEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<StateDeltaEvent>,
          (s, c) => s.onStateDeltaEvent?.call(c),
        );
      case MessagesSnapshotEvent():
        return _runEventCallback<MessagesSnapshotEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<MessagesSnapshotEvent>,
          (s, c) => s.onMessagesSnapshotEvent?.call(c),
        );
      case ActivitySnapshotEvent():
        return _runEventCallback<ActivitySnapshotEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ActivitySnapshotEvent>,
          (s, c) => s.onActivitySnapshotEvent?.call(c),
        );
      case ActivityDeltaEvent():
        return _runEventCallback<ActivityDeltaEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ActivityDeltaEvent>,
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
          _buildEventContext(event, input) as AgentEventContext<ReasoningStartEvent>,
          (s, c) => s.onReasoningStartEvent?.call(c),
        );
      case ReasoningMessageStartEvent():
        return _runEventCallback<ReasoningMessageStartEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ReasoningMessageStartEvent>,
          (s, c) => s.onReasoningMessageStartEvent?.call(c),
        );
      case ReasoningMessageContentEvent():
        return _runEventCallback<ReasoningMessageContentEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ReasoningMessageContentEvent>,
          (s, c) => s.onReasoningMessageContentEvent?.call(c),
        );
      case ReasoningMessageEndEvent():
        return _runEventCallback<ReasoningMessageEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ReasoningMessageEndEvent>,
          (s, c) => s.onReasoningMessageEndEvent?.call(c),
        );
      case ReasoningEndEvent():
        return _runEventCallback<ReasoningEndEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ReasoningEndEvent>,
          (s, c) => s.onReasoningEndEvent?.call(c),
        );
      case ReasoningEncryptedValueEvent():
        return _runEventCallback<ReasoningEncryptedValueEvent>(
          currentSubscribers,
          _buildEventContext(event, input) as AgentEventContext<ReasoningEncryptedValueEvent>,
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

    final oldMessages = List<Message>.from(messages);
    final oldState = cloneJsonValue(state);

    final appliedStates = await defaultApplyEvents(
      RunAgentInput(
        threadId: input.threadId,
        runId: input.runId,
        parentRunId: input.parentRunId,
        state: state,
        messages: messages,
        tools: input.tools,
        context: input.context,
        forwardedProps: input.forwardedProps,
        resume: input.resume,
      ),
      Stream<BaseEvent>.value(event),
        debugLogger: _debugLogger,
    ).toList();

    if (appliedStates.isNotEmpty) {
      final latest = appliedStates.last;
      messages = latest.messages;
      state = latest.state;
      pendingInterrupts = List<Interrupt>.from(latest.pendingInterrupts);
      await _notifyStateChanges(
        input: input,
        subscribers: currentSubscribers,
        oldMessages: oldMessages,
        oldState: oldState,
      );
    }

    if (event is RunFinishedEvent && event.outcome is! RunFinishedInterruptOutcome) {
      pendingInterrupts = [];
      return event.result;
    }
    if (event is RunFinishedEvent && event.outcome is RunFinishedInterruptOutcome) {
      pendingInterrupts = List<Interrupt>.from(
        (event.outcome as RunFinishedInterruptOutcome).interrupts,
      );
    }
    return result;
  }

  AgentEventContext<T> _buildEventContext<T extends BaseEvent>(T event, RunAgentInput input) {
    if (event is TextMessageContentEvent) {
      final message = messages.where((m) => m.id == event.messageId).firstOrNull;
      return AgentEventContext<TextMessageContentEvent>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        textMessageBuffer: message?.content is String ? message!.content as String : '',
      ) as AgentEventContext<T>;
    }
    if (event is TextMessageEndEvent) {
      final message = messages.where((m) => m.id == event.messageId).firstOrNull;
      return AgentEventContext<TextMessageEndEvent>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        textMessageBuffer: message?.content is String ? message!.content as String : '',
      ) as AgentEventContext<T>;
    }
    if (event is ToolCallArgsEvent || event is ToolCallEndEvent) {
      final toolCallId = event is ToolCallArgsEvent ? event.toolCallId : (event as ToolCallEndEvent).toolCallId;
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
    if (event is ReasoningMessageContentEvent || event is ReasoningMessageEndEvent) {
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
        reasoningMessageBuffer: message?.content is String ? message!.content as String : '',
      );
    }
    if (event is ActivitySnapshotEvent || event is ActivityDeltaEvent) {
      final messageId = event is ActivitySnapshotEvent ? event.messageId : (event as ActivityDeltaEvent).messageId;
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
      return AgentEventContext<T>(
        messages: List<Message>.from(messages),
        state: state,
        agent: this,
        input: input,
        event: event,
        outcome: event.outcome is RunFinishedInterruptOutcome ? 'interrupt' : 'success',
        result: event.result,
        interrupts: event.outcome is RunFinishedInterruptOutcome
            ? (event.outcome as RunFinishedInterruptOutcome).interrupts
            : null,
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
  }) async {
    final messagesChanged = forceMessagesChanged ||
        !_jsonEquals(
          oldMessages.map((m) => m.toJson()).toList(),
          messages.map((m) => m.toJson()).toList(),
        );
    if (messagesChanged) {
      await _notifyNewMessageArtifacts(
        messages.where((message) => !oldMessages.any((old) => old.id == message.id)).toList(),
        input: input,
        subscribersOverride: subscribers,
      );
      await _notifyMessagesChanged(input: input, subscribersOverride: subscribers);
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
      for (final subscriber in targetSubscribers) {
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
      if (message is AssistantMessage && message.toolCalls != null) {
        for (final toolCall in message.toolCalls!) {
          for (final subscriber in targetSubscribers) {
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
      }
    }
  }

  bool _isInterruptExpired(Interrupt interrupt) {
    if (interrupt.expiresAt == null) {
      return false;
    }
    final parsed = DateTime.tryParse(interrupt.expiresAt!);
    if (parsed == null) {
      return false;
    }
    return parsed.isBefore(DateTime.now().toUtc());
  }

  static bool _jsonEquals(Object? left, Object? right) {
    return jsonEncode(left) == jsonEncode(right);
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
    final leftParts = left.split('.').map((part) => int.tryParse(part) ?? 0).toList();
    final rightParts = right.split('.').map((part) => int.tryParse(part) ?? 0).toList();
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
