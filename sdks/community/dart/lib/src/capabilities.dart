/// Agent capability models for the AG-UI 1.0 protocol.
library;

import 'types/base.dart';

/// Deep-copies a JSON value so models never share mutable collections with
/// their inputs or outputs.
dynamic _copyJsonValue(dynamic value) {
  if (value is Map) {
    return value.map<String, dynamic>(
      (key, item) => MapEntry(key as String, _copyJsonValue(item)),
    );
  }
  if (value is List) {
    return value.map<dynamic>(_copyJsonValue).toList();
  }
  return value;
}

Map<String, dynamic>? _copyJsonMap(Map<String, dynamic>? value) {
  if (value == null) {
    return null;
  }
  return _copyJsonValue(value) as Map<String, dynamic>;
}

/// Encodes a value that may hold either a model or raw JSON.
dynamic _encodeJsonValue(dynamic value) {
  if (value is AGUIModel) {
    return value.toJson();
  }
  return _copyJsonValue(value);
}

/// Describes a subagent that can be invoked by a parent agent.
class SubAgentInfo extends AGUIModel {
  final String name;
  final String? description;

  const SubAgentInfo({
    required this.name,
    this.description,
  });

  factory SubAgentInfo.fromJson(Map<String, dynamic> json) {
    return SubAgentInfo(
      name: JsonDecoder.requireField<String>(json, 'name'),
      description: JsonDecoder.optionalField<String>(json, 'description'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
      };

  @override
  SubAgentInfo copyWith({
    String? name,
    String? description,
  }) {
    return SubAgentInfo(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

/// Schema-aligned alias for [SubAgentInfo].
typedef SubagentInfo = SubAgentInfo;

/// Basic metadata about the agent.
class IdentityCapabilities extends AGUIModel {
  final String? name;
  final String? type;
  final String? description;
  final String? version;
  final String? provider;
  final String? documentationUrl;
  final Map<String, dynamic>? metadata;

  const IdentityCapabilities({
    this.name,
    this.type,
    this.description,
    this.version,
    this.provider,
    this.documentationUrl,
    this.metadata,
  });

  factory IdentityCapabilities.fromJson(Map<String, dynamic> json) {
    return IdentityCapabilities(
      name: JsonDecoder.optionalField<String>(json, 'name'),
      type: JsonDecoder.optionalField<String>(json, 'type'),
      description: JsonDecoder.optionalField<String>(json, 'description'),
      version: JsonDecoder.optionalField<String>(json, 'version'),
      provider: JsonDecoder.optionalField<String>(json, 'provider'),
      documentationUrl:
          JsonDecoder.optionalField<String>(json, 'documentationUrl'),
      metadata: _copyJsonMap(
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'metadata'),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (type != null) 'type': type,
        if (description != null) 'description': description,
        if (version != null) 'version': version,
        if (provider != null) 'provider': provider,
        if (documentationUrl != null) 'documentationUrl': documentationUrl,
        if (metadata != null) 'metadata': _copyJsonMap(metadata),
      };

  @override
  IdentityCapabilities copyWith({
    String? name,
    String? type,
    String? description,
    String? version,
    String? provider,
    String? documentationUrl,
    Map<String, dynamic>? metadata,
  }) {
    return IdentityCapabilities(
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      version: version ?? this.version,
      provider: provider ?? this.provider,
      documentationUrl: documentationUrl ?? this.documentationUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Declares which transport mechanisms the agent supports.
class TransportCapabilities extends AGUIModel {
  final bool? streaming;
  final bool? websocket;
  final bool? httpBinary;
  final bool? pushNotifications;
  final bool? resumable;

  const TransportCapabilities({
    this.streaming,
    this.websocket,
    this.httpBinary,
    this.pushNotifications,
    this.resumable,
  });

  factory TransportCapabilities.fromJson(Map<String, dynamic> json) {
    return TransportCapabilities(
      streaming: JsonDecoder.optionalField<bool>(json, 'streaming'),
      websocket: JsonDecoder.optionalField<bool>(json, 'websocket'),
      httpBinary: JsonDecoder.optionalField<bool>(json, 'httpBinary'),
      pushNotifications:
          JsonDecoder.optionalField<bool>(json, 'pushNotifications'),
      resumable: JsonDecoder.optionalField<bool>(json, 'resumable'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (streaming != null) 'streaming': streaming,
        if (websocket != null) 'websocket': websocket,
        if (httpBinary != null) 'httpBinary': httpBinary,
        if (pushNotifications != null) 'pushNotifications': pushNotifications,
        if (resumable != null) 'resumable': resumable,
      };

  @override
  TransportCapabilities copyWith({
    bool? streaming,
    bool? websocket,
    bool? httpBinary,
    bool? pushNotifications,
    bool? resumable,
  }) {
    return TransportCapabilities(
      streaming: streaming ?? this.streaming,
      websocket: websocket ?? this.websocket,
      httpBinary: httpBinary ?? this.httpBinary,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      resumable: resumable ?? this.resumable,
    );
  }
}

/// Tool calling capabilities.
class ToolsCapabilities extends AGUIModel {
  final bool? supported;
  final List<Object>? items;
  final bool? parallelCalls;
  final bool? clientProvided;

  const ToolsCapabilities({
    this.supported,
    this.items,
    this.parallelCalls,
    this.clientProvided,
  });

  factory ToolsCapabilities.fromJson(Map<String, dynamic> json) {
    final items = JsonDecoder.optionalListField<dynamic>(json, 'items');

    return ToolsCapabilities(
      supported: JsonDecoder.optionalField<bool>(json, 'supported'),
      items: items?.map<Object>((item) => _copyJsonValue(item) as Object).toList(),
      parallelCalls: JsonDecoder.optionalField<bool>(json, 'parallelCalls'),
      clientProvided: JsonDecoder.optionalField<bool>(json, 'clientProvided'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (supported != null) 'supported': supported,
        if (items != null) 'items': items!.map(_encodeJsonValue).toList(),
        if (parallelCalls != null) 'parallelCalls': parallelCalls,
        if (clientProvided != null) 'clientProvided': clientProvided,
      };

  @override
  ToolsCapabilities copyWith({
    bool? supported,
    List<Object>? items,
    bool? parallelCalls,
    bool? clientProvided,
  }) {
    return ToolsCapabilities(
      supported: supported ?? this.supported,
      items: items ?? this.items,
      parallelCalls: parallelCalls ?? this.parallelCalls,
      clientProvided: clientProvided ?? this.clientProvided,
    );
  }
}

/// Output format support.
class OutputCapabilities extends AGUIModel {
  final bool? structuredOutput;
  final List<String>? supportedMimeTypes;

  const OutputCapabilities({
    this.structuredOutput,
    this.supportedMimeTypes,
  });

  factory OutputCapabilities.fromJson(Map<String, dynamic> json) {
    return OutputCapabilities(
      structuredOutput:
          JsonDecoder.optionalField<bool>(json, 'structuredOutput'),
      supportedMimeTypes: JsonDecoder.optionalListField<String>(
        json,
        'supportedMimeTypes',
      )?.toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (structuredOutput != null) 'structuredOutput': structuredOutput,
        if (supportedMimeTypes != null)
          'supportedMimeTypes': supportedMimeTypes!.toList(),
      };

  @override
  OutputCapabilities copyWith({
    bool? structuredOutput,
    List<String>? supportedMimeTypes,
  }) {
    return OutputCapabilities(
      structuredOutput: structuredOutput ?? this.structuredOutput,
      supportedMimeTypes: supportedMimeTypes ?? this.supportedMimeTypes,
    );
  }
}

/// State and memory management capabilities.
class StateCapabilities extends AGUIModel {
  final bool? snapshots;
  final bool? deltas;
  final bool? memory;
  final bool? persistentState;

  const StateCapabilities({
    this.snapshots,
    this.deltas,
    this.memory,
    this.persistentState,
  });

  factory StateCapabilities.fromJson(Map<String, dynamic> json) {
    return StateCapabilities(
      snapshots: JsonDecoder.optionalField<bool>(json, 'snapshots'),
      deltas: JsonDecoder.optionalField<bool>(json, 'deltas'),
      memory: JsonDecoder.optionalField<bool>(json, 'memory'),
      persistentState:
          JsonDecoder.optionalField<bool>(json, 'persistentState'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (snapshots != null) 'snapshots': snapshots,
        if (deltas != null) 'deltas': deltas,
        if (memory != null) 'memory': memory,
        if (persistentState != null) 'persistentState': persistentState,
      };

  @override
  StateCapabilities copyWith({
    bool? snapshots,
    bool? deltas,
    bool? memory,
    bool? persistentState,
  }) {
    return StateCapabilities(
      snapshots: snapshots ?? this.snapshots,
      deltas: deltas ?? this.deltas,
      memory: memory ?? this.memory,
      persistentState: persistentState ?? this.persistentState,
    );
  }
}

/// Multi-agent coordination capabilities.
class MultiAgentCapabilities extends AGUIModel {
  final bool? supported;
  final bool? delegation;
  final bool? handoffs;
  final List<SubAgentInfo>? subAgents;

  const MultiAgentCapabilities({
    this.supported,
    this.delegation,
    this.handoffs,
    this.subAgents,
  });

  factory MultiAgentCapabilities.fromJson(Map<String, dynamic> json) {
    final subAgents = JsonDecoder.optionalListField<Map<String, dynamic>>(
      json,
      'subagents',
      itemTransform: (item) => Map<String, dynamic>.from(item as Map),
    ) ??
        JsonDecoder.optionalListField<Map<String, dynamic>>(
          json,
          'subAgents',
          itemTransform: (item) => Map<String, dynamic>.from(item as Map),
        );

    return MultiAgentCapabilities(
      supported: JsonDecoder.optionalField<bool>(json, 'supported'),
      delegation: JsonDecoder.optionalField<bool>(json, 'delegation'),
      handoffs: JsonDecoder.optionalField<bool>(json, 'handoffs'),
      subAgents: subAgents?.map(SubAgentInfo.fromJson).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (supported != null) 'supported': supported,
        if (delegation != null) 'delegation': delegation,
        if (handoffs != null) 'handoffs': handoffs,
        // Schema key is `subagents`; the Dart field keeps its historical name.
        if (subAgents != null)
          'subagents': subAgents!.map((item) => item.toJson()).toList(),
      };

  @override
  MultiAgentCapabilities copyWith({
    bool? supported,
    bool? delegation,
    bool? handoffs,
    List<SubAgentInfo>? subAgents,
  }) {
    return MultiAgentCapabilities(
      supported: supported ?? this.supported,
      delegation: delegation ?? this.delegation,
      handoffs: handoffs ?? this.handoffs,
      subAgents: subAgents ?? this.subAgents,
    );
  }
}

/// Reasoning and thinking capabilities.
class ReasoningCapabilities extends AGUIModel {
  final bool? supported;
  final bool? streaming;
  final bool? encrypted;

  const ReasoningCapabilities({
    this.supported,
    this.streaming,
    this.encrypted,
  });

  factory ReasoningCapabilities.fromJson(Map<String, dynamic> json) {
    return ReasoningCapabilities(
      supported: JsonDecoder.optionalField<bool>(json, 'supported'),
      streaming: JsonDecoder.optionalField<bool>(json, 'streaming'),
      encrypted: JsonDecoder.optionalField<bool>(json, 'encrypted'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (supported != null) 'supported': supported,
        if (streaming != null) 'streaming': streaming,
        if (encrypted != null) 'encrypted': encrypted,
      };

  @override
  ReasoningCapabilities copyWith({
    bool? supported,
    bool? streaming,
    bool? encrypted,
  }) {
    return ReasoningCapabilities(
      supported: supported ?? this.supported,
      streaming: streaming ?? this.streaming,
      encrypted: encrypted ?? this.encrypted,
    );
  }
}

/// Modalities the agent can accept as input.
class MultimodalInputCapabilities extends AGUIModel {
  final bool? image;
  final bool? audio;
  final bool? video;
  final bool? pdf;
  final bool? file;

  const MultimodalInputCapabilities({
    this.image,
    this.audio,
    this.video,
    this.pdf,
    this.file,
  });

  factory MultimodalInputCapabilities.fromJson(Map<String, dynamic> json) {
    return MultimodalInputCapabilities(
      image: JsonDecoder.optionalField<bool>(json, 'image'),
      audio: JsonDecoder.optionalField<bool>(json, 'audio'),
      video: JsonDecoder.optionalField<bool>(json, 'video'),
      pdf: JsonDecoder.optionalField<bool>(json, 'pdf'),
      file: JsonDecoder.optionalField<bool>(json, 'file'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (image != null) 'image': image,
        if (audio != null) 'audio': audio,
        if (video != null) 'video': video,
        if (pdf != null) 'pdf': pdf,
        if (file != null) 'file': file,
      };

  @override
  MultimodalInputCapabilities copyWith({
    bool? image,
    bool? audio,
    bool? video,
    bool? pdf,
    bool? file,
  }) {
    return MultimodalInputCapabilities(
      image: image ?? this.image,
      audio: audio ?? this.audio,
      video: video ?? this.video,
      pdf: pdf ?? this.pdf,
      file: file ?? this.file,
    );
  }
}

/// Modalities the agent can produce as output.
class MultimodalOutputCapabilities extends AGUIModel {
  final bool? image;
  final bool? audio;

  const MultimodalOutputCapabilities({
    this.image,
    this.audio,
  });

  factory MultimodalOutputCapabilities.fromJson(Map<String, dynamic> json) {
    return MultimodalOutputCapabilities(
      image: JsonDecoder.optionalField<bool>(json, 'image'),
      audio: JsonDecoder.optionalField<bool>(json, 'audio'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (image != null) 'image': image,
        if (audio != null) 'audio': audio,
      };

  @override
  MultimodalOutputCapabilities copyWith({
    bool? image,
    bool? audio,
  }) {
    return MultimodalOutputCapabilities(
      image: image ?? this.image,
      audio: audio ?? this.audio,
    );
  }
}

/// Multimodal input and output support.
class MultimodalCapabilities extends AGUIModel {
  final MultimodalInputCapabilities? input;
  final MultimodalOutputCapabilities? output;

  const MultimodalCapabilities({
    this.input,
    this.output,
  });

  factory MultimodalCapabilities.fromJson(Map<String, dynamic> json) {
    final input = JsonDecoder.optionalField<Map<String, dynamic>>(json, 'input');
    final output =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'output');

    return MultimodalCapabilities(
      input: input == null ? null : MultimodalInputCapabilities.fromJson(input),
      output:
          output == null ? null : MultimodalOutputCapabilities.fromJson(output),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (input != null) 'input': input!.toJson(),
        if (output != null) 'output': output!.toJson(),
      };

  @override
  MultimodalCapabilities copyWith({
    MultimodalInputCapabilities? input,
    MultimodalOutputCapabilities? output,
  }) {
    return MultimodalCapabilities(
      input: input ?? this.input,
      output: output ?? this.output,
    );
  }
}

/// Execution control and limits.
class ExecutionCapabilities extends AGUIModel {
  final bool? codeExecution;
  final bool? sandboxed;
  final int? maxIterations;
  final int? maxExecutionTime;

  const ExecutionCapabilities({
    this.codeExecution,
    this.sandboxed,
    this.maxIterations,
    this.maxExecutionTime,
  });

  factory ExecutionCapabilities.fromJson(Map<String, dynamic> json) {
    return ExecutionCapabilities(
      codeExecution: JsonDecoder.optionalField<bool>(json, 'codeExecution'),
      sandboxed: JsonDecoder.optionalField<bool>(json, 'sandboxed'),
      maxIterations: JsonDecoder.optionalField<int>(
        json,
        'maxIterations',
        transform: (value) => (value as num).toInt(),
      ),
      maxExecutionTime: JsonDecoder.optionalField<int>(
        json,
        'maxExecutionTime',
        transform: (value) => (value as num).toInt(),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (codeExecution != null) 'codeExecution': codeExecution,
        if (sandboxed != null) 'sandboxed': sandboxed,
        if (maxIterations != null) 'maxIterations': maxIterations,
        if (maxExecutionTime != null) 'maxExecutionTime': maxExecutionTime,
      };

  @override
  ExecutionCapabilities copyWith({
    bool? codeExecution,
    bool? sandboxed,
    int? maxIterations,
    int? maxExecutionTime,
  }) {
    return ExecutionCapabilities(
      codeExecution: codeExecution ?? this.codeExecution,
      sandboxed: sandboxed ?? this.sandboxed,
      maxIterations: maxIterations ?? this.maxIterations,
      maxExecutionTime: maxExecutionTime ?? this.maxExecutionTime,
    );
  }
}

/// Human-in-the-loop interaction support.
class HumanInTheLoopCapabilities extends AGUIModel {
  final bool? supported;
  final bool? approvals;
  final bool? interventions;
  final bool? feedback;
  final bool? interrupts;
  final bool? approveWithEdits;

  const HumanInTheLoopCapabilities({
    this.supported,
    this.approvals,
    this.interventions,
    this.feedback,
    this.interrupts,
    this.approveWithEdits,
  });

  factory HumanInTheLoopCapabilities.fromJson(Map<String, dynamic> json) {
    return HumanInTheLoopCapabilities(
      supported: JsonDecoder.optionalField<bool>(json, 'supported'),
      approvals: JsonDecoder.optionalField<bool>(json, 'approvals'),
      interventions: JsonDecoder.optionalField<bool>(json, 'interventions'),
      feedback: JsonDecoder.optionalField<bool>(json, 'feedback'),
      interrupts: JsonDecoder.optionalField<bool>(json, 'interrupts'),
      approveWithEdits:
          JsonDecoder.optionalField<bool>(json, 'approveWithEdits'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (supported != null) 'supported': supported,
        if (approvals != null) 'approvals': approvals,
        if (interventions != null) 'interventions': interventions,
        if (feedback != null) 'feedback': feedback,
        if (interrupts != null) 'interrupts': interrupts,
        if (approveWithEdits != null) 'approveWithEdits': approveWithEdits,
      };

  @override
  HumanInTheLoopCapabilities copyWith({
    bool? supported,
    bool? approvals,
    bool? interventions,
    bool? feedback,
    bool? interrupts,
    bool? approveWithEdits,
  }) {
    return HumanInTheLoopCapabilities(
      supported: supported ?? this.supported,
      approvals: approvals ?? this.approvals,
      interventions: interventions ?? this.interventions,
      feedback: feedback ?? this.feedback,
      interrupts: interrupts ?? this.interrupts,
      approveWithEdits: approveWithEdits ?? this.approveWithEdits,
    );
  }
}

/// A typed, categorized snapshot of an agent's current capabilities.
class AgentCapabilities extends AGUIModel {
  final IdentityCapabilities? identity;
  final TransportCapabilities? transport;
  final ToolsCapabilities? tools;
  final OutputCapabilities? output;
  final StateCapabilities? state;
  final MultiAgentCapabilities? multiAgent;
  final ReasoningCapabilities? reasoning;
  final MultimodalCapabilities? multimodal;
  final ExecutionCapabilities? execution;
  final HumanInTheLoopCapabilities? humanInTheLoop;
  final Map<String, dynamic>? custom;

  const AgentCapabilities({
    this.identity,
    this.transport,
    this.tools,
    this.output,
    this.state,
    this.multiAgent,
    this.reasoning,
    this.multimodal,
    this.execution,
    this.humanInTheLoop,
    this.custom,
  });

  factory AgentCapabilities.fromJson(Map<String, dynamic> json) {
    final identity =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'identity');
    final transport =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'transport');
    final tools = JsonDecoder.optionalField<Map<String, dynamic>>(json, 'tools');
    final output =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'output');
    final state = JsonDecoder.optionalField<Map<String, dynamic>>(json, 'state');
    final multiAgent =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'multiAgent');
    final reasoning =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'reasoning');
    final multimodal =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'multimodal');
    final execution =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'execution');
    final humanInTheLoop =
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'humanInTheLoop');

    return AgentCapabilities(
      identity:
          identity == null ? null : IdentityCapabilities.fromJson(identity),
      transport:
          transport == null ? null : TransportCapabilities.fromJson(transport),
      tools: tools == null ? null : ToolsCapabilities.fromJson(tools),
      output: output == null ? null : OutputCapabilities.fromJson(output),
      state: state == null ? null : StateCapabilities.fromJson(state),
      multiAgent:
          multiAgent == null ? null : MultiAgentCapabilities.fromJson(multiAgent),
      reasoning:
          reasoning == null ? null : ReasoningCapabilities.fromJson(reasoning),
      multimodal:
          multimodal == null ? null : MultimodalCapabilities.fromJson(multimodal),
      execution:
          execution == null ? null : ExecutionCapabilities.fromJson(execution),
      humanInTheLoop: humanInTheLoop == null
          ? null
          : HumanInTheLoopCapabilities.fromJson(humanInTheLoop),
      custom: _copyJsonMap(
        JsonDecoder.optionalField<Map<String, dynamic>>(json, 'custom'),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        if (identity != null) 'identity': identity!.toJson(),
        if (transport != null) 'transport': transport!.toJson(),
        if (tools != null) 'tools': tools!.toJson(),
        if (output != null) 'output': output!.toJson(),
        if (state != null) 'state': state!.toJson(),
        if (multiAgent != null) 'multiAgent': multiAgent!.toJson(),
        if (reasoning != null) 'reasoning': reasoning!.toJson(),
        if (multimodal != null) 'multimodal': multimodal!.toJson(),
        if (execution != null) 'execution': execution!.toJson(),
        if (humanInTheLoop != null) 'humanInTheLoop': humanInTheLoop!.toJson(),
        if (custom != null) 'custom': _copyJsonMap(custom),
      };

  @override
  AgentCapabilities copyWith({
    IdentityCapabilities? identity,
    TransportCapabilities? transport,
    ToolsCapabilities? tools,
    OutputCapabilities? output,
    StateCapabilities? state,
    MultiAgentCapabilities? multiAgent,
    ReasoningCapabilities? reasoning,
    MultimodalCapabilities? multimodal,
    ExecutionCapabilities? execution,
    HumanInTheLoopCapabilities? humanInTheLoop,
    Map<String, dynamic>? custom,
  }) {
    return AgentCapabilities(
      identity: identity ?? this.identity,
      transport: transport ?? this.transport,
      tools: tools ?? this.tools,
      output: output ?? this.output,
      state: state ?? this.state,
      multiAgent: multiAgent ?? this.multiAgent,
      reasoning: reasoning ?? this.reasoning,
      multimodal: multimodal ?? this.multimodal,
      execution: execution ?? this.execution,
      humanInTheLoop: humanInTheLoop ?? this.humanInTheLoop,
      custom: custom ?? this.custom,
    );
  }
}
