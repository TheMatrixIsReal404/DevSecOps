# 🛠️ Networking Commands Cheatsheet

> **DevSecOps Reference** — Commands you'll use daily for DNS, HTTP, TLS, and traffic analysis.
> Add new commands as you learn them. Date each new section.

---

## 📡 DNS Commands

### `dig` — DNS Information Groper (Primary Tool)

```bash
# ── Basic Lookups ──────────────────────────────────────────
dig example.com                    # Default A record lookup
dig example.com +short             # Just the IP, no noise
dig example.com +noall +answer     # Clean answer section only

# ── Record Types ───────────────────────────────────────────
dig example.com A                  # IPv4 address
dig example.com AAAA               # IPv6 address
dig example.com MX                 # Mail servers
dig example.com TXT                # SPF / DKIM / verification
dig example.com NS                 # Nameservers for the domain
dig example.com CNAME              # Alias record
dig example.com SOA                # Start of Authority (zone info)
dig example.com ANY                # All records (often blocked now)

# ── Tracing ────────────────────────────────────────────────
dig example.com +trace             # Full chain: root → TLD → authoritative
dig example.com +trace +additional # Trace with extra info

# ── Choose a DNS Server ────────────────────────────────────
dig @8.8.8.8 example.com          # Google DNS
dig @1.1.1.1 example.com          # Cloudflare DNS
dig @9.9.9.9 example.com          # Quad9 DNS (privacy focused)
dig @208.67.222.222 example.com   # OpenDNS

# ── Reverse DNS (IP → Domain) ──────────────────────────────
dig -x 93.184.216.34              # Reverse lookup
dig -x 8.8.8.8 +short            # Google's reverse DNS

# ── Useful Flags ───────────────────────────────────────────
dig example.com +stats            # Show query time and server
dig example.com +tcp              # Force TCP instead of UDP
dig example.com +dnssec           # Check DNSSEC validation
dig example.com +noquestion       # Hide question section
```

### `nslookup` — Simpler Alternative

```bash
nslookup example.com              # Basic lookup
nslookup example.com 8.8.8.8     # Use specific DNS server
nslookup -type=MX example.com    # Specific record type
nslookup -type=TXT example.com   # TXT records
```

### `host` — Quick and Clean

```bash
host example.com                  # Quick IP lookup
host -t MX example.com           # Mail records
host 93.184.216.34               # Reverse lookup
```

---

## 🌐 HTTP / HTTPS Commands

### `curl` — Transfer Tool (Most Versatile)

```bash
# ── Basic Requests ─────────────────────────────────────────
curl https://example.com              # GET request, print body
curl -o file.html https://example.com # Save response to file
curl -s https://example.com           # Silent (no progress bar)

# ── Verbose / Debug ────────────────────────────────────────
curl -v https://example.com           # Verbose: see TCP+TLS+HTTP
curl -vv https://example.com          # Extra verbose
curl --trace-ascii dump.txt https://example.com  # Full trace to file

# ── Headers Only ───────────────────────────────────────────
curl -I https://example.com           # HEAD request (headers only)
curl -D - https://example.com         # Response headers + body
curl -H "User-Agent: MyBot" https://example.com  # Custom header

# ── HTTP Methods ───────────────────────────────────────────
curl -X GET https://api.example.com/users
curl -X POST -d '{"name":"Ankit"}' -H "Content-Type: application/json" https://api.example.com/users
curl -X DELETE https://api.example.com/users/1

# ── Follow Redirects ───────────────────────────────────────
curl -L https://example.com           # Follow 301/302 redirects
curl -v -L https://example.com        # See each redirect hop

# ── TLS / Certificate Options ──────────────────────────────
curl -k https://example.com           # Skip certificate verification (INSECURE - testing only)
curl --cacert myCA.pem https://example.com  # Use custom CA

# ── Filtering curl -v output ───────────────────────────────
curl -v https://example.com 2>&1 | grep "^\*"   # Connection/TLS lines only
curl -v https://example.com 2>&1 | grep "^>"    # Request lines only
curl -v https://example.com 2>&1 | grep "^<"    # Response lines only
curl -v https://example.com 2>&1 | grep -E "^\*|^>|^<"  # All key lines
```

### Reading `curl -v` Output

```
* Trying 93.184.216.34:443...      ← TCP: connecting
* Connected to example.com         ← TCP: 3-way handshake done
* SSL connection using TLSv1.3     ← TLS: version negotiated
* Server certificate:              ← TLS: cert details start
*  subject: CN=example.com         ← TLS: who the cert is for
*  issuer: CN=DigiCert             ← TLS: who signed the cert
> GET / HTTP/2                     ← HTTP: your request
> Host: example.com
> User-Agent: curl/7.x
>                                  ← blank line = end of request
< HTTP/2 200                       ← HTTP: server response code
< content-type: text/html          ← HTTP: response headers
<                                  ← blank line = headers done
(HTML body follows...)             ← HTTP: the actual content
```

---

## 🔒 TLS / SSL Commands

### `openssl` — Swiss Army Knife for TLS

