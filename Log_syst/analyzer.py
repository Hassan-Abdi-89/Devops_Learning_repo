import sys
from utils import parse_log_line, detect_bruteforce


def analyze(file_path):
    logs = []

    with open(file_path, "r") as f:
        for line in f:
            logs.append(parse_log_line(line))

    suspicious_ips = detect_bruteforce(logs)

    print("=== Analysis Report ===")
    print(f"Total Logs: {len(logs)}")
    print(f"Suspicious IPs: {suspicious_ips}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python analyzer.py <logfile>")
    else:
        analyze(sys.argv[1])