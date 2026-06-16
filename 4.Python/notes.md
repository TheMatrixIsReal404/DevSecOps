# 📅 Day 15 (Week 3 — Day 1) · Python Scripting & Pointers
## 🔐 DevSecOps — Python Scripting Kickoff & boto3 Basics

> **Today's Goal:** Get comfortable scripting in Python for automation, and make first contact with `boto3` (AWS SDK) for cloud automation.

---

## 📚 Part 0: Python Fundamentals — The Building Blocks

Before jumping into boto3, make sure these Python concepts are rock solid. Everything in cloud automation is built on top of them.

---

### 0.1 — Variables & Data Types

A **variable** is a named container that stores a value. Python is **dynamically typed** — you don't declare the type explicitly; Python figures it out.

```python
# String — text, always in quotes
name = "Alice"
service = 'S3'

# Integer — whole number
port = 443
instance_count = 5

# Float — decimal number
version = 3.11
threshold = 0.85

# Boolean — True or False only (capital T and F in Python)
is_running = True
is_deleted = False

# NoneType — represents "no value" / null
result = None

# Check the type of any variable
print(type(name))    # <class 'str'>
print(type(port))    # <class 'int'>
print(type(True))    # <class 'bool'>
```

#### Variable Naming Rules
```python
# ✅ Valid names
bucket_name = "my-bucket"
totalCount = 5       # camelCase (not preferred in Python)
total_count = 5      # snake_case ← Python convention
_private = "hidden"
AWS_REGION = "us-east-1"   # UPPER_SNAKE for constants

# ❌ Invalid names
# 2fast = "no"       # Can't start with a number
# my-var = "no"      # Hyphens not allowed
# class = "no"       # Reserved keyword
```

---

### 0.2 — Strings — Deep Dive

Strings are one of the most used types in automation scripts.

```python
# Basic string
greeting = "Hello, World!"

# Multi-line string (triple quotes)
message = """
This is line 1
This is line 2
This is line 3
"""

# String concatenation (joining)
first = "AWS"
second = "boto3"
combined = first + " " + second     # "AWS boto3"

# String repetition
line = "-" * 40     # "----------------------------------------"

# f-strings (formatted strings) — most modern and clean way
region = "us-east-1"
service = "S3"
print(f"Connecting to {service} in {region}")
# Output: Connecting to S3 in us-east-1

# f-strings can include expressions
count = 5
print(f"You have {count * 2} items")    # You have 10 items

# Common string methods
text = "  hello world  "

print(text.strip())          # "hello world"   — remove whitespace
print(text.upper())          # "  HELLO WORLD  "
print(text.lower())          # "  hello world  "
print(text.replace("hello", "hi"))   # "  hi world  "
print(text.split())          # ['hello', 'world']

url = "https://api.example.com/v1/resource"
print(url.startswith("https"))   # True
print(url.endswith("resource"))  # True
print("api" in url)              # True (membership check)

# Slicing — extracting part of a string
s = "AKIAIOSFODNN7EXAMPLE"
print(s[0])       # 'A'         — first character
print(s[-1])      # 'E'         — last character
print(s[0:4])     # 'AKIA'      — index 0 to 3
print(s[4:])      # 'IOSFODNN7EXAMPLE'  — from index 4 onwards
print(s[:4])      # 'AKIA'      — from start up to index 4
print(len(s))     # 20          — length of string
```

---

### 0.3 — Numbers & Math

```python
a = 10
b = 3

print(a + b)    # 13  — Addition
print(a - b)    # 7   — Subtraction
print(a * b)    # 30  — Multiplication
print(a / b)    # 3.3333...  — Division (always returns float)
print(a // b)   # 3   — Floor division (integer result)
print(a % b)    # 1   — Modulus (remainder)
print(a ** b)   # 1000  — Exponentiation (10 to the power 3)

# Type conversion
x = "42"
print(int(x) + 1)    # 43 — string to int
print(float(x))      # 42.0 — string to float
print(str(100))      # "100" — int to string

# Useful built-in math functions
print(abs(-5))       # 5   — absolute value
print(round(3.7))    # 4   — round to nearest integer
print(max(1, 5, 3))  # 5
print(min(1, 5, 3))  # 1
```