```bash
# ── Connect and Inspect ────────────────────────────────────
openssl s_client -connect example.com:443          # Full TLS handshake
openssl s_client -connect example.com:443 -quiet   # Less noise
openssl s_client -connect example.com:443 -showcerts  # Full cert chain

# ── Check TLS Version Support ──────────────────────────────
openssl s_client -connect example.com:443 -tls1_3  # Test TLS 1.3
openssl s_client -connect example.com:443 -tls1_2  # Test TLS 1.2
openssl s_client -connect example.com:443 -tls1_1  # Test TLS 1.1 (should fail on good sites)

# ── Inspect a Certificate File ─────────────────────────────
openssl x509 -in cert.pem -text -noout            # Full cert details
openssl x509 -in cert.pem -dates -noout           # Expiry dates only
openssl x509 -in cert.pem -subject -noout         # Who cert is for

# ── Get Certificate from Live Site ─────────────────────────
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -text -noout

# ── Check Cert Expiry (one-liner) ──────────────────────────
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates
```

### Reading `openssl s_client` Output

```
CONNECTED(00000003)                        ← TCP connected
depth=2 C=US, O=DigiCert, CN=Root CA      ← Cert chain: root
depth=1 O=DigiCert, CN=Intermediate CA    ← Cert chain: intermediate
depth=0 CN=example.com                    ← Cert chain: site cert
---
Certificate chain
 0 s:CN=example.com                       ← Subject (who it's for)
   i:CN=DigiCert TLS RSA SHA256           ← Issuer (who signed it)
---
SSL-Session:
    Protocol  : TLSv1.3                   ← TLS version used
    Cipher    : TLS_AES_256_GCM_SHA384    ← Cipher suite chosen
    Session-ID: ...
---
```

---

## 🔍 Network Inspection Commands

### Active Connections

```bash
# Modern way (use ss)
ss -tn                            # TCP connections, no DNS lookup
ss -tnp                          # + show process name
ss -tlnp                         # Listening ports only
ss -tn state established          # Only established connections

# Old way (netstat — may not be installed)
netstat -an                       # All connections
netstat -an | grep ESTABLISHED    # Active only
netstat -tlnp                     # Listening ports
```

### Port Scanning (for your own systems)

```bash
nmap localhost                    # Scan your own machine
nmap -p 80,443 example.com       # Check specific ports
nmap -sV example.com             # Detect service versions
```

### Packet Capture

```bash
# tcpdump — command line
tcpdump -i eth0                   # Capture on eth0
tcpdump -i any port 53            # Only DNS traffic
tcpdump -i any port 80 or port 443  # Only web traffic
tcpdump -w capture.pcap           # Save to file (open in Wireshark)
tcpdump -r capture.pcap           # Read saved file

# Watch DNS queries live
tcpdump -i any -n port 53
```

---

## 📊 HTTP Status Code Reference

```
1xx — Informational
  100 Continue
  101 Switching Protocols (used in WebSocket upgrade)

2xx — Success
  200 OK                  (everything worked)
  201 Created             (POST created a resource)
  204 No Content          (success, nothing to return)

3xx — Redirects
  301 Moved Permanently   (update your bookmarks/links)
  302 Found               (temporary redirect)
  304 Not Modified        (use your cached version)

4xx — Client Errors (YOU did something wrong)
  400 Bad Request         (malformed request)
  401 Unauthorized        (not logged in)
  403 Forbidden           (logged in but no permission)
  404 Not Found           (resource doesn't exist)
  429 Too Many Requests   (rate limited)

5xx — Server Errors (SERVER did something wrong)
  500 Internal Server Error  (generic server crash)
  502 Bad Gateway            (upstream server issue)
  503 Service Unavailable    (server overloaded/down)
```

---

## 🚀 Common DNS Port Numbers

```
DNS         → 53   (UDP default, TCP for large responses)
HTTP        → 80
HTTPS       → 443
FTP         → 21
SSH         → 22
SMTP        → 25   (email sending)
IMAP        → 143  (email receiving)
IMAPS       → 993  (IMAP over TLS)
RDP         → 3389 (Windows Remote Desktop)
MySQL       → 3306
PostgreSQL  → 5432
```

---

## 🔐 Security-Focused One-Liners

```bash
# Check what TLS version a site uses
curl -vI https://example.com 2>&1 | grep "SSL connection"

# Check certificate expiry date
echo | openssl s_client -connect example.com:443 2>/dev/null \
  | openssl x509 -noout -dates

# Check if HTTP redirects to HTTPS
curl -v http://example.com 2>&1 | grep -E "Location|HTTP/"

# DNS zone transfer attempt (should be blocked on real servers)
dig axfr example.com @ns1.example.com

# Find all DNS records for a domain
for type in A AAAA MX TXT NS CNAME SOA; do
  echo "=== $type ==="
  dig example.com $type +short
done

# Watch DNS queries in real-time
sudo tcpdump -i any -n 'port 53'
```

---

*Last updated: Day 16 — Week 3*
*Add new commands below with date and context*
