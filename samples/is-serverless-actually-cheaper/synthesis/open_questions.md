
## SECTION 3 — Open Questions

**1. What do longitudinal, workload-segmented cost studies actually show?**
Nearly all published serverless cost data is either vendor-sponsored, single-snapshot, or anecdotal (conference talks, blog posts). Multi-year studies tracking total cost of ownership across workload categories — with labor included — essentially don't exist in the public domain. Rigorous, independent longitudinal research across dozens of organizations would resolve most of the remaining uncertainty.

**2. How does the emerging alternatives landscape change the calculus?**
Container-as-a-service platforms (Cloud Run, Fargate), WebAssembly-based edge compute (Cloudflare Workers, Fastly Compute), and Kubernetes auto-scaling (KEDA) occupy middle ground between serverless simplicity and traditional control. Whether these alternatives collapse the "serverless sweet spot" or expand it remains underexplored. Comparative TCO studies across these options at various scale points would be highly valuable.

**3. What is the actual rate of "serverless regret" vs. continued satisfaction?**
The published record is dominated by dramatic exits (Prime Video) and enthusiastic adoption stories. The silent middle — companies quietly running serverless without strong feelings — is unmeasured. Anonymous industry surveys with workload characterization would help quantify how common cost overruns actually are.

**4. How do organizational characteristics predict serverless cost outcomes?**
Team size, engineering culture, existing cloud maturity, regulatory environment, and workload variability likely predict whether serverless saves or costs money — but no systematic framework maps these variables to outcomes. A decision framework grounded in organizational typology rather than workload characteristics alone would be practically useful.

**5. What happens to serverless economics as AI/ML workloads grow?**
GPU-intensive inference, long-running training jobs, and large context windows don't fit the serverless model well. As AI workloads consume increasing shares of cloud budgets, the relative importance of serverless cost optimization may shift. Understanding how serverless fits (or doesn't) into AI-heavy architectures is an emerging and underexplored question.

**6. Does real-time cost attribution per request path change behavior?**
Systems thinking identifies tightening cost feedback loops as the highest-leverage intervention. Tools like AWS Cost Explorer are improving, but per-request-path attribution across a distributed serverless architecture remains immature. Whether organizations that implement granular cost tracking make materially different architectural decisions is testable but untested.
