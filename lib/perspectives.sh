#!/usr/bin/env bash
# perspectives.sh — 10 perspectives + model rotation

# Each perspective: NAME|DESCRIPTION
PERSPECTIVES=(
    "First Principles Thinker|Break down the problem to its most fundamental truths and axioms. Question every assumption. Rebuild understanding from the ground up. Ask: what do we KNOW to be true vs what do we merely ASSUME? Identify the foundational elements that everything else depends on."
    "Skeptical Critic|Challenge every claim and conclusion reached so far. Look for logical fallacies, weak evidence, confirmation bias, and unsupported leaps. Ask: what evidence would DISPROVE this? What are we getting wrong? What inconvenient facts are being ignored?"
    "Historical Analyst|Examine the topic through the lens of historical precedent, patterns, and evolution over time. What parallels exist in history? How has understanding of this topic changed? What can past events teach us? Identify recurring cycles and long-term trends."
    "Systems Thinker|Analyze the interconnections, feedback loops, and emergent properties. How do the parts relate to the whole? What are the second and third-order effects? Where are the leverage points? Map the system boundaries and identify what's inside vs outside the system."
    "Devil's Advocate|Deliberately argue the opposite position from the emerging consensus. If the research is converging on an answer, argue against it. If it's dismissing something, argue for it. The goal is to stress-test ideas by forcing consideration of the strongest counter-arguments."
    "Empirical Scientist|Focus on evidence, data, measurability, and falsifiability. What does the empirical evidence actually show? Where are the gaps in data? What experiments or observations would resolve open questions? Distinguish between correlation and causation. Rate confidence levels."
    "Practical Pragmatist|Cut through abstraction and theory. What actually matters in practice? What are the real-world implications and applications? What works vs what sounds good in theory? Focus on actionable insights, trade-offs, and concrete examples."
    "Creative Lateral Thinker|Make unexpected connections between seemingly unrelated domains. Use analogies, metaphors, and cross-disciplinary thinking. Reframe the question itself. What if the question is wrong? What adjacent or overlooked angles might yield breakthrough insights?"
    "Ethical Philosopher|Examine the moral, ethical, and human dimensions. Who benefits and who is harmed? What values are in tension? What are the long-term societal implications? Consider fairness, justice, autonomy, and responsibility. Question whose perspective is centered or marginalized."
    "Synthesis Integrator|Weave together all previous perspectives into a coherent whole. Identify where different perspectives agree (convergence) and disagree (tension). Resolve contradictions where possible. Build a unified framework that honors the complexity while remaining actionable."
)

# Get perspective for a given iteration (0-indexed rotation)
# Usage: get_perspective <iteration_number>
# Returns: name and description via PERSPECTIVE_NAME and PERSPECTIVE_DESC
get_perspective() {
    local iteration="$1"
    local idx=$(( (iteration - 1) % ${#PERSPECTIVES[@]} ))
    local entry="${PERSPECTIVES[$idx]}"

    PERSPECTIVE_NAME="${entry%%|*}"
    PERSPECTIVE_DESC="${entry#*|}"
}

# Get model for a given iteration from the model rotation
# Usage: get_model <iteration_number> <models_csv>
# Returns: model name via MODEL_NAME
get_model() {
    local iteration="$1"
    local models_csv="$2"

    IFS=',' read -ra models <<< "$models_csv"
    local idx=$(( (iteration - 1) % ${#models[@]} ))
    MODEL_NAME="${models[$idx]}"
}