---

### 0.4 — Booleans & Comparison Operators

```python
x = 10
y = 20

# Comparison operators — always return True or False
print(x == y)   # False — equal to
print(x != y)   # True  — not equal to
print(x > y)    # False — greater than
print(x < y)    # True  — less than
print(x >= 10)  # True  — greater than or equal
print(x <= 10)  # True  — less than or equal

# Logical operators
is_running = True
is_healthy = False

print(is_running and is_healthy)   # False — both must be True
print(is_running or is_healthy)    # True  — at least one must be True
print(not is_running)              # False — inverts the boolean

# Common DevOps use case
status = "running"
region = "us-east-1"

if status == "running" and region == "us-east-1":
    print("Instance is active in primary region")
```

---

### 0.5 — Lists — Ordered Collections

A **list** is an ordered, mutable collection. AWS responses often return lists of resources.

```python
# Creating a list
buckets = ["logs-bucket", "data-bucket", "backup-bucket"]
ports = [22, 80, 443, 8080]
mixed = ["hello", 42, True, None]  # Can mix types

# Accessing elements (zero-indexed)
print(buckets[0])    # "logs-bucket"   — first item
print(buckets[-1])   # "backup-bucket" — last item
print(buckets[1:3])  # ["data-bucket", "backup-bucket"] — slicing

# Length
print(len(buckets))   # 3

# Modifying lists
buckets.append("archive-bucket")      # Add to end
buckets.insert(0, "primary-bucket")   # Insert at index 0
buckets.remove("logs-bucket")         # Remove by value
popped = buckets.pop()                # Remove and return last item
buckets.pop(0)                        # Remove by index

# Checking membership
print("data-bucket" in buckets)       # True or False

# Sorting
numbers = [3, 1, 4, 1, 5, 9]
numbers.sort()                         # Sort in place
print(numbers)                         # [1, 1, 3, 4, 5, 9]
print(sorted(numbers, reverse=True))   # [9, 5, 4, 3, 1, 1]

# List of dicts — very common in boto3 responses
instances = [
    {"id": "i-001", "state": "running"},
    {"id": "i-002", "state": "stopped"},
    {"id": "i-003", "state": "running"},
]

# Count running instances
running = [i for i in instances if i["state"] == "running"]
print(len(running))   # 2
```

---

### 0.6 — Dictionaries — Key-Value Stores

A **dictionary** (dict) is an unordered collection of key-value pairs. This is the most important data structure for working with AWS/API responses — everything comes back as a dict.

```python
# Creating a dictionary
instance = {
    "InstanceId": "i-0abc123",
    "State": "running",
    "Region": "us-east-1",
    "Tags": [{"Key": "Name", "Value": "web-server"}]
}

# Accessing values
print(instance["InstanceId"])    # "i-0abc123"
print(instance["State"])         # "running"

# Safe access with .get() — returns None (or a default) if key doesn't exist
print(instance.get("PublicIP"))              # None
print(instance.get("PublicIP", "no-ip"))     # "no-ip"

# Adding/updating keys
instance["Environment"] = "production"
instance["State"] = "stopped"           # Update existing key

# Deleting a key
del instance["Region"]

# Checking if key exists
if "State" in instance:
    print("State key exists")

# Looping over a dict
for key, value in instance.items():
    print(f"{key}: {value}")

# Useful dict methods
print(instance.keys())     # All keys
print(instance.values())   # All values
print(instance.items())    # All key-value pairs as tuples

# Nested dictionary — very common with AWS
response = {
    "Reservations": [
        {
            "Instances": [
                {
                    "InstanceId": "i-0abc",
                    "State": {"Name": "running", "Code": 16},
                    "Tags": [{"Key": "Name", "Value": "prod-server"}]
                }
            ]
        }
    ]
}

# Deep access
instance_id = response["Reservations"][0]["Instances"][0]["InstanceId"]
state       = response["Reservations"][0]["Instances"][0]["State"]["Name"]
print(instance_id, state)   # i-0abc running
```

