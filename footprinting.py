# footprinting.py

import requests
import socket
import whois

def get_ip(domain):
    try:
        ip = socket.gethostbyname(domain)
        return ip
    except socket.gaierror:
        return None

def get_whois(domain):
    try:
        w = whois.whois(domain)
        return w
    except Exception as e:
        return None

def check_website_status(url):
    try:
        response = requests.get(url, timeout=5)
        return response.status_code
    except requests.RequestException:
        return None

def footprint_email(email):
    # Simple check: domain part + WHOIS info
    domain = email.split('@')[-1]
    ip = get_ip(domain)
    w = get_whois(domain)
    return {
        "Email": email,
        "Domain": domain,
        "Domain IP": ip,
        "Domain Owner": w.org if w else "N/A",
        "Registrar": w.registrar if w else "N/A"
    }

if __name__ == "__main__":
    target_domain = "example.com"
    target_email = "admin@example.com"
    print(f"--- Footprinting Website: {target_domain} ---")
    print(f"IP Address: {get_ip(target_domain)}")
    print(f"WHOIS Info: {get_whois(target_domain)}")
    print(f"Website Status Code: {check_website_status('http://' + target_domain)}")

    print("\n--- Footprinting Email ---")
    result = footprint_email(target_email)
    for k, v in result.items():
        print(f"{k}: {v}")
