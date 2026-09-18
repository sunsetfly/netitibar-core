<!-- NETSEKTOR-GOVERNANCE:START -->
## NetSektör Central Engineering Governance — MANDATORY

This repository is governed by the central engineering constitution in `sunsetfly/kurallar`.

Pinned governance release:
- Version: `1.1.0`
- Tag: `v1.1.0`
- Commit SHA: `c872e1b6edca1385182423d023dca77c49947487`
- Authority: https://github.com/sunsetfly/kurallar/tree/c872e1b6edca1385182423d023dca77c49947487

Before any material phase, sprint, remediation, refactor, integration, migration, architecture change or implementation, the agent MUST read and obey the pinned versions of:
1. `CONSTITUTION.md`
2. `AGENTS.md`
3. `engineering-policy.yaml`
4. `policies/AI_EXECUTION_POLICY.md` and `ai-model-catalog.yaml` for material AI-assisted work
5. relevant files under `policies/`
6. the active repository-tracked work document

Mandatory execution order:
`Work Document -> Inspect -> AI Execution Profile -> Existing/Native Capability Audit -> Donor Research -> Donor Decision -> Best Practice if no acceptable donor -> Minimal Custom Code -> Test -> Evidence -> Acceptance Audit -> Definition of Done -> Commit`

Hard rules:
- For material AI-assisted work, classify E0/E1/E2/E3 and record surface/model/reasoning selection.
- Use the least scarce adequate AI capability; escalate only on evidence and de-escalate after the difficult portion.
- Model choice never expands authorization or replaces missing access/context.
- Reuse before build; do not reinvent an adequate existing capability.
- Donor research is mandatory before material custom implementation.
- If no acceptable donor exists, best-practice analysis is mandatory before custom implementation.
- `NOT_RUN` is never `PASS`; completion claims require evidence.
- Local repository rules may strengthen central governance but may not silently weaken it.
- If pinned central governance cannot be accessed and no matching local snapshot exists, report a governance blocker before material implementation.

Governance metadata: `.netsektor/GOVERNANCE.yaml`
<!-- NETSEKTOR-GOVERNANCE:END -->
