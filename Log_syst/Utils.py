def parse_log_line(line):
    parts = line.strip().split(" ")
    return {
        "ip": parts[0],
        "status": parts[-1]
    }


def detect_bruteforce(logs, threshold=3):
    ip_count = {}

    for log in logs:
        if log["status"] == "FAIL":
            ip_count[log["ip"]] = ip_count.get(log["ip"], 0) + 1

    suspicious = [ip for ip, count in ip_count.items() if count >= threshold]
    return suspicious