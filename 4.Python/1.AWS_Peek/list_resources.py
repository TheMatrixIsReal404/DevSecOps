import boto3

# 1. List all S3 buckets
s3 = boto3.client("s3")
for bucket in s3.list_buckets()["Buckets"]:
    print(bucket["Name"])

# 2. List EC2 instance IDs and states
ec2 = boto3.client("ec2")
for reservation in ec2.describe_instances()["Reservations"]:
    for instance in reservation["Instances"]:
        print(instance["InstanceId"], instance["State"]["Name"])
