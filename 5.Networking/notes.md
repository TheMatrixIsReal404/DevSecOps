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

# 🔐 Week 3 — Day 17: VPCs, Subnets, CIDR Blocks & Routing Tables
 
> **Goal:** Be able to design a basic VPC layout and do CIDR math without a calculator.
 
---
 
## 1.0 — What is a VPC?
 
A **VPC (Virtual Private Cloud)** is an isolated virtual network inside a cloud provider (AWS, GCP, Azure).
 
- Think of it as your own private data center inside AWS
- You control the IP ranges, subnets, routing, and security
- Nothing gets in or out unless you explicitly allow it
- Every AWS account gets a **default VPC** in each region
```
AWS Region
└── VPC (your isolated network, e.g. 10.0.0.0/16)
    ├── Availability Zone A
    │   ├── Public Subnet  (10.0.1.0/24)
    │   └── Private Subnet (10.0.2.0/24)
    └── Availability Zone B
        ├── Public Subnet  (10.0.3.0/24)
        └── Private Subnet (10.0.4.0/24)
```
 
---
 
## 2.0 — CIDR Notation
 
**CIDR = Classless Inter-Domain Routing**
 
Written as: `IP_Address / prefix_length`
Example: `10.0.0.0/16`
 
The prefix (the number after `/`) tells you how many bits are "fixed" (the network part).
The remaining bits are for hosts.
 
### Formula for usable hosts:
```
Usable hosts = 2^(32 - prefix) - 2
```
We subtract 2 because:
- First address = **Network address** (identifies the subnet)
- Last address  = **Broadcast address** (sends to all hosts)
### CIDR Cheat Sheet
 
| CIDR | Total IPs | Usable Hosts | Common Use |
|------|-----------|--------------|------------|
| /32  | 1         | 1 (itself)   | Single host rule in Security Group |
| /30  | 4         | 2            | Point-to-point links |
| /28  | 16        | 14           | Small subnet |
| /27  | 32        | 30           | Small subnet |
| /24  | 256       | 254          | Standard subnet (most common) |
| /20  | 4,096     | 4,094        | Medium VPC subnet |
| /16  | 65,536    | 65,534       | Large VPC CIDR |
 
### Practice Drill
 
**How many usable hosts in a /28?**
```
2^(32 - 28) - 2
= 2^4 - 2
= 16 - 2
= 14 usable hosts
```
 
**How many usable hosts in a /20?**
```
2^(32 - 20) - 2
= 2^12 - 2
= 4096 - 2
= 4094 usable hosts
```
 
---
 
## 3.0 — Public vs Private Subnets
 
| Feature | Public Subnet | Private Subnet |
|---------|--------------|----------------|
| Internet access | Direct (via IGW) | Indirect (via NAT) |
| Has route to IGW | ✅ Yes | ❌ No |
| Resources | Load Balancers, Bastion Hosts | App servers, Databases |
| Gets public IP | Can auto-assign | No |
 
### Internet Gateway (IGW)
- Attached to the VPC
- Allows **two-way** traffic between public subnet and the internet
- No bandwidth limit, no availability concern (AWS manages it)
### NAT Gateway
- Sits in a **public subnet**
- Allows **private subnet** resources to initiate outbound internet traffic
- The internet **cannot initiate** connections back (one-way outbound only)
- Used for: downloading patches, calling external APIs from private servers
```
Private Subnet → NAT Gateway (in Public Subnet) → IGW → Internet
Internet       → IGW → ❌ (cannot reach private subnet directly)
```
 
---
 
## 4.0 — Route Tables
 
A **Route Table** is a set of rules that determines where network traffic is directed.
 
- Every subnet is associated with exactly one route table
- A route table can be associated with multiple subnets
- The VPC has a **main route table** by default
### Example: Public Subnet Route Table
 
| Destination | Target | Meaning |
|-------------|--------|---------|
| 10.0.0.0/16 | local  | Traffic within VPC stays local |
| 0.0.0.0/0   | igw-xxxx | All other traffic → Internet Gateway |
 
### Example: Private Subnet Route Table
 
| Destination | Target | Meaning |
|-------------|--------|---------|
| 10.0.0.0/16 | local  | Traffic within VPC stays local |
| 0.0.0.0/0   | nat-xxxx | All other traffic → NAT Gateway |
 
> ⚠️ **Key difference:** Public subnets have `0.0.0.0/0 → IGW`. Private subnets have `0.0.0.0/0 → NAT`.
 