---

### 0.7 — Tuples & Sets

```python
# Tuple — ordered, IMMUTABLE (cannot be changed after creation)
coordinates = (40.7128, -74.0060)    # lat, lon
aws_regions  = ("us-east-1", "us-west-2", "eu-west-1")

print(coordinates[0])    # 40.7128
# coordinates[0] = 999   # ❌ TypeError — tuples are immutable

# Common use: returning multiple values from a function
def get_credentials():
    return "AKIA...", "wJalr..."   # returns a tuple

access_key, secret_key = get_credentials()   # tuple unpacking

# Set — unordered collection of UNIQUE values
regions_visited = {"us-east-1", "us-west-2", "us-east-1"}
print(regions_visited)   # {'us-east-1', 'us-west-2'}  — duplicates removed

# Set operations
a = {"us-east-1", "us-west-2"}
b = {"us-west-2", "eu-west-1"}

print(a | b)    # Union:        {'us-east-1', 'us-west-2', 'eu-west-1'}
print(a & b)    # Intersection: {'us-west-2'}
print(a - b)    # Difference:   {'us-east-1'}
```

---

### 0.8 — Conditional Statements (`if / elif / else`)

```python
# Basic if-else
status = "running"

if status == "running":
    print("Instance is active")
else:
    print("Instance is not running")

# if-elif-else chain
http_code = 403

if http_code == 200:
    print("OK")
elif http_code == 401:
    print("Unauthorized")
elif http_code == 403:
    print("Forbidden")
elif http_code == 404:
    print("Not Found")
else:
    print(f"Unknown code: {http_code}")

# One-liner (ternary) — use sparingly
label = "active" if status == "running" else "inactive"

# Nested conditions
region = "us-east-1"
is_prod = True

if region == "us-east-1":
    if is_prod:
        print("Production - US East")
    else:
        print("Dev/Staging - US East")

# Combining conditions with and / or
age = 25
has_permission = True

if age >= 18 and has_permission:
    print("Access granted")

# Checking multiple values with `in`
safe_regions = ["us-east-1", "us-west-2", "eu-west-1"]
current_region = "ap-southeast-1"

if current_region not in safe_regions:
    print(f"Warning: deploying to non-standard region {current_region}")
```

---

### 0.9 — Loops

#### `for` Loop

```python
# Iterate over a list
buckets = ["logs", "data", "backups"]

for bucket in buckets:
    print(f"Processing bucket: {bucket}")

# Iterate with index using enumerate()
for index, bucket in enumerate(buckets):
    print(f"{index}: {bucket}")
# 0: logs
# 1: data
# 2: backups

# Iterate over a range of numbers
for i in range(5):
    print(i)         # 0, 1, 2, 3, 4

for i in range(1, 6):
    print(i)         # 1, 2, 3, 4, 5

for i in range(0, 10, 2):
    print(i)         # 0, 2, 4, 6, 8  (step of 2)

# Iterate over a dict
config = {"region": "us-east-1", "timeout": 30, "retries": 3}

for key in config:
    print(key)                       # prints keys

for value in config.values():
    print(value)                     # prints values

for key, value in config.items():
    print(f"{key} = {value}")        # prints key-value pairs

# Nested loop — common with AWS nested responses
reservations = [
    {"Instances": [{"Id": "i-001"}, {"Id": "i-002"}]},
    {"Instances": [{"Id": "i-003"}]},
]

for reservation in reservations:
    for instance in reservation["Instances"]:
        print(instance["Id"])
# i-001
# i-002
# i-003
```

#### `while` Loop

