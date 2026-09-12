# SVP AgentVault

AI-assisted treasury execution with deterministic on-chain policy enforcement.

## Core idea

AI proposes actions.

AI does not control treasury authority.

Before execution, proposals must pass deterministic validation, live policy checks, authenticated agent authorization, transaction simulation, and explicit human approval.

The AgentVault smart contract remains the final policy enforcement layer.

## Deployment

Network: SVPChain Testnet

Chain ID: 2517

AgentVault V1.1 RC1:

0xcd6D4333BcB56c226192a478dA2d9261FdA78953

Source verification:

Exact Match

## Demonstrated execution

Transaction:

0x16cd9db37b7d679680a1434174f62fdbec8477b552c58cd6101f61836f22243c

Block:

7000648

Gas used:

92731

Executed amount:

0.001 SVP

Decision nonce:

4 → 5

## Demonstrated pipeline

Gemini
→ schema validation
→ deterministic policy validation
→ live policy preflight
→ sealed queue
→ adversarial integrity tests
→ EIP-712 agent authentication
→ final live-state validation
→ contract simulation
→ human approval
→ dedicated-agent execution
→ post-execution audit

## Evidence

Post-execution audit:

20 / 20 PASS

Live demo snapshot:

32 / 32 PASS

V0.9 final submission SHA-256:

B7B4496D786348E8976566BE59C8AEA71A8364516F0CE647A0B7CFE2AC4A0881

## Security status

Current release:

TESTNET RC

AI blockchain authority:

NONE

Human approval:

REQUIRED

Independent security audit:

NO

Exact source verification and successful testing are not equivalent to an independent security audit.

Production use should include independent review, hardened signer infrastructure, operational key isolation, monitoring, and incident-response procedures.