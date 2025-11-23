#!/bin/bash

# Common utilities for chia setup scripts
# Source this file in other scripts to use shared functions

# Check for verbose mode
VERBOSE=${CHIA_VERBOSE:-false}

# Function to log messages with timestamp
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to handle errors
handle_error() {
    log "Error: $1"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run command with smart logging
# Usage: run_with_logging "description" command args...
run_with_logging() {
    local description="$1"
    shift
    local temp_log=$(mktemp)

    if [[ "$VERBOSE" == "true" ]]; then
        log "$description"
        "$@" 2>&1 | tee "$temp_log"
        local exit_code=${PIPESTATUS[0]}
    else
        "$@" > "$temp_log" 2>&1
        local exit_code=$?
    fi

    if [[ $exit_code -ne 0 ]]; then
        log "Failed: $description"
        log "Command output:"
        cat "$temp_log" | sed 's/^/  /'
        rm -f "$temp_log"
        return $exit_code
    else
        [[ "$VERBOSE" != "true" ]] && log "$description - completed"
        rm -f "$temp_log"
        return 0
    fi
}

# Function to run command quietly, only showing output on failure
run_quiet() {
    local temp_log=$(mktemp)
    "$@" > "$temp_log" 2>&1
    local exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        log "Command failed: $*"
        log "Output:"
        cat "$temp_log" | sed 's/^/  /'
    fi

    rm -f "$temp_log"
    return $exit_code
}

# Progress indicator for long-running operations
show_progress() {
    local description="$1"
    local pid=$2
    local delay=0.1
    local spinstr='|/-\'

    log "$description..."
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf "\r[$(date +'%Y-%m-%d %H:%M:%S')] $description... %c" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r[$(date +'%Y-%m-%d %H:%M:%S')] $description - completed\n"
}

# Run command in background with progress indicator
run_with_progress() {
    local description="$1"
    shift
    local temp_log=$(mktemp)

    if [[ "$VERBOSE" == "true" ]]; then
        log "$description"
        "$@" 2>&1 | tee "$temp_log"
        local exit_code=${PIPESTATUS[0]}
    else
        "$@" > "$temp_log" 2>&1 &
        local cmd_pid=$!
        show_progress "$description" $cmd_pid
        wait $cmd_pid
        local exit_code=$?
    fi

    if [[ $exit_code -ne 0 ]]; then
        log "Failed: $description"
        log "Command output:"
        cat "$temp_log" | sed 's/^/  /'
        rm -f "$temp_log"
        return $exit_code
    else
        rm -f "$temp_log"
        return 0
    fi
}

# Check if running in verbose mode
is_verbose() {
    [[ "$VERBOSE" == "true" ]]
}

# Print usage information for verbose mode
print_verbose_usage() {
    echo "Tip: Run with CHIA_VERBOSE=true for detailed output"
    echo "Example: CHIA_VERBOSE=true ./chia.sh"
}

# Cleanup function to remove temporary files
cleanup_temp_files() {
    find /tmp -name "tmp.*" -user "$(whoami)" -mtime +1 -delete 2>/dev/null || true
}