```python
# Runs as long as the condition is True
count = 0

while count < 5:
    print(f"Count: {count}")
    count += 1    # ← CRITICAL: always update the variable or you'll get infinite loop

# Loop control keywords
for i in range(10):
    if i == 3:
        continue    # Skip this iteration, go to next
    if i == 7:
        break       # Exit the loop entirely
    print(i)
# 0, 1, 2, 4, 5, 6

# Polling pattern (very common in DevOps)
import time

status = "pending"
attempts = 0
max_attempts = 10

while status != "running" and attempts < max_attempts:
    print(f"Waiting... attempt {attempts + 1}")
    time.sleep(5)           # Wait 5 seconds
    # status = check_instance_status()   # Would call real API
    attempts += 1
```

#### List Comprehensions — Pythonic Shorthand

```python
# Traditional way
running = []
for instance in instances:
    if instance["state"] == "running":
        running.append(instance)

# Pythonic one-liner using list comprehension
running = [i for i in instances if i["state"] == "running"]

# Transform items
bucket_names = [b["Name"] for b in buckets_response]

# With multiple conditions
prod_running = [
    i["id"] for i in instances
    if i["state"] == "running" and i["env"] == "prod"
]
```

---

### 0.10 — Functions

A **function** is a reusable block of code. In DevSecOps scripts, you'll wrap every action in a function to keep scripts clean, testable, and DRY (Don't Repeat Yourself).

```python
# Basic function definition
def greet():
    print("Hello!")

greet()    # Call the function

# Function with parameters
def greet_user(name):
    print(f"Hello, {name}!")

greet_user("Alice")

# Function with return value
def add(a, b):
    return a + b

result = add(3, 5)
print(result)   # 8

# Function with default parameter
def connect_to_aws(region="us-east-1", timeout=30):
    print(f"Connecting to {region} with {timeout}s timeout")

connect_to_aws()                          # uses defaults
connect_to_aws("eu-west-1")               # overrides region only
connect_to_aws("ap-southeast-1", 60)      # overrides both
connect_to_aws(timeout=10)                # keyword argument

# Function with *args — accept any number of positional arguments
def list_services(*services):
    for service in services:
        print(f"- {service}")

list_services("S3", "EC2", "IAM", "Lambda")

# Function with **kwargs — accept any number of keyword arguments
def create_tag(**kwargs):
    for key, value in kwargs.items():
        print(f"Tag: {key}={value}")

create_tag(Name="web-server", Env="prod", Owner="devops-team")

# Returning multiple values
def get_instance_info(instance_id):
    # In real code, this would call boto3
    return "running", "us-east-1", "t3.micro"

state, region, instance_type = get_instance_info("i-001")
print(state, region, instance_type)

# Practical DevSecOps function
def list_buckets(client):
    """
    Returns a list of S3 bucket names.
    Args:
        client: A boto3 S3 client
    Returns:
        list: List of bucket name strings
    """
    response = client.list_buckets()
    return [b["Name"] for b in response["Buckets"]]
```

---

### 0.11 — Scope — Where Variables Live

```python
# Global variable — accessible everywhere
AWS_REGION = "us-east-1"

def my_function():
    # Local variable — only inside this function
    local_var = "I'm local"
    print(AWS_REGION)     # ✅ Can access global
    print(local_var)      # ✅ Accessible here

my_function()
# print(local_var)        # ❌ NameError — doesn't exist outside the function

# Modifying a global variable inside a function
count = 0

def increment():
    global count        # declare intent to modify global
    count += 1

increment()
print(count)    # 1
```

---

### 0.12 — Error Handling (`try / except / finally`)

In automation scripts, failures **will** happen — network issues, wrong permissions, missing keys. Always handle errors gracefully.

