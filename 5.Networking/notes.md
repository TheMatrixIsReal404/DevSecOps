# 📅 Day 16 (Week 3 — Day 2) · Networking Protocols & References/Memory
 
## 🔐 DevSecOps — TCP/IP, DNS & HTTP/HTTPS: How They Actually Work
 
> **Today's Goal:** Go from "I know what DNS is" to actually watching a DNS resolution and an HTTP request happen on the wire.
 
---
 
## 📚 Part 1: OSI 7-Layer Model vs TCP/IP 4-Layer Model
 
### What is the OSI Model?
 
The **OSI (Open Systems Interconnection)** model is a conceptual framework that describes how data travels from one computer to another across a network. Think of it like a factory assembly line — each layer has a specific job.
 
```
OSI 7-Layer Model          TCP/IP 4-Layer Model
─────────────────          ────────────────────
7. Application   ┐
6. Presentation  ├──────►  4. Application
5. Session       ┘
─────────────────          ──────────────────
4. Transport     ───────►  3. Transport
─────────────────          ──────────────────
3. Network       ───────►  2. Internet
─────────────────          ──────────────────
2. Data Link     ┐
1. Physical      ├──────►  1. Network Access
─────────────────          ──────────────────
```
 
### Where Each Protocol Lives
 
| Protocol | OSI Layer | TCP/IP Layer | What it does |
|----------|-----------|--------------|--------------|
| HTTP/HTTPS | 7 - Application | Application | Web browsing |
| TLS/SSL | 6 - Presentation | Application | Encryption |
| TCP | 4 - Transport | Transport | Reliable delivery |
| UDP | 4 - Transport | Transport | Fast, no guarantee |
| IP | 3 - Network | Internet | Addressing & routing |
| Ethernet | 2 - Data Link | Network Access | Local delivery |
 
### 🔑 Key Takeaway for DevSecOps
Most attacks and vulnerabilities happen at **Layers 3–7**. Understanding which layer a protocol operates on helps you know WHERE to look when something goes wrong or is being exploited.
 
---
 
## 📚 Part 2: DNS Resolution Chain
 
### What is DNS?
 
**DNS (Domain Name System)** is like the internet's phone book. When you type `google.com`, your computer doesn't know where that is — DNS translates it to an IP address like `142.250.190.14`.
 
### The DNS Resolution Journey
 
```
Your Browser
     │
     ▼
1. Recursive Resolver (your ISP or 8.8.8.8)
     │  "I'll find the answer for you"
     ▼
2. Root Nameserver (.)
     │  "I don't know google.com, but ask .com servers"
     ▼
3. TLD Nameserver (.com)
     │  "I don't know google.com, but ask Google's servers"
     ▼
4. Authoritative Nameserver (ns1.google.com)
     │  "google.com = 142.250.190.14 ✓"
     ▼
Back to your browser → connects to 142.250.190.14
```
 
### DNS Record Types (Beginner Must-Know)
 
| Record | Purpose | Example |
|--------|---------|---------|
| `A` | Maps domain → IPv4 address | `google.com → 142.250.190.14` |
| `AAAA` | Maps domain → IPv6 address | `google.com → 2607:f8b0::...` |
| `CNAME` | Alias, points to another domain | `www.example.com → example.com` |
| `MX` | Mail server for the domain | `example.com → mail.example.com` |
| `TXT` | Text info (SPF, verification) | Used in email security |
| `NS` | Nameservers for the domain | `example.com → ns1.example.com` |
 
### 🔐 Why This Matters for Security
- **DNS Poisoning** — attacker injects fake DNS records → you visit evil site thinking it's legit
- **DNS Enumeration** — attacker maps out all subdomains of a target
- **DNS over HTTPS (DoH)** — encrypts DNS queries so your ISP can't see what you're visiting
### Hands-On Command: `dig`
 
```bash
# Basic DNS lookup
dig google.com
 
# Trace the full resolution chain (root → TLD → authoritative)
dig google.com +trace
 
# Look up a specific record type
dig google.com MX          # mail records
dig google.com NS          # nameserver records
dig google.com TXT         # text records
 
# Use a specific DNS server
dig @8.8.8.8 google.com    # use Google's DNS
 
# Short output only
dig google.com +short
```
 
