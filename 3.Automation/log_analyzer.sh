#!/bin/bash
###############################################################################
# Script: log_analyzer.sh
# Purpose: Scan a log file for ERROR/WARN/INFO entries, count occurrences,
#          and output the top 10 most frequent error messages.
# Usage:   ./log_analyzer.sh [path_to_log_file]
#          Defaults to /var/log/syslog if no argument is given.
###############################################################################

set -euo pipefail
# -e: exit immediately if any command fails
# -u: treat unset variables as an error
# -o pipefail: a pipeline fails if any command within it fails

# ---- Configuration ----
LOG_FILE="${1:-/var/log/syslog}"          # Use arg1, or default log file
REPORT_FILE="log_report_$(date +%Y%m%d).txt"  # Report named with today's date

# ---- Generate Report ----
{
    echo "=== Log Analysis Report: $(date) ==="
    echo "Log file: $LOG_FILE"
    echo ""

    # Count occurrences of each log level
    # grep -c counts matching lines; '|| echo 0' avoids script exit if no matches (set -e)
    echo "ERROR count: $(grep -c 'ERROR' "$LOG_FILE" || echo 0)"
    echo "WARN count:  $(grep -c 'WARN' "$LOG_FILE" || echo 0)"
    echo "INFO count:  $(grep -c 'INFO' "$LOG_FILE" || echo 0)"
    echo ""

    # Top 10 most frequent ERROR messages
    # awk '{print $NF}'  -> extract the last field (usually the message/code)
    # sort               -> sort messages alphabetically (needed before uniq)
    # uniq -c            -> count duplicate occurrences
    # sort -rn           -> sort numerically, descending
    # head -10           -> take top 10
    echo "Top 10 most frequent ERROR messages:"
    grep 'ERROR' "$LOG_FILE" | awk '{print $NF}' | sort | uniq -c | sort -rn | head -10

} > "$REPORT_FILE"

echo "Report saved to $REPORT_FILE"
