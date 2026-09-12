# AgentVault V1.2 Demo Flow

## Demo Objective

Demonstrate that an AI-generated treasury proposal can pass through multiple deterministic security boundaries before a controlled testnet transaction is executed.

## Stage 1 — AI Proposal

Gemini produces a structured proposal.

Status:
UNTRUSTED

## Stage 2 — Deterministic Validation

The proposal is checked for schema, fields, hashes, strategy, target, value, confidence and risk.

Status:
VALIDATED

## Stage 3 — Live Policy Preflight

The current vault state and execution policy are checked.

Status:
PASS

## Stage 4 — Queue Sealing

The proposal and preflight evidence are cryptographically bound into a pending queue.

Status:
SEALED / NOT AUTHORIZED

## Stage 5 — EIP-712 Authentication

The dedicated agent signs the typed decision.

Status:
AUTHENTICATED

Authentication does not itself authorize execution.

## Stage 6 — Manual Gate

The execution gate requires explicit manual approval.

Approval used in the demonstrated test:
EXECUTE

## Stage 7 — Testnet Execution

Transaction:
0x16cd9db37b7d679680a1434174f62fdbec8477b552c58cd6101f61836f22243c

Amount:
0.001 SVP

Result:
CONFIRMED

## Stage 8 — Post-Execution Audit

Receipt, nonce, balance, spent amount and decision consumption were verified.

Status:
PASS

## Result

The demonstration shows separation between:

AI proposal
→ validation
→ authentication
→ human authorization
→ execution
→ audit