```python
# Basic try-except
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")

# Multiple exception types
try:
    value = int("not-a-number")
except ValueError as e:
    print(f"Value error: {e}")
except TypeError as e:
    print(f"Type error: {e}")

# Catch any exception (use sparingly)
try:
    risky_operation()
except Exception as e:
    print(f"Something went wrong: {e}")

# finally — always runs, used for cleanup
file = None
try:
    file = open("config.json", "r")
    data = file.read()
except FileNotFoundError:
    print("File not found!")
finally:
    if file:
        file.close()    # always close the file

# else — runs only if NO exception occurred
try:
    response = requests.get("https://api.example.com")
except Exception as e:
    print(f"Request failed: {e}")
else:
    print(f"Success: {response.status_code}")

# Raise your own exceptions
def validate_region(region):
    valid_regions = ["us-east-1", "us-west-2", "eu-west-1"]
    if region not in valid_regions:
        raise ValueError(f"Invalid region: {region}")
    return True

# boto3 specific error handling with botocore
import boto3
import botocore

def safe_list_buckets():
    client = boto3.client("s3")
    try:
        response = client.list_buckets()
        return response["Buckets"]
    except botocore.exceptions.NoCredentialsError:
        print("AWS credentials not configured. Run: aws configure")
    except botocore.exceptions.ClientError as e:
        error_code = e.response["Error"]["Code"]
        print(f"AWS error {error_code}: {e}")
    return []
```

---

### 0.13 — Modules & Imports

A **module** is a Python file with reusable code. Python's standard library and third-party packages are all modules.

```python
# Import an entire module
import os
import sys
import json
import time

# Import specific names from a module
from datetime import datetime, timedelta
from pathlib import Path

# Import with alias
import boto3
import requests as req

# Usage examples
# os — Operating system interface
current_dir = os.getcwd()
home_dir    = os.path.expanduser("~")
env_var     = os.environ.get("AWS_PROFILE", "default")
os.makedirs("logs/output", exist_ok=True)   # create directories

# json — Encoding and decoding JSON
data = {"name": "bucket", "region": "us-east-1"}
json_string = json.dumps(data, indent=2)    # dict → JSON string
print(json_string)

parsed = json.loads('{"key": "value"}')     # JSON string → dict

# Write JSON to file
with open("output.json", "w") as f:
    json.dump(data, f, indent=2)

# Read JSON from file
with open("output.json", "r") as f:
    loaded = json.load(f)

# datetime — working with timestamps
now = datetime.now()
print(now.strftime("%Y-%m-%d %H:%M:%S"))   # 2024-01-15 10:30:45

one_week_ago = now - timedelta(days=7)
print(one_week_ago.date())

# sys — system-level operations
print(sys.version)          # Python version
sys.exit(1)                 # Exit with error code 1
```

---

### 0.14 — File Handling

```python
# Writing to a file
with open("report.txt", "w") as f:     # "w" = write (overwrites)
    f.write("Instance Report\n")
    f.write("=" * 40 + "\n")

# Appending to a file
with open("report.txt", "a") as f:     # "a" = append
    f.write("New line added\n")

# Reading from a file
with open("report.txt", "r") as f:     # "r" = read (default)
    content = f.read()                  # entire file as string
    print(content)

with open("report.txt", "r") as f:
    lines = f.readlines()              # list of lines
    for line in lines:
        print(line.strip())

# The `with` block automatically closes the file — always use it

# Working with JSON files (very common in DevOps)
import json

# Write config to JSON file
config = {
    "region": "us-east-1",
    "services": ["s3", "ec2", "iam"],
    "dry_run": True
}

with open("config.json", "w") as f:
    json.dump(config, f, indent=2)

# Read back
with open("config.json", "r") as f:
    loaded_config = json.load(f)

print(loaded_config["region"])   # "us-east-1"
```

---

### 0.15 — Lambda Functions (Anonymous Functions)

```python
# Regular function
def double(x):
    return x * 2

# Lambda — same thing, one line
double = lambda x: x * 2

print(double(5))   # 10

# Most common use: sorting
instances = [
    {"id": "i-001", "launch_time": "2024-01-03"},
    {"id": "i-002", "launch_time": "2024-01-01"},
    {"id": "i-003", "launch_time": "2024-01-02"},
]

# Sort by launch_time
sorted_instances = sorted(instances, key=lambda i: i["launch_time"])

# Filter using lambda
import boto3
running = list(filter(lambda i: i["state"] == "running", instances))
```

