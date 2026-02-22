
## SECTION 2 — Key Findings

- **[HIGH]** Serverless is genuinely cheaper for low-utilization, sporadic workloads (below ~15–20% sustained utilization). This is mathematical certainty from the pay-per-use model, not marketing spin.

- **[HIGH]** Per-application serverless costs are significantly higher than per-invocation costs suggest, due to mandatory supporting services (API Gateway, queues, observability, state management). A $100/month Lambda bill can sit inside a $3K–$10K/month architecture.

- **[HIGH]** The comparison baseline in most cost analyses is unrealistic. Critics compare serverless to optimized infrastructure; the actual baseline was usually over-provisioned VMs at 3–8% utilization.

- **[HIGH]** Cloud provider pricing architectures structurally impair cost visibility through granularity fragmentation and delayed feedback loops. This isn't conspiracy but isn't accidental either.

- **[MEDIUM]** Labor substitution (reducing DevOps/SRE headcount) is the single largest potential cost saving from serverless, yet it's systematically excluded from published cost analyses on both sides.

- **[MEDIUM]** Serverless exhibits non-linear cost scaling: fan-out amplification, retry storms, and cold start chains mean 10x traffic can produce 50–100x cost at the system level. These emergent properties don't appear in function-level analysis.

- **[MEDIUM]** Anti-serverless discourse is subject to reverse survivorship bias — companies that migrated away publish dramatic postmortems, while the majority running serverless successfully have no incentive to publish anything.

- **[MEDIUM]** The serverless hype cycle follows historical IT abstraction patterns with a 2–4 year lag between peak adoption narrative and cost-reality correction, suggesting the technology is currently entering pragmatic stabilization.

- **[LOW]** Serverless is cheaper for roughly 50–60% of actual deployments, more expensive for 15–20%, and neutral for the rest. These ratios are estimated from indirect evidence and workload distribution analysis, not direct empirical measurement.

- **[LOW]** Four reinforcing lock-in loops (skill specialization, tooling investment, vendor ecosystem depth, professional narrative) systematically delay organizations from re-evaluating serverless cost assumptions even when evidence suggests they should.
