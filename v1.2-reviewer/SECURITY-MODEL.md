# AgentVault V1.2 Security Model

## Trust Model

AI is an untrusted proposal source.

The security boundary is enforced after AI output is received.

## Pipeline

1. AI produces a structured proposal.
2. Schema and content validation are performed.
3. Live treasury policy is checked.
4. Proposal, policy state, chain, vault, agent and nonce are cryptographically bound.
5. EIP-712 authentication identifies the dedicated agent signer.
6. Execution remains unauthorized until explicit manual approval.
7. The executor performs the transaction only after the manual gate.
8. Post-execution verification checks the receipt and state transition.

## Controls Demonstrated

### Input integrity
Structured JSON and exact field validation.

### Source integrity
SHA-256 bindings between proposal artifacts and downstream stages.

### Policy enforcement
Checks include:
- paused state
- active agent
- maximum transaction amount
- daily limit
- available vault balance
- target allowlist
- selector allowlist

### Authentication
EIP-712 typed-data signing with recovered signer verification.

### Replay protection
Decision nonce and consumed decision hash prevent reuse of an old authenticated decision.

### Adversarial testing
Target, value, nonce, chain, vault, agent, payload and signature tampering were rejected in the demonstrated tests.

## Authority Separation

The AI is not the transaction authority.

Manual approval is required before the execution stage.

## Scope

This is a testnet security demonstration and not a claim of production-grade security or independent audit certification.