---

### 0.16 — List/Dict Comprehensions — Advanced Patterns

```python
instances = [
    {"id": "i-001", "state": "running",  "type": "t3.micro"},
    {"id": "i-002", "state": "stopped",  "type": "t3.small"},
    {"id": "i-003", "state": "running",  "type": "t3.micro"},
]

# List comprehension — get all running instance IDs
running_ids = [i["id"] for i in instances if i["state"] == "running"]
# ["i-001", "i-003"]

# Dict comprehension — build a lookup map {id: state}
id_to_state = {i["id"]: i["state"] for i in instances}
# {"i-001": "running", "i-002": "stopped", "i-003": "running"}

# Nested comprehension
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

---

### 0.17 — The `if __name__ == "__main__"` Pattern

Every well-written Python script uses this. It ensures code only runs when the file is executed directly (not when it's imported by another script).

```python
# my_script.py

import boto3

def list_s3_buckets():
    client = boto3.client("s3")
    response = client.list_buckets()
    for bucket in response["Buckets"]:
        print(bucket["Name"])

def describe_ec2_instances():
    client = boto3.client("ec2")
    response = client.describe_instances()
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            print(instance["InstanceId"], instance["State"]["Name"])

# This block only runs when you execute: python my_script.py
# If another file does `import my_script`, this block is SKIPPED
if __name__ == "__main__":
    print("=== S3 Buckets ===")
    list_s3_buckets()
    print("\n=== EC2 Instances ===")
    describe_ec2_instances()
```

---

## 📚 Part 1: Python Environment Hygiene

### What is a Virtual Environment?
A **virtual environment** (`venv`) is an isolated Python workspace. It keeps project dependencies separate so different projects don't conflict with each other.

Think of it like a clean room — everything installed inside stays inside.

### Why it matters in DevSecOps:
- Keeps your system Python clean
- Makes projects reproducible (`requirements.txt`)
- Avoids version conflicts between tools

### Key Commands

```bash
# Step 1: Create a virtual environment
python -m venv venv

# Step 2: Activate it (Linux/Mac)
source venv/bin/activate

# Step 3: You'll see (venv) in your terminal — you're now inside

# Step 4: Install packages
pip install boto3 requests pyyaml

# Step 5: Freeze installed packages to a file
pip freeze > requirements.txt

# Step 6: Deactivate when done
deactivate
```

### What is `requirements.txt`?
A text file listing all packages your project needs. Anyone can recreate your environment with:
```bash
pip install -r requirements.txt
```

---

## 📚 Part 2: The `requests` Library

### What is it?
`requests` is a Python library for making HTTP calls — GET, POST, DELETE, etc. It's the standard way to talk to REST APIs from Python.

### GET Request (Fetch data)
```python
import requests

response = requests.get("https://api.github.com")

print(response.status_code)   # 200 = OK
print(response.json())        # Parse JSON response body
```

### POST Request (Send data)
```python
import requests

payload = {"username": "devuser", "action": "login"}
headers = {"Content-Type": "application/json"}

response = requests.post(
    "https://example.com/api/login",
    json=payload,
    headers=headers
)

