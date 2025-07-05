🎓 CloudStart Youth Edition Weekly Challenge
🧠 Title:
“It’s Running... But No One Can See It!”

🗂️ Scenario:
You’ve been given a working Python script that launches an EC2 instance and installs Apache with a welcome page. Everything runs fine — no errors, the instance is running — but when you paste the public IP into the browser, you get nothing.

Your job is to figure out why the server is unreachable on the browser and fix it — just like a real DevOps engineer would in production.

🎯 Objective:
Launch an EC2 instance using the provided Boto3 script.

Visit the public IP in your browser → you’ll get nothing.

Fix the problem using AWS Console or CLI.

Reload the IP in your browser and see:

html
Copy
Edit
Welcome to AWS CloudStart Youth Edition
Submit:

A screenshot of your browser showing the welcome page.

A short write-up explaining:

What went wrong

What you did to fix it

What you learned

🧪 Hidden Issue (Security Group Misconfigured)
Only port 22 (SSH) is opened by default. Port 80 (HTTP) is blocked — so Apache is installed and running, but users can’t access it from the browser.

They will need to:

Identify the problem by checking the Security Group Inbound Rules

Manually add rule for HTTP (port 80) in the AWS Console or CLI

🧾 Boto3 Script (Instructor Provides)
python
Copy
Edit
import boto3

ec2 = boto3.resource('ec2')

instance = ec2.create_instances(
    ImageId='ami-0c02fb55956c7d316',  # Amazon Linux 2
    InstanceType='t2.micro',
    KeyName='linaskeypair',
    MinCount=1,
    MaxCount=1,
    SecurityGroupIds=['sg-001ab1d59b4cfd130'],  # Only port 22 open
    UserData='''#!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Welcome to AWS CloudStart Youth Edition</h1>" > /var/www/html/index.html
    ''',
)

print(f"Launched EC2 instance with ID: {instance[0].id}")
✅ Instructor Note:
You’ve intentionally not opened port 80 in the security group.

Students should discover this by checking instance network settings.

Use this as a way to assess their troubleshooting, cloud awareness, and resource exploration skills.