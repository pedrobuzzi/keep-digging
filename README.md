# keep-digging

> **Iterative, multi-perspective deep research powered by Claude.**

A CLI tool that leverages the [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) to perform deep, iterative research on any question. Each iteration adopts a different thinking perspective, rotates through Claude models, generates sub-questions, and accumulates knowledge — until everything is synthesized into a final consolidated answer.

### **Zero API costs — runs on your Claude subscription**

If you have a [Claude Pro, Max, or Team](https://claude.ai/pricing) subscription, you already have access to Claude CLI at **no extra cost**. That means keep-digging runs entirely on your existing plan — no API keys, no usage-based billing, no surprise invoices. You're already paying for Claude; this tool helps you get significantly more value out of that subscription by automating multi-model, multi-perspective research that would take dozens of manual prompts.

## Why keep-digging?

| | keep-digging | ChatGPT Deep Research | Perplexity Pro | Claude API |
|---|:---:|:---:|:---:|:---:|
| Uses your existing subscription | **Yes** | Yes | Yes | No (pay per token) |
| Multi-perspective analysis | **10 perspectives** | Single | Single | Manual |
| Multi-model rotation | **Opus + Sonnet + Haiku** | Single model | Single model | Manual |
| Resumable sessions | **Yes** | No | No | Manual |
| Full output saved locally | **Yes** (Markdown) | No | No | Manual |
| Open source & customizable | **Yes** | No | No | — |
| Cost | **$0 extra** | Included | Included | ~$0.50–5+ per run |

> **TL;DR** — If you subscribe to Claude, you're leaving value on the table by not using the CLI. keep-digging turns a single question into a structured, multi-model research pipeline that would cost real money on the API — and you already have it for free.

## How It Works

```
Question ──► Iteration 1 (First Principles / Opus)
             Iteration 2 (Skeptical Critic / Sonnet)
             Iteration 3 (Historical Analyst / Haiku)
             ...
             Iteration N ──► Synthesis ──► Final Answer
```

1. You ask a question
2. The tool runs N iterations, each with a **different perspective** and a **different model** in rotation
3. Each iteration receives accumulated context from all previous ones, identifies gaps, and generates sub-questions to go deeper
4. A final synthesis call consolidates everything into: **final answer**, **key findings** (with confidence levels), and **open questions**

## The 10 Perspectives

| # | Perspective | Focus |
|---|-------------|-------|
| 1 | First Principles Thinker | Decompose down to fundamentals |
| 2 | Skeptical Critic | Challenge evidence and logic |
| 3 | Historical Analyst | Precedents and historical patterns |
| 4 | Systems Thinker | Connections, feedback loops, second-order effects |
| 5 | Devil's Advocate | Argue the opposite of consensus |
| 6 | Empirical Scientist | Data, evidence, falsifiability |
| 7 | Practical Pragmatist | What actually works in practice |
| 8 | Creative Lateral Thinker | Unexpected cross-domain connections |
| 9 | Ethical Philosopher | Moral and human dimensions |
| 10 | Synthesis Integrator | Unify everything into a coherent framework |

With 3 models rotating (Opus, Sonnet, Haiku), that's **30 unique combinations** before any repetition.

## Installation

### Prerequisites

- [Claude CLI](https://docs.anthropic.com/en/docs/claude-cli) installed and authenticated

### Setup

```bash
git clone https://github.com/your-username/keep-digging.git
cd keep-digging
chmod +x keep-digging
```

## Usage

```bash
./keep-digging [OPTIONS] <question>
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-n, --max-iterations <N>` | Number of research iterations | `10` |
| `-o, --output-dir <path>` | Output directory | auto-generated |
| `-m, --models <list>` | Model rotation (comma-separated) | `opus,sonnet,haiku` |
| `-q, --question-file <path>` | Read question from a file | — |
| `-r, --resume` | Resume a previous session (requires `-o`) | — |
| `-s, --synthesize-only` | Run only the final synthesis (requires `-o`) | — |
| `-v, --verbose` | Verbose mode | — |
| `-h, --help` | Show help | — |

### Examples

```bash
# Basic research with 3 iterations
./keep-digging -n 3 "What caused the fall of the Roman Empire?"

# Use only Sonnet and Haiku
./keep-digging -n 5 -m sonnet,haiku "How does mRNA vaccine technology work?"

# Read question from a file
./keep-digging -n 5 -q my_question.txt

# Resume an interrupted session
./keep-digging -r -o dig_roman-empire_20260220_150000/ -n 10

# Extend to more iterations
./keep-digging -r -o dig_roman-empire_20260220_150000/ -n 20

# Re-synthesize with existing data
./keep-digging -s -o dig_roman-empire_20260220_150000/
```

## Output

Each run generates a structured directory:

```
dig_<slug>_<timestamp>/
├── question.txt                  # Original question
├── config.json                   # Session configuration
├── iterations/
│   ├── iteration_01/
│   │   ├── perspective.txt       # Perspective used
│   │   ├── model.txt             # Model used
│   │   ├── prompt.txt            # Prompt sent
│   │   ├── questions.txt         # Sub-questions generated
│   │   ├── answer.md             # Full response
│   │   └── summary.txt           # Compacted summary
│   ├── iteration_02/ ...
│   └── ...
└── synthesis/
    ├── final_answer.md           # Final synthesized answer
    ├── key_findings.md           # Key findings with confidence levels
    └── open_questions.md         # Remaining open questions
```

## Sliding Context Window

To prevent context overflow in long research sessions, previous summaries are progressively compacted:

| Iterations | Strategy |
|------------|----------|
| 1–5 | All summaries kept in full |
| 6–10 | Meta-summary of older iterations + last 3 in full |
| 11+ | Condensed meta-summary + last 3 in full |

## License

MIT