print(response.status_code)
print(response.text)
```

### Key Concepts

| Term | What it means |
|------|--------------|
| `status_code` | HTTP response code (200=OK, 404=Not Found, 403=Forbidden) |
| `response.json()` | Parse response body as JSON (returns Python dict) |
| `response.text` | Raw response as string |
| `headers` | Metadata sent with the request (auth tokens, content type) |
| `params` | Query string parameters e.g. `?region=us-east-1` |

### Query Params Example
```python
params = {"region": "us-east-1", "limit": 10}
response = requests.get("https://api.example.com/resources", params=params)
# Becomes: https://api.example.com/resources?region=us-east-1&limit=10
```

---

## 📚 Part 3: boto3 Setup — AWS SDK for Python

### What is boto3?
`boto3` is Amazon's official Python library to interact with AWS services — S3, EC2, IAM, Lambda, and more. It's your automation gateway into AWS.

### Setting Up AWS Credentials
Before boto3 can talk to AWS, it needs your credentials. **Never hardcode keys in scripts!**

```bash
# AWS CLI stores credentials here:
~/.aws/credentials
```

The file looks like this:
```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region = us-east-1
```

Configure it with:
```bash
aws configure
```

> ⚠️ **Security Rule:** Always use a **free-tier sandbox account** for practice. Never use real production credentials in scripts or commit them to git.

### Two Ways to Use boto3

#### 1. `client` — Low-level, raw API responses
```python
import boto3

s3 = boto3.client("s3")
# Returns raw JSON-style dicts
buckets = s3.list_buckets()
```

#### 2. `resource` — Higher-level, object-oriented
```python
import boto3

s3 = boto3.resource("s3")
# Returns Python objects with attributes/methods
for bucket in s3.buckets.all():
    print(bucket.name)
```

**For beginners:** Start with `client` — you see exactly what AWS returns and it matches AWS documentation.

---

## 📚 Part 4: Read-Only AWS Calls (Safety First!)

### The Golden Rule for Week 3
> Only use `list_*` and `describe_*` calls this week.
> **Never** use `create_*`, `delete_*`, or `terminate_*` until you fully understand what you're doing.

### Why?
- `describe_instances()` — harmless, just reads data
- `terminate_instances()` — shuts down servers permanently

One typo in a delete call on a real account = production outage.

### Safe Operations to Practice
| Service | Safe Call | What it does |
|---------|-----------|-------------|
| S3 | `list_buckets()` | List all your S3 buckets |
| EC2 | `describe_instances()` | List EC2 instances and their state |
| IAM | `list_users()` | List IAM users |
| S3 | `list_objects_v2()` | List files in a bucket |

---

## 📚 Part 5: Python Concepts Used in Scripts

### Loops
```python
# for loop — iterate over a list
for bucket in buckets:
    print(bucket["Name"])
```

### Nested Loops
AWS responses are often nested JSON. EC2 `describe_instances` returns:
```
Reservations → each has → Instances → each has → InstanceId, State, Tags
```

So you need a loop inside a loop:
```python
for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
        print(instance["InstanceId"])
```

### Dictionary Access
```python
data = {"Name": "my-bucket", "CreationDate": "2024-01-01"}

# Access a key
print(data["Name"])          # my-bucket

# Safe access with default
print(data.get("Region", "unknown"))  # unknown (key doesn't exist)
```

### f-strings (Formatted Strings)
```python
name = "my-bucket"
state = "running"
print(f"Bucket: {name}")
print(f"Instance is {state}")
```

---

## 📚 Part 6: Putting It All Together — Real Scripts

### Complete Script: List S3 Buckets Safely

```python
import boto3
import botocore
from datetime import datetime

def get_s3_client(region="us-east-1"):
    """Create and return a boto3 S3 client."""
    return boto3.client("s3", region_name=region)

def list_all_buckets(client):
    """
    List all S3 buckets in the account.
    Returns a list of bucket dicts with Name and CreationDate.
    """
    try:
        response = client.list_buckets()
        return response.get("Buckets", [])
    except botocore.exceptions.NoCredentialsError:
        print("❌ No AWS credentials found. Run: aws configure")
        return []
    except botocore.exceptions.ClientError as e:
        print(f"❌ AWS error: {e}")
        return []

def format_bucket_report(buckets):
    """Format bucket list into a readable report string."""
    if not buckets:
        return "No buckets found."

    lines = [f"{'Bucket Name':<40} {'Created':<25}"]
    lines.append("-" * 65)

    for bucket in buckets:
        name    = bucket["Name"]
        created = bucket["CreationDate"].strftime("%Y-%m-%d %H:%M UTC")
        lines.append(f"{name:<40} {created:<25}")

    lines.append(f"\nTotal: {len(buckets)} bucket(s)")
    return "\n".join(lines)

