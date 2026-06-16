# 🔍 aws-peek

A lightweight Python tool to read and inspect your AWS resources using boto3. No writes, no deletes — just a safe way to explore what's running in your cloud.

---

## 📦 What it does

- Lists all **S3 buckets** in your account
- Lists all **EC2 instances** with their IDs and current state

---

## 🗂️ Project Structure

```
day15/
├── venv/                ← virtual environment (never commit this)
├── list_resources.py    ← your script
├── requirements.txt     ← pip freeze output
├── .gitignore           ← keeps venv/ and .env out of git
└── README.md
```

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/your-username/aws-peek.git
cd aws-peek
```

### 2. Create and activate a virtual environment

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure AWS credentials

You can use the AWS CLI:

```bash
aws configure
```

Or create a `.env` file (never commit this):

```
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=us-east-1
```

### 5. Run the script

```bash
python list_resources.py
```

---

## 📋 Example Output

```
my-photos-bucket
my-logs-bucket
i-0abc123def456  running
i-0xyz789ghi012  stopped
```

---

## ⚠️ Safety First

This tool only uses read-only AWS API calls (`list_*` / `describe_*`). It will never create, modify, or delete any cloud resources.

---

## 🛠️ Requirements

- Python 3.8+
- An AWS account with credentials configured
- IAM permissions for `s3:ListAllMyBuckets` and `ec2:DescribeInstances`

---

## 📄 License

MIT
