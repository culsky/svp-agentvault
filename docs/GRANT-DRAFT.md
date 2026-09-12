# SVP AgentVault — Grant Submission Draft

## Project Name

SVP AgentVault

## Category

AI Agents / On-chain Treasury Infrastructure

## One-Line Description

An AI-assisted treasury agent where external AI proposes actions while deterministic smart-contract policy controls what can actually execute.

## Problem

AI agents can generate useful financial decisions, but direct access to treasury keys creates an unsafe trust model.

A compromised or incorrect model response should not automatically become a blockchain transaction.

## Proposed Solution

SVP AgentVault separates intelligence from authority.

External AI produces structured proposals.

A deterministic Agent Engine validates the proposal, reads current blockchain state, verifies contract policy, seals execution evidence, authenticates the dedicated agent through EIP-712, simulates the transaction, and requires explicit approval before broadcasting.

AgentVault independently enforces treasury policy on-chain.

## Why SVPChain

The project is implemented and demonstrated directly on SVPChain testnet.

The current deployment provides a reproducible testnet example of AI-assisted treasury execution with on-chain policy controls and verifiable execution evidence.

## Working Product Evidence

AgentVault V1.1 RC1 is deployed on SVPChain testnet with Exact Match source verification.

A live Gemini-generated proposal progressed through the complete authenticated pipeline and resulted in a confirmed testnet transaction.

Transaction:

0x16cd9db37b7d679680a1434174f62fdbec8477b552c58cd6101f61836f22243c

The post-execution audit passed 20 / 20 checks.

The later live demo snapshot passed 32 / 32 checks.

## Security Design

The architecture deliberately treats AI as untrusted.

AI does not hold:

- owner authority
- guardian authority
- execution signer credentials
- direct transaction authority

Execution is constrained by contract policy and authenticated through a dedicated agent.

## Current Limitations

The project is currently a testnet release candidate.

It has not received an independent security audit.

Human approval remains part of the execution flow.

Logical role separation exists, but development keys are currently operated from the same development-machine environment.

## Grant Objective

Advance SVP AgentVault from a demonstrated testnet release candidate toward a hardened, independently reviewed, developer-friendly AI treasury infrastructure layer for SVPChain.

## Proposed Milestones

Milestone 1 — Security & Operational Hardening

Deliverables:

- expanded invariant/fuzz testing
- hardened signer architecture
- monitoring and alerting
- incident-response documentation
- security review preparation

Milestone 2 — Strategy & Integration Layer

Deliverables:

- modular strategy interface
- risk-scoring modules
- protocol adapter framework
- simulation analytics
- decision-history reporting

Milestone 3 — Independent Review & Production Candidate

Deliverables:

- independent smart-contract security review
- remediation of identified findings
- production deployment checklist
- hardened deployment candidate
- public technical documentation

## Success Metrics

- reproducible end-to-end AI proposal pipeline
- deterministic rejection of invalid or unauthorized proposals
- verifiable transaction evidence
- replay-resistant execution
- operational emergency controls
- documented security assumptions
- independently reviewed production candidate

## Funding Position

The exact requested budget should be aligned with the final scope, external security-review cost, infrastructure requirements, and grant-program milestone requirements.

The project should not claim production readiness until the relevant security and operational milestones are completed.