**Reading `dig` output:**
```
;; ANSWER SECTION:
google.com.    300    IN    A    142.250.190.14
│              │      │     │    └─ The IP address
│              │      │     └─ Record type (A = IPv4)
│              │      └─ Internet class
│              └─ TTL (Time To Live) in seconds
└─ The queried domain
```
 
---
 
## 📚 Part 3: HTTP/1.1 vs HTTP/2 vs HTTP/3
 
### HTTP/1.1 (The Old Way — 1997)
- **One request at a time** per connection
- Browser opens 6 connections to load 6 things simultaneously
- **Head-of-line blocking**: one slow request blocks everything
- Plain text headers (wasteful, human-readable)
```
Client                    Server
  │── GET /index.html ──►  │
  │◄─ 200 OK + HTML ───────│
  │── GET /style.css ──►   │   ← wait...
  │◄─ 200 OK + CSS ────────│
  │── GET /script.js ──►   │   ← wait again...
  │◄─ 200 OK + JS ─────────│
```
 
### HTTP/2 (Better — 2015)
- **Multiplexing**: multiple requests over ONE connection simultaneously
- **Header compression** (HPACK) — headers are binary, compressed
- **Server push** — server can send files before you ask
- Still runs over TCP (so TCP-level blocking still exists)
```
Client                    Server
  │── GET /index.html ──►  │
  │── GET /style.css ───►  │   ← All at once!
  │── GET /script.js ───►  │
  │◄── All responses ──────│
```
 
