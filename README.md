# Log-file-Analyzer
# Log Analysis Tool

![Python](https://img.shields.io/badge/python-3.8+-blue.svg)


A comprehensive log analysis solution that processes server logs, generates key metrics, and creates visualizations to identify traffic patterns and potential issues.

## Features

- **Multi-format support**: Processes Apache/NGINX common and combined log formats
- **Automated reporting**:
  - Request statistics (GET/POST distribution)
  - Error rate analysis (4xx/5xx breakdown)
  - Top IP addresses analysis
- **Visualizations**:
  - Hourly request trends
  - Status code distributions
  - Daily traffic patterns
  - Top IP activity
- **Actionable insights** with failure pattern detection

## Sample Output

Log Analysis Report

Generated by: Taha Abdelwadoud, ID: 2205030

Generated on: Sat May 10 09:43:16 AM EDT 2025
Analyzed file: logs.log

====================================
 1. Request Counts
====================================
Total requests: 10000
GET requests: 9952
POST requests: 5

====================================
 2. Unique IP Addresses
====================================
Total unique IP addresses: 1753

** Requests per IP (Top 10) **
     482 66.249.73.135
     364 46.105.14.53
     357 130.237.218.86
     ...

** GET/POST counts per IP (Top 10) **
IP: 66.249.73.135     GET: 482   POST: 0     TOTAL: 482
IP: 46.105.14.53      GET: 364   POST: 0     TOTAL: 364
...

====================================
 3. Failure Requests
====================================
Failed requests (4xx/5xx): 213
Failure percentage: 2.13%

...

====================================
 Analysis Suggestions
====================================
Based on the analysis, here are some suggestions:
- The day with most failures was 19/May/2015 with 66 failed requests. Investigate server logs from this day for patterns.
- The hour with most failures was 09:00 with 18 failures. Consider increasing monitoring during this hour.
- The most common error code was 404. Research solutions specific to this error code.
...


## Installation

1. Clone the repository:
```bash
git clone https://github.com/tHeiieh/Log-file-Analyzer.git
cd log-analyzer
Create virtual environment (recommended):

bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
Install dependencies:

bash
pip install -r requirements.txt
Usage
Basic analysis:

bash
python log_analyzer.py access.log
Advanced options:

bash
# Analyze with custom output directory
python log_analyzer.py access.log --output ./reports/

# Specify time range (YYYY-MM-DD)
python log_analyzer.py access.log --start 2025-05-01 --end 2025-05-31
Output Files
The tool generates:

log_analysis_report_<timestamp>.txt - Full textual report

requests_by_hour.png - Hourly traffic visualization

status_codes.png - Status code distribution

daily_requests.png - Daily trend graph

top_ips.png - Top IP addresses

[visualization]
style = seaborn       # matplotlib style
color_palette = husl  # Visualization colors
Requirements
Python 3.8+

Libraries:

pandas

matplotlib

seaborn
