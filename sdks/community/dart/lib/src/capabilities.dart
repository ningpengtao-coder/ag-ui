library;

class SubAgentInfo {
  final String name;
  final String? description;

  const SubAgentInfo({
    required this.name,
    this.description,
  });
}

class IdentityCapabilities {
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
}

class TransportCapabilities {
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
}

class ToolsCapabilities {
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
}

class OutputCapabilities {
  final bool? structuredOutput;
  final List<String>? supportedMimeTypes;

  const OutputCapabilities({
    this.structuredOutput,
    this.supportedMimeTypes,
  });
}

class StateCapabilities {
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
}

class MultiAgentCapabilities {
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
}

class ReasoningCapabilities {
  final bool? supported;
  final bool? streaming;
  final bool? encrypted;

  const ReasoningCapabilities({
    this.supported,
    this.streaming,
    this.encrypted,
  });
}

class MultimodalInputCapabilities {
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
}

class MultimodalOutputCapabilities {
  final bool? image;
  final bool? audio;

  const MultimodalOutputCapabilities({
    this.image,
    this.audio,
  });
}

class MultimodalCapabilities {
  final MultimodalInputCapabilities? input;
  final MultimodalOutputCapabilities? output;

  const MultimodalCapabilities({
    this.input,
    this.output,
  });
}

class ExecutionCapabilities {
  final bool? codeExecution;
  final bool? sandboxed;
  final num? maxIterations;
  final num? maxExecutionTime;

  const ExecutionCapabilities({
    this.codeExecution,
    this.sandboxed,
    this.maxIterations,
    this.maxExecutionTime,
  });
}

class HumanInTheLoopCapabilities {
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
}

class AgentCapabilities {
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
}