---
 
## 5.0 — Security Groups vs NACLs
 
These are two layers of security filtering in a VPC.
 
| Feature | Security Group | NACL (Network ACL) |
|---------|---------------|---------------------|
| Level | Instance level | Subnet level |
| State | **Stateful** | **Stateless** |
| Rules | Allow only | Allow AND Deny |
| Evaluation | All rules evaluated | Rules evaluated in number order |
| Default | Deny all inbound, allow all outbound | Allow all in/out |
 
### Stateful vs Stateless explained:
- **Stateful (SG):** If you allow inbound port 80, the return traffic is automatically allowed — no need to add an outbound rule.
- **Stateless (NACL):** You must explicitly allow BOTH inbound AND outbound for each connection. Return traffic is NOT automatic.
### When to use each:
- **Security Groups** → primary defense for EC2, RDS, Lambda (most common)
- **NACLs** → subnet-wide emergency blocks (e.g. blocking a known malicious IP range fast)
---
 
## 6.0 — Designing a VPC Layout
 
### Standard 2 AZ VPC Design (for high availability):
 
```
VPC: 10.0.0.0/16
│
├── Availability Zone A (ap-south-1a)
│   ├── Public Subnet A:  10.0.1.0/24  → Route to IGW
│   └── Private Subnet A: 10.0.2.0/24  → Route to NAT GW
│
└── Availability Zone B (ap-south-1b)
    ├── Public Subnet B:  10.0.3.0/24  → Route to IGW
    └── Private Subnet B: 10.0.4.0/24  → Route to NAT GW
 
Internet Gateway: attached to VPC
NAT Gateway: placed in Public Subnet A (or one per AZ for full HA)
```
 
### Why 2 Availability Zones?
- AZs are physically separate data centers
- If one AZ goes down, your app still runs in the other
- AWS recommends **minimum 2 AZs** for production workloads
---
 
## 7.0 — boto3: Describing VPCs and Subnets
 
Read-only operations to inspect your sandbox VPC setup.
 
```python
import boto3
 
# Always use environment variables — never hardcode credentials
ec2 = boto3.client('ec2', region_name='ap-south-1')
 
# List all VPCs in the account
def list_vpcs():
    response = ec2.describe_vpcs()
    for vpc in response['Vpcs']:
        vpc_id    = vpc['VpcId']
        cidr      = vpc['CidrBlock']
        is_default = vpc.get('IsDefault', False)
        # Get the Name tag if it exists
        name = next(
            (tag['Value'] for tag in vpc.get('Tags', []) if tag['Key'] == 'Name'),
            'No Name'
        )
        print(f"VPC: {vpc_id} | CIDR: {cidr} | Name: {name} | Default: {is_default}")
 
# List all subnets
def list_subnets():
    response = ec2.describe_subnets()
    for subnet in response['Subnets']:
        subnet_id        = subnet['SubnetId']
        vpc_id           = subnet['VpcId']
        cidr             = subnet['CidrBlock']
        az               = subnet['AvailabilityZone']
        available_ips    = subnet['AvailableIpAddressCount']
        public_subnet    = subnet['MapPublicIpOnLaunch']
        name = next(
            (tag['Value'] for tag in subnet.get('Tags', []) if tag['Key'] == 'Name'),
            'No Name'
        )
        print(f"Subnet: {subnet_id} | VPC: {vpc_id} | CIDR: {cidr} | AZ: {az}")
        print(f"  Name: {name} | Available IPs: {available_ips} | Public: {public_subnet}")
 
list_vpcs()
print("---")
list_subnets()
```
 
### Filter subnets by VPC:
```python
def list_subnets_in_vpc(vpc_id):
    response = ec2.describe_subnets(
        Filters=[{'Name': 'vpc-id', 'Values': [vpc_id]}]
    )
    return response['Subnets']
```
 
### List Route Tables:
```python
def list_route_tables():
    response = ec2.describe_route_tables()
    for rt in response['RouteTables']:
        rt_id  = rt['RouteTableId']
        vpc_id = rt['VpcId']
        print(f"Route Table: {rt_id} | VPC: {vpc_id}")
        for route in rt['Routes']:
            dest   = route.get('DestinationCidrBlock', 'N/A')
            target = route.get('GatewayId') or route.get('NatGatewayId') or route.get('InstanceId') or 'local'
            state  = route.get('State', 'unknown')
            print(f"  {dest} → {target} [{state}]")
 
list_route_tables()
```
 
