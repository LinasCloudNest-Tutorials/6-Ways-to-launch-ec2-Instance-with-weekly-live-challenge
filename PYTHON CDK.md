# Step-by-Step Guide: Launch EC2 with Apache using AWS CDK (Python) via VSCode or CloudShell

This guide walks you through launching an EC2 instance, installing Apache, and serving a custom welcome page using AWS CDK (Python). It also includes common mistake traps to avoid.

---

## 💭 Why Use All These Tools Instead of Just the Console?

You might be wondering:

> "Why install CDK, Python, Node.js, configure credentials, bootstrap environments — when I could just go to the AWS Console and click a few buttons to launch an instance?"

You're absolutely right to ask. When you're learning, the console is great. But here's the thing:

In **real-world production environments** — like Netflix, Google, or any modern enterprise — teams launch **thousands of instances, containers, and infrastructure components every minute**. No one has time to log in and click manually.

Using tools like **CDK, Terraform, CloudFormation, or CLI** gives you:

* **Speed** — automate 1, 100, or 10,000 EC2s with one command
* **Consistency** — the same code works in dev, staging, and prod
* **Version control** — infrastructure changes are tracked like application code
* **Disaster recovery** — easily re-create entire environments

This is what separates hobbyists from professional engineers.

---

## ✅ What is AWS CDK?

AWS Cloud Development Kit (CDK) lets you define cloud infrastructure using code. Instead of writing raw JSON/YAML templates (like in CloudFormation), you use familiar programming languages (Python, TypeScript, etc.) to create and deploy AWS resources.

---

## ✅ Prerequisites (Install These First)

### 1. **Install AWS CLI**

* Download: [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* Configure:

```bash
aws configure
```

Provide:

* Access Key ID
* Secret Access Key
* Region (e.g., `us-east-1`)
* Output format: `json`

### 2. **Install Node.js (LTS)**

* [https://nodejs.org](https://nodejs.org)

### 3. **Install AWS CDK CLI**

```bash
npm install -g aws-cdk
```

### 4. **Install Python 3 and pip**

```bash
python --version
pip --version
```

### 5. **Install Visual Studio Code (Optional)**

* [https://code.visualstudio.com](https://code.visualstudio.com)

---

## ✅ Step-by-Step: Set Up CDK Project from Scratch

### 1. Open terminal and go to your working directory:

```bash
cd ~
```

### 2. Create a new folder and enter it:

```bash
mkdir ec2-cdk && cd ec2-cdk
```

### 3. Initialize a new CDK project in Python:

```bash
cdk init app --language python
```

### 4. Create and activate a virtual environment:

```bash
python -m venv .env
source .env/Scripts/activate     # (For Git Bash/Windows)
```

### 5. Edit `requirements.txt`:

This file lists the Python dependencies your CDK project needs.

To open and edit it:

```bash
vi requirements.txt
```

Press `i` to enter insert mode, delete all existing lines, and paste this:

```
aws-cdk-lib
constructs==10.3.0
```

Then press `Esc`, type `:wq`, and press Enter to save and exit.

### 6. Install the requirements:

```bash
pip install -r requirements.txt
```

This installs the necessary Python libraries for AWS CDK v2 (`aws-cdk-lib`) and the correct version of the `constructs` library.

---

## ✅ Write EC2 + Apache Setup in CDK Code

### 1. Open and edit the stack file:

```bash
vi ec2_cdk/ec2_cdk_stack.py
```

Press `i` to enter insert mode, then delete all the code in the file and paste this:

```python
from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
)
from constructs import Construct

class Ec2CdkStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        vpc = ec2.Vpc(self, "MyVpc", max_azs=2)

        instance = ec2.Instance(
            self, "MyInstance",
            instance_type=ec2.InstanceType("t2.micro"),
            machine_image=ec2.MachineImage.latest_amazon_linux2(),
            vpc=vpc,
        )

        instance.user_data.add_commands(
            "sudo yum update -y",
            "sudo yum install -y httpd",
            "sudo systemctl start httpd",
            "sudo systemctl enable httpd",
            "echo '<h1>Welcome to AWS CloudStart Youth Edition</h1>' > /var/www/html/index.html"
        )
```

Then press `Esc`, type `:wq`, and press Enter to save and exit.

---

### 2. Now edit the app file:

```bash
vi app.py
```

Replace all content with:

```python
#!/usr/bin/env python3

import aws_cdk as cdk
from ec2_cdk.ec2_cdk_stack import Ec2CdkStack

app = cdk.App()
Ec2CdkStack(app, "Ec2CdkStack")
app.synth()
```

Then press `Esc`, type `:wq`, and press Enter.

---

## ✅ Bootstrap and Deploy

### 1. Bootstrap environment:

```bash
cdk bootstrap
```

### 2. Deploy the stack:

```bash
cdk deploy
```

Type `y` and hit Enter when prompted.

---

## ✅ After Deploying

1. Go to **AWS Console → EC2 → Instances**
2. Locate your instance named `MyInstance`
3. Confirm it has a **Public IPv4 Address**
4. Paste the IP in your browser
5. You should see:

```html
Welcome to AWS CloudStart Youth Edition
```

If you don’t see a public IP:

* Ensure you're in a public subnet
* Security group should allow HTTP (port 80)
* EC2 instance must have `associatePublicIpAddress` enabled (default VPC usually handles this)

---

## ⚠️ Common Mistakes to Avoid

1. **Wrong CDK version:** Do **not** install `aws-cdk.aws-ec2`. Use only `aws-cdk-lib`
2. **Wrong constructs version:** Must be `constructs==10.3.0`
3. **No virtual environment:** Always activate `.env` before installing
4. **Missing credentials:** Run `aws configure` first
5. **No public IP:** Instance must be in a public subnet with auto-assigned public IP
6. **Amazon Linux warning:** Always use `latest_amazon_linux2()`

---

## 🧹 Optional Cleanup

To suppress CLI notice:

```bash
cdk acknowledge 34892
```

To delete your resources:

```bash
cdk destroy
```

---

Stay consistent, stay hydrated — and keep building. 🚀
