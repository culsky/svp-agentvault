# SVP AgentVault — Reviewer Demo Script

## Demo Objective

Demonstrate that an external AI can propose a treasury action without receiving direct authority over treasury assets.

## 1. Show the Deployment

Open the verified AgentVault V1.1 RC1 contract on the SVPChain explorer.

Contract:

0xcd6D4333BcB56c226192a478dA2d9261FdA78953

Explain that the deployed source is verified as Exact Match.

## 2. Show Role Separation

Owner:

0x1110AC0B518C76C7613326f0663bBC8702E09453

Dedicated Agent:

0x83058883873b35CbDF15f0EADb73731b30b272D5

Guardian:

0x81b3BA62Dc32e98B6b82CAbAEA40E0F9097B976D

Explain:

Owner manages policy and recovery.

Agent can execute only within contract policy.

Guardian can trigger emergency pause.

AI has no blockchain authority.

## 3. Show the Dashboard

Open:

agent/grant-demo/v08/dashboard/index.html

Highlight:

- Vault ACTIVE
- Vault balance
- 0.05 SVP maximum per transaction
- 0.2 SVP daily limit
- decision nonce 5
- 32 / 32 live demo gates
- execution CONFIRMED

## 4. Explain the AI Pipeline

Gemini
→ Schema Validation
→ Policy Gate
→ Sealed Queue
→ EIP-712
→ Live Preflight
→ Static Simulation
→ Human Approval
→ Agent Execute
→ Audit

Emphasize that AI output alone cannot trigger execution.

## 5. Show the Confirmed Transaction

Transaction:

0x16cd9db37b7d679680a1434174f62fdbec8477b552c58cd6101f61836f22243c

Demonstrated facts:

- sender was the dedicated agent
- destination was AgentVault
- execute calldata decoded successfully
- value was 0.001 SVP
- decision hash matched
- receipt status was successful
- decision hash became consumed
- nonce advanced from 4 to 5

## 6. Show Replay Protection

The post-execution audit confirmed:

- decision consumed
- current nonce = 5
- previous nonce = 4 is no longer valid

## 7. Show Evidence Integrity

V0.7 baseline and V0.8 demo package are protected by SHA-256 manifests.

V0.8 final seal:

6117BDFE25B5842CA91F42C036DE9B18E0AE7A0A5BB21EAECF20934BADFFBC02

## Closing Message

SVP AgentVault demonstrates a security-oriented architecture where AI proposes actions but deterministic policy and authenticated blockchain execution control what can actually happen.

The current version is a testnet release candidate with manual approval and is not presented as independently audited production software.