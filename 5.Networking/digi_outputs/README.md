# 📂 dig_outputs — DNS Query Log

> Paste your real `dig` outputs here as you practice.
> Reading actual output is 10x better than reading diagrams.
> Format: date, command, output, and what you noticed.

---

## How to Save Your dig Output

```bash
# Print to terminal AND save to file
dig example.com +trace | tee day16_example_trace.txt

# Save directly to file
dig example.com > day16_example_basic.txt

# Save with timestamp in filename
dig example.com +trace > "$(date +%Y-%m-%d)_example_trace.txt"
```

---

## Template — Paste Your Outputs Below

```
═══════════════════════════════════════════════════════════
DATE    : YYYY-MM-DD
COMMAND : dig example.com +trace
PURPOSE : Learning the full DNS resolution chain
═══════════════════════════════════════════════════════════

[PASTE OUTPUT HERE]

WHAT I NOTICED:
-
-
-

QUESTIONS THIS RAISED:
-
═══════════════════════════════════════════════════════════
```

---

## Sample Output — What to Expect

> This is what `dig google.com +trace` typically looks like.
> Your actual IPs and times will differ.

```
; <<>> DiG 9.18.x <<>> google.com +trace
;; global options: +cmd

.                       518400  IN  NS  a.root-servers.net.   ← ROOT servers
.                       518400  IN  NS  b.root-servers.net.
...

com.                    172800  IN  NS  a.gtld-servers.net.   ← .COM TLD servers
com.                    172800  IN  NS  b.gtld-servers.net.
...
;; Received 1169 bytes from 192.5.5.241#53(f.root-servers.net) in 12 ms
                                                               ↑
                                                               which root server answered

google.com.             172800  IN  NS  ns1.google.com.       ← Google's own nameservers
google.com.             172800  IN  NS  ns2.google.com.
;; Received 292 bytes from 192.41.162.30#53(f.gtld-servers.net) in 8 ms
                                                               ↑
                                                               which TLD server answered

google.com.             300     IN  A   142.250.190.14        ← THE ACTUAL ANSWER
;; Received 55 bytes from 216.239.32.10#53(ns1.google.com) in 2 ms
                                                               ↑
                                                               Google's authoritative server
```

### Annotated Breakdown

```
google.com.    300    IN    A    142.250.190.14
│              │      │     │    └── IP address of google.com
│              │      │     └── Record type (A = IPv4)
│              │      └── Class (IN = Internet, always this)
│              └── TTL in seconds (300s = 5 minutes cache time)
└── Domain queried (trailing dot = root of DNS tree)
```

---

## My dig Outputs — Day 16

### Output 1 — Basic Lookup

```
DATE    : 2024-__-__
COMMAND : dig example.com
═══════════════════════════════════════════════════════════

[PASTE HERE]

═══════════════════════════════════════════════════════════
WHAT I NOTICED:
- TTL was ___ seconds
- IP was ___
- Query time was ___ ms
```

---

### Output 2 — Full Trace (+trace)

```
DATE    : 2024-__-__
COMMAND : dig example.com +trace
═══════════════════════════════════════════════════════════

[PASTE HERE]

═══════════════════════════════════════════════════════════
WHAT I NOTICED:
- Root server that answered: ___
- TLD server that answered:  ___
- Authoritative server:      ___
- Total hops to get answer:  ___
```

---

### Output 3 — MX Records

```
DATE    : 2024-__-__
COMMAND : dig example.com MX
═══════════════════════════════════════════════════════════

[PASTE HERE]

═══════════════════════════════════════════════════════════
WHAT I NOTICED:
- Mail servers listed: ___
- Priority numbers:    ___
```

---

### Output 4 — TXT Records

```
DATE    : 2024-__-__
COMMAND : dig example.com TXT
═══════════════════════════════════════════════════════════

[PASTE HERE]

═══════════════════════════════════════════════════════════
WHAT I NOTICED:
- SPF record present: YES / NO
- DKIM record present: YES / NO
- Any other interesting records: ___
```

---

### Output 5 — Reverse DNS

```
DATE    : 2024-__-__
COMMAND : dig -x [IP ADDRESS]
═══════════════════════════════════════════════════════════

[PASTE HERE]

═══════════════════════════════════════════════════════════
WHAT I NOTICED:
-
```

---

### Output 6 — Using Different DNS Servers

```
DATE    : 2024-__-__
COMMAND : dig @8.8.8.8 example.com vs dig @1.1.1.1 example.com
═══════════════════════════════════════════════════════════

Google DNS (8.8.8.8) result:
[PASTE HERE]

Cloudflare DNS (1.1.1.1) result:
[PASTE HERE]

═══════════════════════════════════════════════════════════
DIFFERENCE OBSERVED:
- Query time difference: ___
- Same IP returned: YES / NO
- Any other differences: ___
```

---

## Interesting Things to Watch For

When studying your dig outputs, ask yourself:

1. **TTL values** — Short TTL (< 60s) = frequent changes expected (load balancers, CDNs). Long TTL (86400 = 1 day) = stable server.

2. **Multiple A records** — Multiple IPs for same domain = load balancing or CDN (e.g., Google returns different IPs each time)

3. **Query time** — Cached queries are < 5ms. Fresh queries go to real servers (20–200ms). Slow DNS = potential issue.

4. **CNAME chains** — `www.example.com → example.com → 93.x.x.x` means two lookups. Too many CNAMEs = slow.

5. **Which root server answered?** — There are 13 root server letter groups (a–m). You'll see different ones each time.

---

*Folder structure suggestion:*
```
5.Networking/
  ├── notes.md
  ├── commands.md
  └── dig_outputs/
        ├── README.md          ← this file
        ├── day16_basic.txt
        ├── day16_trace.txt
        └── day16_mx.txt
```