### HTTP/3 (Newest — 2022)
- Runs over **QUIC** (not TCP!) — QUIC is built on **UDP**
- Truly eliminates head-of-line blocking
- **Faster connection setup** — 0-RTT or 1-RTT (vs TCP's 3-way handshake)
- **Better on mobile** — handles network switches gracefully
```
HTTP/1.1  ──► TCP  ──► IP
HTTP/2    ──► TCP  ──► IP
HTTP/3    ──► QUIC (UDP) ──► IP
```
 
### 🔐 Security Note
HTTP/2 and HTTP/3 **require HTTPS**. This is enforced in browsers. Always assume modern apps use HTTP/2+.
 
---
 
## 📚 Part 4: HTTPS / TLS Handshake
 
### What is TLS?
 
**TLS (Transport Layer Security)** is what puts the "S" in HTTPS. It creates an **encrypted tunnel** so nobody can read your data in transit. The old version was called SSL (don't use it — it's broken).
 
### The TLS 1.3 Handshake (Simplified)
 
```
Client (Browser)               Server (Website)
       │                              │
       │──── 1. Client Hello ────────►│
       │    (supported ciphers,        │
       │     TLS version, random)      │
       │                              │
       │◄─── 2. Server Hello ─────────│
       │    (chosen cipher,            │
       │     certificate, random)      │
       │                              │
       │     [Browser verifies         │
       │      certificate is           │
       │      signed by trusted CA]    │
       │                              │
       │──── 3. Key Exchange ────────►│
       │    (encrypted pre-master      │
       │     secret)                   │
       │                              │
       │    [Both sides derive the     │
       │     SAME symmetric key]       │
       │                              │
       │◄═══ Encrypted Channel ══════►│
       │    All HTTP traffic is        │
       │    now encrypted              │
```
 
### TLS Certificate Chain of Trust
 
```
Root CA (e.g., DigiCert)
    └── Intermediate CA
            └── Your Website's Certificate
                    └── Public Key for encryption
```
 
- **Root CAs** are pre-installed in your OS/browser (trust anchors)
- **If any link is broken** → browser shows "Your connection is not private"
### Key Concepts
 
| Term | Meaning |
|------|---------|
| **Certificate** | Digital ID card for a website, signed by a CA |
| **CA (Certificate Authority)** | Trusted organization that issues certificates (DigiCert, Let's Encrypt) |
| **Public Key** | Used to encrypt data — anyone can see it |
| **Private Key** | Used to decrypt data — kept SECRET on the server |
| **Symmetric Key** | Session key both sides use after handshake (AES) |
| **Cipher Suite** | The set of algorithms used (key exchange + encryption + hash) |
 
### 🔐 Common TLS Attacks to Know
- **MITM (Man-in-the-Middle)** — attacker intercepts traffic, fakes certificates
- **SSL Stripping** — downgrades HTTPS to HTTP silently
- **Expired Certificates** — website forgets to renew → untrusted
- **Self-Signed Certs** — no CA signed it → browser warns you
---
 
## 🔧 Hands-On Tasks
 
### Task 1: DNS Lookup with `dig`
 
```bash
# Run a basic lookup and read ALL fields
dig example.com
 
# Trace the full chain
dig example.com +trace
 
# Try different record types
dig example.com A
dig example.com AAAA
dig example.com MX
dig example.com TXT
```
 
**What to look for:**
- `QUESTION SECTION` — what you asked
- `ANSWER SECTION` — the actual IP/record
- `Query time` — how fast DNS responded
- `SERVER` — which DNS server answered
### Task 2: Watching TCP + TLS + HTTP with `curl -v`
 
```bash
# Verbose mode shows everything
curl -v https://example.com
 
# What you'll see:
# * Trying 93.184.216.34...        ← TCP connection
# * Connected to example.com       ← TCP handshake done
# * SSL connection using TLS 1.3   ← TLS negotiated
# * Server certificate: ...        ← Certificate shown
# > GET / HTTP/2                   ← HTTP request sent
# < HTTP/2 200                     ← HTTP response received
```
 
```bash
# See ONLY the TLS handshake details
openssl s_client -connect example.com:443
 
# What to look for:
# Certificate chain (who signed what)
# SSL-Session cipher suite
# TLS protocol version
```
 
### Task 3: Identify Each Phase in curl Output
 
Mark these phases in your curl -v output:
- [ ] **TCP Handshake** — "Trying..." and "Connected"
- [ ] **TLS Handshake** — "SSL connection using..." lines
- [ ] **HTTP Request** — Lines starting with `>`
- [ ] **HTTP Response** — Lines starting with `<`
---
 
## 📝 Notes Space — Key Commands Practiced Today
 
```bash
# DNS Tools
dig example.com +trace          # Full DNS resolution chain
dig example.com +short          # Just the IP
nslookup example.com            # Alternative DNS lookup tool
nslookup example.com 8.8.8.8   # Use Google's DNS resolver
 
# HTTP/HTTPS Tools
curl -v https://example.com     # Verbose: see TCP+TLS+HTTP
curl -I https://example.com     # Headers only (HEAD request)
curl -v https://example.com 2>&1 | grep -E "^\*|^>|^<"  # Filter to key lines
 
# TLS/SSL Inspection
openssl s_client -connect example.com:443          # Full TLS handshake
openssl s_client -connect example.com:443 -showcerts  # Show full cert chain
 
# Network Inspection
netstat -an | grep ESTABLISHED  # Show active connections
ss -tn                          # Modern replacement for netstat
```
 
---
 
## 🧠 Quick Reference Card
 
```
DNS PORT:   53 (UDP usually, TCP for large responses)
HTTP PORT:  80
HTTPS PORT: 443
 
DNS Query Types:
  A     = IPv4 address
  AAAA  = IPv6 address
  CNAME = Alias
  MX    = Mail
  TXT   = Text/SPF/DKIM
  NS    = Nameservers
 
TLS Versions (newest to oldest):
  TLS 1.3 ✅ Use this
  TLS 1.2 ✅ Still OK
  TLS 1.1 ❌ Deprecated
  TLS 1.0 ❌ Deprecated
  SSL 3.0 ❌ Broken
  SSL 2.0 ❌ Broken
 
HTTP Status Codes:
  2xx = Success (200 OK, 201 Created)
  3xx = Redirect (301 Moved, 302 Found)
  4xx = Client Error (400 Bad Request, 403 Forbidden, 404 Not Found)
  5xx = Server Error (500 Internal Server Error)
```
 
---
 
## 🔗 Continue Learning
 
- **TryHackMe — Cyber Security 101**: Networking module
  - Practice: Wireshark to capture DNS/HTTP packets
- **Udemy** — Networking section
  - Focus: subnetting, CIDR notation
---
 
## 💡 DevSecOps Mindset for Networking
 
> Every protocol is a potential attack surface. Always ask:
> 1. **Is this encrypted?** (HTTP vs HTTPS)
> 2. **Is the certificate valid?** (TLS chain of trust)
> 3. **What does DNS leakage reveal?** (subdomains = attack surface)
> 4. **Which version?** (TLS 1.0? Vulnerable. HTTP/1.1? Inefficient.)