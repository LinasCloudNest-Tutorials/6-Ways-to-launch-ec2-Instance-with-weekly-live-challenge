


Boto3 is the official Python SDK for AWS. It allows you to programmatically interact with AWS services using Python code. That means you can launch EC2 instances, upload files to S3, manage IAM users, and much more — all without touching the AWS Console.

With Boto3, you can write Python scripts that launch servers, install applications, configure firewalls, and tear everything down again — automatically. It's a powerful tool for DevOps engineers, cloud developers, or anyone building a system that needs cloud infrastructure behind the scenes.

If you’re building your own platform, integrating cloud actions into an app, or preparing for automation in a production environment, Boto3 is how you do it right.

✅ Launch EC2 with Apache using Boto3
We’re going to launch an EC2 instance using Python and install Apache on it. The web page will say:


Welcome to AWS CloudStart Youth Edition
🔧 Prerequisites
Make sure you have Python and pip installed. Then install Boto3:


pip install boto3
Next, configure your AWS credentials by running:


aws configure
Enter your:

Access Key ID

Secret Access Key

Default region (use us-east-1)

Output format: json

You also need a few resources already set up in AWS:

A key pair named linaskeypair

A security group that allows HTTP traffic (port 80). You already created one with ID: sg-001ab1d59b4cfd130

📝 Python Script
Create a file called launch_ec2_boto3.py:


vi launch_ec2_boto3.py
Press i to enter insert mode, then paste this:


import boto3

ec2 = boto3.client('ec2', region_name='us-east-1')

user_data_script = '''#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Welcome to AWS CloudStart Youth Edition</h1>" > /var/www/html/index.html
'''

response = ec2.run_instances(
    ImageId='ami-0c02fb55956c7d316',  # Amazon Linux 2 (us-east-1)
    InstanceType='t2.micro',
    MinCount=1,
    MaxCount=1,
    KeyName='linaskeypair',  #REMEMBER TO ADD YOUR OWN KEYPER
    SecurityGroupIds=['sg-001ab1d59b4cfd130'],  # ADD YOUR OWN SECURITY GROUP
    UserData=user_data_script
)

instance_id = response['Instances'][0]['InstanceId']
print(f"Launched EC2 instance with ID: {instance_id}")
Then press Esc, type :wq, and hit Enter to save.

🚀 Run the Script
Now launch your EC2 instance:


python launch_ec2_boto3.py
Wait a minute or two. Then go to the AWS Console → EC2 → Instances.

✅ What to Check
The instance should be running.

It must have a Public IPv4 address.

Copy the public IP and paste it into your browser.

You should see the welcome message:


Welcome to AWS CloudStart Youth Edition
If it doesn’t work:

Make sure port 80 is allowed in your security group.

Ensure your instance uses the default VPC or a subnet with internet access.

