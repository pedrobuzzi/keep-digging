#!/usr/bin/env bash
# utils.sh — Logging, colors, and helper functions

# Colors (using $'...' so escape sequences become real escape chars)
readonly RED=$'\033[0;31m'
readonly GREEN=$'\033[0;32m'
readonly YELLOW=$'\033[1;33m'
readonly BLUE=$'\033[0;34m'
readonly CYAN=$'\033[0;36m'
readonly BOLD=$'\033[1m'
readonly DIM=$'\033[2m'
readonly NC=$'\033[0m' # No Color

log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$*" >&2
}

log_warn() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$*" >&2
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$*" >&2
}

log_success() {
    printf "${GREEN}[OK]${NC} %s\n" "$*" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        printf "${DIM}[DEBUG]${NC} %s\n" "$*" >&2
    fi
}

# Progress bar: show_progress <current> <total> <label>
show_progress() {
    local current="$1" total="$2" label="$3"
    local width=40
    local pct=$(( current * 100 / total ))
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))

    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="="; done
    if (( filled < width )); then bar+=">"; empty=$((empty - 1)); fi
    for ((i = 0; i < empty; i++)); do bar+=" "; done

    printf "\r${CYAN}[%s]${NC} %3d%% %s" "$bar" "$pct" "$label" >&2
}

# Extract sub-questions from Claude's response
# Looks for lines in the "## New Sub-Questions" section
extract_questions() {
    local response="$1"
    local in_section=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^##[[:space:]]*New[[:space:]]*Sub.?[Qq]uestions ]]; then
            in_section=1
            continue
        fi
        if (( in_section )) && [[ "$line" =~ ^## ]]; then
            break
        fi
        if (( in_section )) && [[ "$line" =~ ^[[:space:]]*[-*0-9] ]]; then
            # Strip leading bullet/number markers
            echo "$line" | sed 's/^[[:space:]]*[-*][[:space:]]*//' | sed 's/^[[:space:]]*[0-9]\+[.)][[:space:]]*//'
        fi
    done <<< "$response"
}

# Detect last completed iteration (has both answer.md and summary.txt)
detect_last_completed_iteration() {
    local output_dir="$1"
    local iterations_dir="$output_dir/iterations"
    local last=0

    if [[ ! -d "$iterations_dir" ]]; then
        echo "0"
        return
    fi

    for dir in "$iterations_dir"/iteration_*; do
        [[ -d "$dir" ]] || continue
        if [[ -f "$dir/answer.md" && -f "$dir/summary.txt" ]]; then
            local num
            num=$(basename "$dir" | sed 's/iteration_0*//')
            if (( num > last )); then
                last=$num
            fi
        fi
    done

    echo "$last"
}

# Remove incomplete iterations (missing answer.md or summary.txt)
cleanup_incomplete_iterations() {
    local output_dir="$1"
    local iterations_dir="$output_dir/iterations"

    [[ -d "$iterations_dir" ]] || return 0

    for dir in "$iterations_dir"/iteration_*; do
        [[ -d "$dir" ]] || continue
        if [[ ! -f "$dir/answer.md" || ! -f "$dir/summary.txt" ]]; then
            local name
            name=$(basename "$dir")
            log_warn "Removing incomplete iteration: $name"
            rm -rf "$dir"
        fi
    done
}

# Generate a slug from a question (first 5 words, lowercased, joined with -)
generate_slug() {
    local question="$1"
    # Collapse to single line, strip non-alphanum, take first 5 words
    echo "$question" \
        | tr '\n' ' ' \
        | tr '[:upper:]' '[:lower:]' \
        | sed 's/[^a-z0-9 ]//g' \
        | sed 's/  */ /g' \
        | awk '{for(i=1;i<=5&&i<=NF;i++) printf "%s%s",$i,(i<5&&i<NF?"-":""); printf "\n"; exit}'
}
