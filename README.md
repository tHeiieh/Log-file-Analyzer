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

![Sample output](![image](https://github.com/user-attachments/assets/e27e4685-134b-4933-9529-5708fb8e4ff8)
)

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