> ✅ **Safety rule:** Only use `describe_*` and `list_*` operations in early weeks. Never call `create_*`, `delete_*`, or `modify_*` on sandbox accounts.
 
---
 
## 8.0 — Key Concepts Summary
 
| Concept | One-line definition |
|---------|---------------------|
| VPC | Isolated virtual network in AWS |
| CIDR | IP range notation — defines how many IPs a block has |
| Subnet | Sub-division of a VPC in one AZ |
| Public Subnet | Has a route to an Internet Gateway |
| Private Subnet | No direct internet — uses NAT for outbound |
| Route Table | Rules deciding where traffic goes |
| IGW | Allows public internet ↔ VPC communication |
| NAT Gateway | Allows private subnet → internet (one-way outbound) |
| Security Group | Stateful, instance-level firewall (Allow only) |
| NACL | Stateless, subnet-level firewall (Allow + Deny) |
 
---
 
## 9.0 — Quick Reference: CIDR Math
 
```
/32 → 1 IP    (1 host)
/30 → 4 IPs   (2 usable)
/28 → 16 IPs  (14 usable)
/27 → 32 IPs  (30 usable)
/26 → 64 IPs  (62 usable)
/25 → 128 IPs (126 usable)
/24 → 256 IPs (254 usable)
/23 → 512 IPs (510 usable)
/22 → 1,024 IPs
/20 → 4,096 IPs
/16 → 65,536 IPs
```
 
**Mental shortcut:** Each step smaller in prefix doubles the IPs.
`/24 = 256`, `/23 = 512`, `/22 = 1024` ... go down, multiply by 2.
 
---
 
## 10.0 — TryHackMe: Networking Module Notes
 
> Continue from where you left off in the Networking 101 module.
 
Key topics covered or coming up:
- OSI Model layers (Physical → Application)
- TCP/IP model vs OSI
- How DNS resolution works
- How DHCP assigns IPs
- Packet structure and headers
- ARP (Address Resolution Protocol)
---
 
*Day 17 complete ✅ | Next: Day 18 — IAM Deep Dive / Python OOP*

---
 
# 🔐 Week 3 — Day 18: OWASP Top 10 & Security Fundamentals
 
> **Today's Goal:** Know all 10 OWASP categories cold — what each one means and one real-world example of each.
 
---
 
## 1.0 — What is OWASP?
 
**OWASP** = Open Web Application Security Project
- A non-profit community that publishes free security resources
- The **OWASP Top 10** is the industry-standard list of the most critical web application security risks
- Updated periodically — current version is **Top 10:2025** (released Jan 2026)
```
Why it matters for DevSecOps:
  Every pipeline you build should check for OWASP risks.
  Security is NOT just the security team's job — it's baked into Dev + Ops too.
```
 
---
 
## 2.0 — OWASP Top 10:2025 — All 10 Categories
 
> ⚠️ **Important Note:** This is the 2025 revision (released Jan 2026) — first update since 2021.
> SSRF was folded into A01 (Broken Access Control), and two new categories were added:
> A03 (Software Supply Chain Failures) and A10 (Mishandling of Exceptional Conditions).
 
---
 
### A01 — Broken Access Control (absorbs SSRF)
 
**What it means:** Users can act outside their permitted scope — accessing data or functions they shouldn't.
 
**How it happens:**
- Missing authorization checks on API endpoints
- Insecure Direct Object References (IDOR) — e.g., changing `?user_id=123` to `?user_id=124` to access another user's data
- SSRF (Server-Side Request Forgery) — tricking the server into making requests to internal services
**Real-world example:**
> **Facebook IDOR (2015):** Researcher could delete any photo on Facebook by manipulating the `photo_id` parameter in an API request — bypassing ownership checks entirely.
 
**Defensive control:**
- Enforce server-side authorization on EVERY request
- Deny by default — whitelist what's allowed, not blacklist what's forbidden
- Use UUIDs instead of sequential IDs
```python
# BAD — trusting client-supplied user ID
def get_profile(user_id):
    return db.query(f"SELECT * FROM users WHERE id={user_id}")
 
# GOOD — use the authenticated session, not client input
def get_profile(request):
    user_id = request.session['authenticated_user_id']  # from server-side session
    return db.query("SELECT * FROM users WHERE id=?", user_id)
```
 
---
 
### A02 — Security Misconfiguration
 
**What it means:** Default settings, verbose errors, or unnecessary features left enabled that expose the system.
 
