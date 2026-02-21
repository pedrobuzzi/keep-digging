#!/usr/bin/env bash
# summarize.sh — Summary generation and sliding context window

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/prompts.sh"

# Generate a summary of an iteration's response using haiku
# Usage: generate_summary <response> <question> <perspective_name> <iteration>
generate_summary() {
    local response="$1"
    local question="$2"
    local perspective_name="$3"
    local iteration="$4"

    local prompt
    prompt=$(build_summary_prompt "$response" "$question" "$perspective_name" "$iteration")

    echo "$prompt" | claude -p --model haiku 2>&1
}

# Build accumulated context with sliding window
# Usage: build_context <output_dir> <current_iteration>
# Strategy:
#   Iterations 1-5:  all summaries verbatim
#   Iterations 6-10: meta-summary of old + last 3 verbatim
#   Iterations 11+:  condensed meta-summary + last 3 verbatim
build_context() {
    local output_dir="$1"
    local current_iteration="$2"
    local iterations_dir="$output_dir/iterations"
    local context=""
    local total_past=$(( current_iteration - 1 ))

    if (( total_past == 0 )); then
        echo ""
        return
    fi

    if (( total_past <= 5 )); then
        # Include all summaries verbatim
        for ((i = 1; i <= total_past; i++)); do
            local iter_dir
            iter_dir=$(printf "%s/iteration_%02d" "$iterations_dir" "$i")
            if [[ -f "$iter_dir/summary.txt" ]]; then
                local perspective=""
                [[ -f "$iter_dir/perspective.txt" ]] && perspective=$(cat "$iter_dir/perspective.txt")
                context+="### Iteration ${i} (${perspective})"$'\n'
                context+=$(cat "$iter_dir/summary.txt")
                context+=$'\n\n'
            fi
        done
    else
        # Need a meta-summary for older iterations + recent verbatim
        local recent_start=$(( total_past - 2 ))
        (( recent_start < 1 )) && recent_start=1
        local old_end=$(( recent_start - 1 ))

        # Build meta-summary from older iterations
        if (( old_end >= 1 )); then
            local old_summaries=""
            for ((i = 1; i <= old_end; i++)); do
                local iter_dir
                iter_dir=$(printf "%s/iteration_%02d" "$iterations_dir" "$i")
                if [[ -f "$iter_dir/summary.txt" ]]; then
                    local perspective=""
                    [[ -f "$iter_dir/perspective.txt" ]] && perspective=$(cat "$iter_dir/perspective.txt")
                    old_summaries+="Iteration ${i} (${perspective}): "
                    old_summaries+=$(cat "$iter_dir/summary.txt")
                    old_summaries+=$'\n\n'
                fi
            done

            local max_words=300
            (( total_past > 10 )) && max_words=200

            local meta_prompt
            meta_prompt=$(cat <<META_PROMPT
Condense the following research summaries from iterations 1-${old_end} into a single meta-summary of at most ${max_words} words. Preserve the most critical findings, key disagreements between perspectives, and established facts. Remove redundancy.

${old_summaries}
META_PROMPT
)
            local meta_summary
            meta_summary=$(echo "$meta_prompt" | claude -p --model haiku 2>&1)

            context+="### Meta-Summary (Iterations 1-${old_end})"$'\n'
            context+="$meta_summary"
            context+=$'\n\n'
        fi

        # Include recent summaries verbatim
        for ((i = recent_start; i <= total_past; i++)); do
            local iter_dir
            iter_dir=$(printf "%s/iteration_%02d" "$iterations_dir" "$i")
            if [[ -f "$iter_dir/summary.txt" ]]; then
                local perspective=""
                [[ -f "$iter_dir/perspective.txt" ]] && perspective=$(cat "$iter_dir/perspective.txt")
                context+="### Iteration ${i} (${perspective})"$'\n'
                context+=$(cat "$iter_dir/summary.txt")
                context+=$'\n\n'
            fi
        done
    fi

    echo "$context"
}
