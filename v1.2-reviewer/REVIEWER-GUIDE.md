# AgentVault V1.2 Reviewer Guide

## Project

AgentVault is a testnet treasury-agent demonstration showing a controlled execution pipeline:

Gemini AI proposal
→ deterministic validation
→ live policy preflight
→ sealed queue
→ EIP-712 authentication
→ manual approval
→ on-chain execution
→ post-execution audit

## Security Boundary

AI output is treated as untrusted input.

The AI does not directly control the treasury and does not possess:
- private keys
- Hardhat keystore access
- direct transaction authority

Execution requires the authenticated agent and explicit manual approval.

## Testnet Evidence

Chain ID: 2517

Vault:
0xcd6D4333BcB56c226192a478dA2d9261FdA78953

Dedicated agent:
0x83058883873b35CbDF15f0EADb73731b30b272D5

Successful test transaction:
0x16cd9db37b7d679680a1434174f62fdbec8477b552c58cd6101f61836f22243c

Executed amount:
0.001 SVP

Execution block:
7000648

## Verification

The demonstrated execution passed:
- deterministic AI validation
- EIP-712 signature recovery
- adversarial authentication tests
- live policy preflight
- nonce protection
- decision-hash consumption
- post-execution audit

## Important Limitation

This package documents a testnet demonstration.

It should not be interpreted as an independent third-party security audit or a production security certification.
