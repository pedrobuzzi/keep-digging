#!/usr/bin/env bash
# prompts.sh — Prompt templates for iteration, summary, and synthesis

# Build the iteration prompt — the core research loop prompt
# Usage: build_iteration_prompt <question> <perspective_name> <perspective_desc> <context> <iteration> <max_iterations>
build_iteration_prompt() {
    local question="$1"
    local perspective_name="$2"
    local perspective_desc="$3"
    local context="$4"
    local iteration="$5"
    local max_iterations="$6"

    cat <<PROMPT
You are a research agent performing deep, iterative analysis. You are on iteration ${iteration} of ${max_iterations}.

## Original Question
${question}

## Your Current Perspective: ${perspective_name}
${perspective_desc}

## Research So Far
${context:-This is the first iteration. No prior research exists yet.}

## Your Task
Adopt the "${perspective_name}" perspective fully. Your job is to advance our understanding of the original question.

Instructions:
1. Review what has been covered so far (if anything). Do NOT repeat prior findings.
2. Identify gaps, weaknesses, or underexplored angles in the existing research.
3. Generate 3-5 NEW sub-questions that dig deeper, challenge assumptions, or explore neglected dimensions.
4. Provide substantive analysis that adds genuine new insight from your perspective.
5. Assess overall progress toward answering the original question.

You MUST structure your response with these exact section headers:

## New Sub-Questions
- List 3-5 new sub-questions that would deepen understanding

## Analysis
Your substantive contribution from the ${perspective_name} perspective. Be thorough and specific. Include evidence, reasoning, and concrete examples where possible.

## Progress Assessment
Rate progress toward fully answering the original question on a scale of 1-10, where:
- 1-3: Still exploring the surface
- 4-6: Good foundation, significant gaps remain
- 7-8: Strong understanding, some nuances to explore
- 9-10: Comprehensive understanding achieved
Score: X/10
Brief justification for the score.
PROMPT
}

# Build the summary prompt — compress a response into a concise summary
# Usage: build_summary_prompt <response> <question> <perspective_name> <iteration>
build_summary_prompt() {
    local response="$1"
    local question="$2"
    local perspective_name="$3"
    local iteration="$4"

    cat <<PROMPT
Compress the following research iteration into a concise summary of 200-300 words.

Original question: ${question}
Perspective used: ${perspective_name}
Iteration: ${iteration}

Preserve:
- Key findings and insights
- Sub-questions generated
- The perspective's unique contribution
- The progress score
- Any critical evidence or examples

Do NOT include preamble or meta-commentary. Just the compressed summary.

--- BEGIN RESPONSE ---
${response}
--- END RESPONSE ---
PROMPT
}

# Build the synthesis prompt — final consolidation of all research
# Usage: build_synthesis_prompt <question> <all_summaries>
build_synthesis_prompt() {
    local question="$1"
    local all_summaries="$2"

    cat <<PROMPT
You are producing the final synthesis of a deep, multi-perspective research process.

## Original Question
${question}

## All Research Summaries
${all_summaries}

## Your Task
Synthesize ALL the research above into a comprehensive, well-structured final answer. You must produce three sections separated by the exact delimiter shown below.

SECTION 1 — Final Answer:
Provide a thorough, nuanced answer to the original question. Integrate insights from all perspectives. Use clear structure with headers and sub-headers. Be comprehensive but avoid redundancy. Where perspectives disagreed, explain the tension and your assessment.

===SECTION_BREAK===

SECTION 2 — Key Findings:
List the most important findings as bullet points. For each finding, include a confidence level:
- [HIGH] — Strong evidence, multiple perspectives agree
- [MEDIUM] — Good evidence, some uncertainty or disagreement
- [LOW] — Speculative, limited evidence, or significant disagreement

===SECTION_BREAK===

SECTION 3 — Open Questions:
List important questions that remain unanswered or underexplored. For each, briefly explain why it matters and what kind of investigation would help resolve it.
PROMPT
}
