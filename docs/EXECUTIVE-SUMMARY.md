# SVP AgentVault

## Executive Summary

SVP AgentVault is an AI-assisted treasury execution system designed for SVPChain.

The project combines external AI proposal generation with deterministic smart-contract policy enforcement, authenticated execution, replay protection, emergency controls, and cryptographically verifiable execution evidence.

The AI is deliberately treated as an untrusted proposal source.

It does not control the owner key, guardian role, or execution authority.

A proposal must pass deterministic validation, live policy checks, queue integrity controls, EIP-712 authentication, contract simulation, and explicit human approval before the dedicated agent can broadcast a transaction.

## Problem

AI agents can generate useful financial decisions, but allowing an AI model to directly control treasury assets creates significant trust and security risks.

Prompt injection, malformed output, compromised providers, stale blockchain state, excessive spending, replay attempts, and signer compromise can all become execution risks.

SVP AgentVault separates AI reasoning from blockchain authority.

## Solution

SVP AgentVault uses a layered architecture:

AI proposal
→ strict schema validation
→ deterministic security validation
→ live on-chain policy preflight
→ sealed execution queue
→ adversarial integrity checks
→ EIP-712 agent authentication
→ final state validation
→ contract static simulation
→ explicit human approval
→ dedicated-agent execution
→ post-execution audit.

The smart contract remains the final policy enforcement layer.

## Current Status

Release:
Testnet Release Candidate

Network:
SVPChain Testnet

Chain ID:
2517

AgentVault V1.1 RC1:
0xcd6D4333BcB56c226192a478dA2d9261FdA78953

Source verification:
Exact Match

Runtime bytecode:
23,487 bytes

Dedicated agent:
0x83058883873b35CbDF15f0EADb73731b30b272D5

Guardian:
0x81b3BA62Dc32e98B6b82CAbAEA40E0F9097B976D

## Live AI Demonstration

A structured Gemini proposal successfully passed the V0.7 execution pipeline.

Confirmed transaction:

0x16cd9db37b7d679680a1434174f62fdbec8477b552c58cd6101f61836f22243c

Block:
7000648

Gas used:
92731

Executed value:
0.001 SVP

Decision nonce:
4 → 5

Decision hash:
0xfe0dbdef5da7d9538129da4a3c449f4ded20623f5ac21e7e22fbbf05495b28f4

Post-execution audit:
20 / 20 gates PASS

Live demo snapshot:
32 / 32 gates PASS

## Evidence Integrity

V0.7 frozen baseline:

BEED75A8E349CD45C0367F61D077BF7DE864645EC189AC4BD51799BA0B654677

V0.8A evidence package:

063727BFA859181ABA4158A572AD82612D3C21149242456A564E7A485DEC76BA

V0.8D final demo seal:

6117BDFE25B5842CA91F42C036DE9B18E0AE7A0A5BB21EAECF20934BADFFBC02

## Security Position

The current system demonstrates:

- deterministic policy enforcement
- dedicated execution agent
- guardian emergency pause
- two-step agent rotation
- spending limits
- target and selector allowlists
- decision nonce
- decision-hash replay protection
- EIP-712 authentication
- adversarial queue tests
- adversarial signature tests
- last-moment state validation
- transaction simulation
- post-execution auditing
- cryptographically frozen evidence

The current release is not represented as independently audited production software.

Human approval remains required for execution.

Operational keys are logically separated but are currently managed from the same development-machine environment.