if __name__ == "__main__":
    client  = get_s3_client()
    buckets = list_all_buckets(client)
    report  = format_bucket_report(buckets)
    print(report)
```

### Complete Script: Describe EC2 Instances

```python
import boto3
import botocore

def get_instance_name(tags):
    """Extract the 'Name' tag value from a list of AWS tags."""
    if not tags:
        return "Unnamed"
    for tag in tags:
        if tag["Key"] == "Name":
            return tag["Value"]
    return "Unnamed"

def describe_all_instances(region="us-east-1"):
    """Return a flat list of instance info dicts from EC2."""
    client = boto3.client("ec2", region_name=region)
    instances = []

    try:
        response = client.describe_instances()

        for reservation in response["Reservations"]:
            for inst in reservation["Instances"]:
                instances.append({
                    "id":    inst["InstanceId"],
                    "state": inst["State"]["Name"],
                    "type":  inst.get("InstanceType", "unknown"),
                    "name":  get_instance_name(inst.get("Tags", [])),
                    "az":    inst.get("Placement", {}).get("AvailabilityZone", "unknown"),
                })

    except botocore.exceptions.ClientError as e:
        print(f"Error: {e}")

    return instances

if __name__ == "__main__":
    instances = describe_all_instances()

    if not instances:
        print("No instances found.")
    else:
        print(f"{'ID':<20} {'Name':<20} {'State':<12} {'Type':<12} {'AZ'}")
        print("-" * 80)
        for i in instances:
            print(f"{i['id']:<20} {i['name']:<20} {i['state']:<12} {i['type']:<12} {i['az']}")
```

---

## 🔑 Key Takeaways for Day 15

1. **Always use `venv`** — never install globally for projects
2. **`pip freeze > requirements.txt`** — do this before sharing code
3. **AWS credentials go in `~/.aws/credentials`** — never in code
4. **`boto3.client()` vs `boto3.resource()`** — client for raw API, resource for object-oriented
5. **Only `list_*` and `describe_*` this week** — read before you write
6. **AWS responses are nested dicts** — learn to navigate `["Reservations"][0]["Instances"]`
7. **Always wrap boto3 calls in try/except** — handle `ClientError` and `NoCredentialsError`
8. **Use functions to organize every script** — one function per action
9. **f-strings > `.format()` > `+` concatenation** — f-strings are the modern standard
10. **`if __name__ == "__main__":`** — always use this pattern in scripts

---

## 🧠 Quick Reference — Python Cheatsheet

| Concept | Example |
|---------|---------|
| Variable | `name = "Alice"` |
| String f-string | `f"Hello {name}"` |
| List | `items = [1, 2, 3]` |
| Dict | `d = {"key": "value"}` |
| Tuple | `t = (1, 2)` |
| Set | `s = {1, 2, 3}` |
| if/elif/else | `if x > 0: ... elif x == 0: ... else: ...` |
| for loop | `for item in list: ...` |
| while loop | `while condition: ...` |
| List comprehension | `[x for x in list if condition]` |
| Function | `def fn(arg, default=val): return ...` |
| Error handling | `try: ... except ExceptionType as e: ...` |
| File read | `with open("f.txt") as f: data = f.read()` |
| JSON parse | `json.loads(string)` / `json.dumps(dict)` |
| Import | `import boto3` / `from os import path` |

---

## 📝 Checklist Before Ending Day 15

- [ ] Virtual environment created and activated
- [ ] `boto3`, `requests`, `pyyaml` installed
- [ ] `requirements.txt` generated
- [ ] AWS CLI credentials configured (sandbox account only)
- [ ] `list_resources.py` written and tested
- [ ] Udemy Python scripting section started
- [ ] Python fundamentals reviewed: variables, strings, lists, dicts, loops, functions, error handling
- [ ] Practice: write a script that uses at least one function, one loop, and one try/except
