<!-- NETSEKTOR-GOVERNANCE:START -->
## NetSektör Central Engineering Governance — MANDATORY

This repository is governed by the central engineering constitution in `sunsetfly/kurallar`.

Pinned governance release:
- Version: `1.0.0`
- Tag: `v1.0.0`
- Commit SHA: `cfcb83c646fc14b414fd0cd692cdba04b62be07e`
- Authority: https://github.com/sunsetfly/kurallar/tree/cfcb83c646fc14b414fd0cd692cdba04b62be07e

Before any material phase, sprint, remediation, refactor, integration, migration, architecture change or implementation, the agent MUST read and obey the pinned versions of:
1. `CONSTITUTION.md`
2. `AGENTS.md`
3. `engineering-policy.yaml`
4. relevant files under `policies/`
5. the active repository-tracked work document

Mandatory execution order:
`Work Document -> Existing/Native Capability Audit -> Donor Research -> Donor Decision -> Best Practice if no acceptable donor -> Minimal Custom Code -> Test -> Evidence -> Acceptance Audit -> Definition of Done -> Commit`

Hard rules:
- Reuse before build; do not reinvent an adequate existing capability.
- Donor research is mandatory before material custom implementation.
- If no acceptable donor exists, best-practice analysis is mandatory before custom implementation.
- `NOT_RUN` is never `PASS`; completion claims require evidence.
- Local repository rules may strengthen central governance but may not silently weaken it.
- If pinned central governance cannot be accessed and no matching local snapshot exists, report a governance blocker before material implementation.

Governance metadata: `.netsektor/GOVERNANCE.yaml`
<!-- NETSEKTOR-GOVERNANCE:END -->
