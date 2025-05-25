#!/bin/bash

# Check if URL is passed as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <website_url>"
    exit 1
fi

URL=$1

# Extract domain from URL
DOMAIN=$(echo $URL | sed -E 's#https?://([^/]+).*#\1#')

echo "Target Website: $URL"
echo "Domain: $DOMAIN"
echo

# 1. Get emails from website HTML (using curl and grep)
echo "[*] Extracting emails from website HTML..."
EMAILS=$(curl -s $URL | grep -oP '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}' | sort -u)
if [ -z "$EMAILS" ]; then
    echo "No emails found on the website."
else
    echo "Emails found:"
    echo "$EMAILS"
fi
echo

# 2. DNS records lookup (A, MX, NS)
echo "[*] DNS records for $DOMAIN"
echo "A record(s):"
dig +short A $DOMAIN
echo
echo "MX record(s):"
dig +short MX $DOMAIN
echo
echo "NS record(s):"
dig +short NS $DOMAIN
echo

# 3. WHOIS information
echo "[*] WHOIS info for $DOMAIN"
whois $DOMAIN | grep -E 'Registrar:|Creation Date:|Expiration Date:|Name Server:'
echo

# 4. Validate email domain (simple check)
if [ ! -z "$EMAILS" ]; then
    echo "[*] Validating email domains by checking MX records..."
    for email in $EMAILS; do
        EMAIL_DOMAIN=$(echo $email | cut -d '@' -f 2)
        MX=$(dig +short MX $EMAIL_DOMAIN)
        if [ -z "$MX" ]; then
            echo "$email : Invalid (No MX record found)"
        else
            echo "$email : Valid (MX record exists)"
        fi
    done
fi

echo
echo "Footprinting complete."



