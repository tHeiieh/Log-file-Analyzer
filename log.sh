#!/bin/bash

# Check if log file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOG_FILE=$1

# Check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File $LOG_FILE not found!"
    exit 1
fi

# Output file
OUTPUT_FILE="log_analysis_report_$(date +%Y%m%d_%H%M%S).txt"

# Function to print section header
section_header() {
    echo -e "\n====================================" >> $OUTPUT_FILE
    echo -e " $1" >> $OUTPUT_FILE
    echo -e "====================================" >> $OUTPUT_FILE
}

# Function to print subsection header
subsection_header() {
    echo -e "\n** $1 **" >> $OUTPUT_FILE
}

# Initialize report file
echo "Log Analysis Report" > $OUTPUT_FILE
echo "Generated on: $(date)" >> $OUTPUT_FILE
echo "Analyzed file: $LOG_FILE" >> $OUTPUT_FILE

# 1. Request Counts
section_header "1. Request Counts"
total_requests=$(wc -l < "$LOG_FILE")
echo "Total requests: $total_requests" >> $OUTPUT_FILE

get_requests=$(grep -c ' "GET ' "$LOG_FILE")
post_requests=$(grep -c ' "POST ' "$LOG_FILE")
echo "GET requests: $get_requests" >> $OUTPUT_FILE
echo "POST requests: $post_requests" >> $OUTPUT_FILE

# 2. Unique IP Addresses
section_header "2. Unique IP Addresses"
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort | uniq | wc -l)
echo "Total unique IP addresses: $unique_ips" >> $OUTPUT_FILE

subsection_header "Requests per IP (Top 10)"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10 >> $OUTPUT_FILE

subsection_header "GET/POST counts per IP (Top 10)"
awk '{ip=$1; method=$6; if (method ~ /"GET/) get[ip]++; else if (method ~ /"POST/) post[ip]++} END {for (i in get) printf "IP: %-15s GET: %-5d POST: %-5d TOTAL: %-5d\n", i, get[i], post[i], get[i]+post[i]}' "$LOG_FILE" | sort -k6 -nr | head -10 >> $OUTPUT_FILE

# 3. Failure Requests
section_header "3. Failure Requests"
failed_requests=$(awk '$9 ~ /^[45][0-9][0-9]$/ {count++} END {print count}' "$LOG_FILE")
# Using awk for floating point calculation
failure_percentage=$(awk -v failed="$failed_requests" -v total="$total_requests" 'BEGIN {printf "%.2f", (failed/total)*100}')
echo "Failed requests (4xx/5xx): $failed_requests" >> $OUTPUT_FILE
echo "Failure percentage: $failure_percentage%" >> $OUTPUT_FILE

# 4. Top User
section_header "4. Top User"
echo "Most active IP (by request count):" >> $OUTPUT_FILE
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 >> $OUTPUT_FILE

# 5. Daily Request Averages
section_header "5. Daily Request Averages"
echo "Requests per day:" >> $OUTPUT_FILE
awk '{split($4, dateparts, ":"); print substr(dateparts[1], 2)}' "$LOG_FILE" | sort | uniq -c >> $OUTPUT_FILE

total_days=$(awk '{split($4, dateparts, ":"); print substr(dateparts[1], 2)}' "$LOG_FILE" | sort | uniq | wc -l)
# Using awk for floating point calculation
avg_requests_per_day=$(awk -v total="$total_requests" -v days="$total_days" 'BEGIN {printf "%.2f", total/days}')
echo -e "\nAverage requests per day: $avg_requests_per_day" >> $OUTPUT_FILE

# 6. Failure Analysis
section_header "6. Failure Analysis"
subsection_header "Days with most failures (Top 5)"
awk '$9 ~ /^[45][0-9][0-9]$/ {split($4, dateparts, ":"); print substr(dateparts[1], 2)}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 >> $OUTPUT_FILE

# Additional Analysis

# Request by Hour
section_header "Request by Hour"
echo "Requests per hour (all days):" >> $OUTPUT_FILE
awk '{split($4, timeparts, ":"); print timeparts[2]}' "$LOG_FILE" | sort | uniq -c >> $OUTPUT_FILE

# Request Trends
section_header "Request Trends"
subsection_header "Hourly request distribution"
echo "Hour   Requests" >> $OUTPUT_FILE
awk '{split($4, timeparts, ":"); print timeparts[2]}' "$LOG_FILE" | sort | uniq -c | awk '{printf "%-6s %s\n", $2, $1}' >> $OUTPUT_FILE

# Status Codes Breakdown
section_header "Status Codes Breakdown"
subsection_header "HTTP Status Code Counts"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr >> $OUTPUT_FILE

# Most Active User by Method
section_header "Most Active User by Method"
subsection_header "IP with most GET requests"
grep ' "GET ' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1 >> $OUTPUT_FILE

subsection_header "IP with most POST requests"
grep ' "POST ' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1 >> $OUTPUT_FILE

# Patterns in Failure Requests
section_header "Patterns in Failure Requests"
subsection_header "Failure requests by hour"
awk '$9 ~ /^[45][0-9][0-9]$/ {split($4, timeparts, ":"); print timeparts[2]}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 >> $OUTPUT_FILE

subsection_header "Common failure status codes"
awk '$9 ~ /^[45][0-9][0-9]$/ {print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr >> $OUTPUT_FILE

# Analysis Suggestions
section_header "Analysis Suggestions"

# Generate suggestions based on findings
echo "Based on the analysis, here are some suggestions:" >> $OUTPUT_FILE

# Get top failure day
top_failure_day=$(awk '$9 ~ /^[45][0-9][0-9]$/ {split($4, dateparts, ":"); print substr(dateparts[1], 2)}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
top_failure_count=$(awk '$9 ~ /^[45][0-9][0-9]$/ {split($4, dateparts, ":"); print substr(dateparts[1], 2)}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $1}')

# Get top failure hour
top_failure_hour=$(awk '$9 ~ /^[45][0-9][0-9]$/ {split($4, timeparts, ":"); print timeparts[2]}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
top_failure_hour_count=$(awk '$9 ~ /^[45][0-9][0-9]$/ {split($4, timeparts, ":"); print timeparts[2]}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $1}')

# Get most common error code
common_error=$(awk '$9 ~ /^[45][0-9][0-9]$/ {print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

echo "- The day with most failures was $top_failure_day with $top_failure_count failed requests. Investigate server logs from this day for patterns." >> $OUTPUT_FILE
echo "- The hour with most failures was $top_failure_hour:00 with $top_failure_hour_count failures. Consider increasing monitoring during this hour." >> $OUTPUT_FILE
echo "- The most common error code was $common_error. Research solutions specific to this error code." >> $OUTPUT_FILE
echo "- Review the top IP addresses making requests. If any single IP is making an unusually high number of requests, consider implementing rate limiting." >> $OUTPUT_FILE
echo "- Based on the hourly request distribution, scale server resources accordingly to handle peak loads." >> $OUTPUT_FILE
echo "- For POST requests, ensure proper validation is in place to prevent malformed requests that might lead to errors." >> $OUTPUT_FILE

# Calculate alert threshold without bc
alert_threshold=$(awk -v fp="$failure_percentage" 'BEGIN {printf "%.0f", fp + 5}')
echo "- Implement automated alerts for when failure rates exceed ${alert_threshold}% (current rate: $failure_percentage%)." >> $OUTPUT_FILE

echo -e "\nAnalysis complete. Report saved to $OUTPUT_FILE"
