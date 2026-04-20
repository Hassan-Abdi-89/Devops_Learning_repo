from utils import parse_log_line, detect_bruteforce


def test_parse_log_line():
    line = "192.168.1.1 LOGIN FAIL"
    result = parse_log_line(line)
    assert result["ip"] == "192.168.1.1"
    assert result["status"] == "FAIL"


def test_detect_bruteforce():
    logs = [
        {"ip": "1.1.1.1", "status": "FAIL"},
        {"ip": "1.1.1.1", "status": "FAIL"},
        {"ip": "1.1.1.1", "status": "FAIL"},
        {"ip": "2.2.2.2", "status": "SUCCESS"},
    ]

    result = detect_bruteforce(logs, threshold=3)
    assert "1.1.1.1" in result