**How it happens:**
- Default credentials never changed (admin/admin, root/root)
- S3 buckets left publicly readable
- Stack traces shown to users (reveals internal paths, library versions)
- Unnecessary ports/services running
**Real-world example:**
> **Capital One Breach (2019):** An AWS WAF misconfiguration allowed SSRF — the attacker queried the EC2 metadata endpoint to steal IAM credentials, then accessed 100M+ customer records from S3.
 
**Defensive control:**
- Automated config scanning (e.g., AWS Config, Prowler, Checkov)
- Disable verbose error messages in production
- Principle of least privilege on all cloud storage
```bash
# Check for public S3 buckets (read-only — safe to run)
aws s3api get-bucket-acl --bucket YOUR_BUCKET_NAME
aws s3api get-public-access-block --bucket YOUR_BUCKET_NAME
```
 
---
 
### A03 — Software Supply Chain Failures ⭐ NEW in 2025
 
**What it means:** Compromised dependencies, malicious packages, or CI/CD pipeline attacks that inject bad code into your software.
 
**How it happens:**
- Malicious npm/PyPI packages (typosquatting — e.g., `requets` instead of `requests`)
- Compromised upstream library (you didn't write the bad code — your dependency did)
- CI/CD pipeline with no integrity checks on artifacts
**Real-world example:**
> **SolarWinds Attack (2020):** Attackers compromised SolarWinds' build pipeline and inserted a backdoor into the Orion software update. ~18,000 organizations downloaded the malicious update — including US government agencies.
 
**Defensive control:**
- Pin dependency versions + verify hashes (`pip install --require-hashes`)
- Use Software Bill of Materials (SBOM) to track all dependencies
- Sign CI/CD artifacts and verify signatures before deploying
```bash
# Generate a requirements.txt with hashes (Python)
pip-compile --generate-hashes requirements.in
 
# Check for known vulnerabilities in dependencies
pip install safety
safety check
```
 
---
 
### A04 — Cryptographic Failures
 
**What it means:** Weak, missing, or incorrectly implemented encryption — leading to exposure of sensitive data.
 
**How it happens:**
- Passwords stored as MD5 or SHA1 hashes (these are broken — too fast to brute force)
- Sensitive data transmitted over HTTP instead of HTTPS
- Hardcoded API keys or secrets in source code
- Using ECB mode for block ciphers (deterministic — patterns leak)
**Real-world example:**
> **RockYou Breach (2009):** RockYou stored 32 million user passwords in **plaintext** — no hashing at all. The resulting wordlist (`rockyou.txt`) is still the #1 password cracking dictionary used in CTFs today.
 
**Defensive control:**
- Use **bcrypt**, **scrypt**, or **Argon2** for password hashing (slow by design)
- Never store secrets in code — use environment variables or a secrets manager (AWS Secrets Manager, HashiCorp Vault)
- Enforce TLS 1.2+ everywhere
```python
# BAD — MD5 is not suitable for passwords
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()
 
# GOOD — bcrypt adds salt + is computationally slow
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
```
 
---
 
### A05 — Injection
 
**What it means:** Untrusted data is sent to an interpreter (SQL, shell, LDAP, etc.) and executed as a command.
 
**Sub-types:**
| Type | Example |
|------|---------|
| SQL Injection | `' OR 1=1 --` in a login field |
| XSS (Cross-Site Scripting) | `<script>document.cookie</script>` in a comment field |
| Command Injection | `; rm -rf /` appended to a filename input |
| LDAP Injection | Manipulating LDAP queries for auth bypass |
 
**Real-world example:**
> **Heartland Payment Systems (2008):** SQL injection on a web form gave attackers access to 130 million credit card numbers. It was the largest data breach in US history at the time.
 
**Defensive control:**
- **Parameterized queries / prepared statements** — never concatenate user input into SQL
- Input validation + output encoding
- WAF (Web Application Firewall) as a defense-in-depth layer
```python
# BAD — string concatenation = SQL injection risk
query = f"SELECT * FROM users WHERE username='{username}'"
 
# GOOD — parameterized query (user input never interpreted as SQL)
cursor.execute("SELECT * FROM users WHERE username=?", (username,))
```
 
---
 
### A06 — Insecure Design
 
**What it means:** Flaws baked into the architecture or business logic — security wasn't considered during design, not just implementation.
 
**How it happens:**
- No threat modeling done during design phase
- Business logic flaws (e.g., "buy 1 item, enter quantity -1 to get a refund while keeping the item")
- Missing rate limiting on sensitive endpoints (e.g., password reset)
**Real-world example:**
> **Instagram Account Takeover (2019):** The password reset flow sent a 6-digit code via SMS but had no rate limiting on guesses. A researcher could brute-force all 1,000,000 combinations within minutes.
 
**Defensive control:**
- **Threat modeling** at design time (STRIDE framework: Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation of Privilege)
- Rate limiting + account lockout on all auth flows
- Review business logic flows for abuse cases
---
 
### A07 — Authentication Failures
 
**What it means:** Weaknesses in how identity is verified — broken login, session, or credential management.
 
**How it happens:**
- Weak/default passwords allowed
- No MFA on privileged accounts
- Session tokens that don't expire or are predictable
- Credentials exposed in URLs or logs
**Real-world example:**
> **Zoom Account Takeover (2020):** Credential stuffing attack — attackers took username/password combos leaked from other breaches and tried them on Zoom. 500,000 Zoom accounts were sold on the dark web because users reused passwords.
 
**Defensive control:**
- Enforce MFA (especially for admin/privileged accounts)
- Use secure, random session tokens — invalidate on logout
- Implement brute-force protection (lockout + CAPTCHA)
---
 
### A08 — Software and Data Integrity Failures
 
**What it means:** Code or data updates are applied without verifying they haven't been tampered with.
 
**How it happens:**
- Auto-update mechanisms that don't verify signatures
- Insecure deserialization — attacker sends a crafted serialized object that executes code when deserialized
- Using plugins/libraries from untrusted CDNs without Subresource Integrity (SRI) checks
**Real-world example:**
> **ASUS Live Update Attack (2019, "Operation ShadowHammer"):** Attackers compromised ASUS's official software update server and pushed a backdoored update — signed with legitimate ASUS certificates — to ~1 million machines.
 
**Defensive control:**
- Verify digital signatures on all software updates
- Avoid deserializing untrusted data — use safe formats (JSON) over binary serialization (pickle in Python)
- Use SRI hashes for external scripts
```html
<!-- SRI check — browser verifies the script hash before running it -->
<script src="https://cdn.example.com/lib.js"
        integrity="sha384-abc123..."
        crossorigin="anonymous"></script>
```
 
---
 
### A09 — Security Logging & Alerting Failures
 
**What it means:** Systems log without alerting, or don't log enough detail — breaches go undetected for months/years.
 
**How it happens:**
- Login failures not logged
- Logs exist but no one monitors them / no alerts configured
- Logs stored on the same system that was compromised (attacker deletes them)
- PII or credentials accidentally written to logs
**Real-world example:**
> **Equifax Breach (2017):** Attackers had access for **78 days** before detection. The breach of 147 million records went unnoticed partly because an SSL inspection certificate had expired — decrypted traffic containing the intrusion was no longer being inspected or alerted on.
 
**Defensive control:**
- Centralized logging (ship logs to a SIEM — e.g., Splunk, AWS CloudWatch, ELK Stack)
- Alert on anomalies: repeated login failures, unusual data exports, privilege escalations
- Store logs in write-once, tamper-evident storage
```bash
# AWS CloudTrail — always-on audit log of API calls (read-only check)
aws cloudtrail describe-trails
aws cloudtrail get-trail-status --name YOUR_TRAIL_NAME
```
 
---
 
### A10 — Mishandling of Exceptional Conditions ⭐ NEW in 2025
 
**What it means:** Error states and edge cases that cause the system to leak data, crash insecurely, or "fail open" (grant access when it should deny).
 
**How it happens:**
- Unhandled exceptions that display stack traces (leaking internal paths, library versions, DB schema)
- "Fail open" logic — if auth check throws an exception, code falls through to grant access
- Integer overflows / divide-by-zero causing unexpected behavior
**Real-world example:**
> **Gitlab "Fail Open" Bug (2023):** A SAML authentication library exception caused GitLab's auth handler to fail open — any unauthenticated user could sign in as any account by triggering the error condition.
 
**Defensive control:**
- **Always fail closed** — if something goes wrong, deny access by default
- Catch exceptions explicitly; return generic error messages to users, log details server-side
- Test error paths, not just happy paths
```python
# BAD — fails open if auth check throws an exception
try:
    is_admin = check_admin_permission(user)
except:
    pass  # silently continues — user proceeds as if authorized!
 
# GOOD — fails closed
try:
    is_admin = check_admin_permission(user)
except Exception as e:
    logger.error(f"Auth check failed: {e}")
    return 403  # deny access on any error
```
 
---
 
## 3.0 — Quick Reference Table
 
| # | Category | One-Line Description | Key Defense |
|---|----------|---------------------|-------------|
| A01 | Broken Access Control | Users exceed their permissions | Server-side authz on every request |
| A02 | Security Misconfiguration | Default/insecure settings left in place | Automated config scanning |
| A03 | Supply Chain Failures | Malicious dependencies / compromised pipeline | Pin deps + verify hashes + SBOM |
| A04 | Cryptographic Failures | Weak/missing encryption, hardcoded keys | bcrypt for passwords, secrets manager |
| A05 | Injection | User input executed as a command | Parameterized queries, input validation |
| A06 | Insecure Design | Security flaws in architecture/logic | Threat modeling (STRIDE) |
| A07 | Authentication Failures | Weak login, session, credential management | MFA + secure sessions |
| A08 | Data Integrity Failures | Unverified updates, insecure deserialization | Signature verification, avoid pickle |
| A09 | Logging & Alerting Failures | Breaches go undetected | SIEM + anomaly alerts |
| A10 | Exceptional Conditions | Errors leak data or fail open | Fail closed + catch all exceptions |
 
---
 
## 4.0 — OWASP in a DevSecOps Pipeline
 
```
Developer writes code
        │
        ▼
   [SAST scan]  ←── Static analysis catches A05 (Injection), A04 (hardcoded keys)
        │
        ▼
   [SCA scan]   ←── Dependency check catches A03 (Supply Chain), A04 (known vuln libs)
        │
        ▼
  [Code Review] ←── Human review catches A06 (Insecure Design), A07 (Auth logic)
        │
        ▼
   [DAST scan]  ←── Dynamic testing catches A01 (Access Control), A02 (Misconfig)
        │
        ▼
  [Production]  ←── Monitoring catches A09 (Logging failures), A10 (Error leaks)
```
 
**Tools map:**
| Stage | Tool | OWASP coverage |
|-------|------|----------------|
| SAST | Semgrep, Bandit (Python) | A05, A04 |
| SCA | `safety`, Dependabot, Snyk | A03, A04 |
| DAST | OWASP ZAP, Burp Suite | A01, A02, A05 |
| Secrets | truffleHog, git-secrets | A04 |
| IaC scan | Checkov, Prowler | A02 |
| Monitoring | CloudWatch, Splunk | A09 |
 
---
 
## 5.0 — Hands-On Practice
 
### Task 1: Map a breach to OWASP
 
Pick any breach below and identify which OWASP categories apply:
- Uber breach (2022) — hint: A02, A07, A09
- Log4Shell (2021) — hint: A03, A05, A08
- Twitter Bitcoin scam (2020) — hint: A07, A06
### Task 2: TryHackMe — Cyber Security 101
 
Continue the **Web Fundamentals** module on TryHackMe.
Focus rooms that map to today's content:
- **OWASP Top 10** room (direct practice for every category)
- **SQL Injection** room → A05
- **File Inclusion** room → A01, A05
### Task 3: Scan your own code
 
If you have any Python scripts from Days 15–17, run:
```bash
# Install Bandit (Python SAST tool)
pip install bandit
 
# Scan a file
bandit -r your_script.py
 
# Scan a whole directory
bandit -r ./4.Python/
```
 
---
 
## 6.0 — Key Terms Glossary
 
| Term | Meaning |
|------|---------|
| OWASP | Open Web Application Security Project |
| IDOR | Insecure Direct Object Reference — accessing someone else's resource by changing an ID |
| SSRF | Server-Side Request Forgery — making the server fetch internal resources |
| SAST | Static Application Security Testing — scanning source code |
| DAST | Dynamic Application Security Testing — testing a running app |
| SCA | Software Composition Analysis — checking dependencies for vulnerabilities |
| SBOM | Software Bill of Materials — inventory of all components in your software |
| SIEM | Security Information and Event Management — centralized log + alert system |
| Fail Open | Granting access when an error occurs (BAD) |
| Fail Closed | Denying access when an error occurs (GOOD) |
| STRIDE | Threat modeling framework: Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation |
| Credential Stuffing | Using leaked username/password combos from one breach to attack other services |
 
---
 
*Day 18 complete ✅ | Next: Day 19 — IAM Deep Dive / Python OOP*