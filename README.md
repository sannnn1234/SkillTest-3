

---

# EC2 Nginx Deployment with Terraform

This project uses **Terraform** to provision an **Ubuntu 20.04 LTS `t2.micro` EC2 instance** in your AWS account’s **default VPC** and bootstrap it to run the **Nginx web server** with a **custom index page**.

No custom VPC, subnet, or internet gateway is created — the instance runs entirely inside the **default VPC**, as required.

---

##  Resources Created

| Resource                   | Purpose                                                                            |
| -------------------------- | ---------------------------------------------------------------------------------- |
| `data.aws_vpc.default`     | Looks up the existing default VPC (no VPC is created).                             |
| `data.aws_ami.ubuntu`      | Finds the latest official Canonical Ubuntu 20.04 LTS AMI.                          |
| `aws_security_group.nginx` | Allows inbound HTTP (80) and SSH (22), plus all outbound traffic.                  |
| `aws_instance.nginx`       | `t2.micro` EC2 instance. `user_data` installs Nginx and writes a custom HTML page. |

---

##  Prerequisites

* Terraform **>= 1.0**
* An AWS account
* AWS credentials configured using one of the following:

  * `aws configure`
  * Environment variables
  * IAM role (for EC2 / CloudShell)
* *(Optional)* An existing EC2 key pair if SSH access is required

---

##  Configuration

All inputs have defaults (see `variables.tf`).
Common overrides are listed below:

| Variable        | Default      | Description                                             |
| --------------- | ------------ | ------------------------------------------------------- |
| `aws_region`    | `ap-south-1` | AWS region to deploy into                               |
| `instance_type` | `t2.micro`   | EC2 instance type                                       |
| `key_name`      | `""`         | Existing EC2 key pair name (optional)                   |
| `ssh_cidr`      | `0.0.0.0/0`  | CIDR allowed for SSH (restrict to your IP for security) |

---

##  How to Run

### 1️ Initialize Terraform

```bash
terraform init
```

### 2️ Preview the changes

```bash
terraform plan
```

### 3️ Create the infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

### 4️ Destroy the infrastructure (cleanup)

```bash
terraform destroy
```

Type `yes` when prompted.

---

##  SSH Access (Optional)

If you want SSH access, provide an existing key pair and restrict SSH to your IP:

```bash
terraform apply \
  -var="key_name=my-keypair" \
  -var="ssh_cidr=203.0.113.10/32"
```

---

##  Verifying the Deployment

After `terraform apply` completes, Terraform outputs:

```text
public_ip   = "X.X.X.X"
public_dns  = "ec2-X-X-X-X.compute.amazonaws.com"
website_url = "http://X.X.X.X"
```

###  Browser Test

Open the `website_url` in your browser
(allow ~1 minute for `user_data` to complete).

You should see:

```
Welcome to the Terraform-managed Nginx Server on Ubuntu
```

###  Terminal Test

```bash
curl http://$(terraform output -raw public_ip)
```

---

##  Screenshots (Optional)

![Local Setup](https://raw.githubusercontent.com/sannnn1234/SkillTest-3/main/screenshots/url.png)
![Local Setup](https://raw.githubusercontent.com/sannnn1234/SkillTest-3/main/screenshots/apply.png)
![Local Setup](https://raw.githubusercontent.com/sannnn1234/SkillTest-3/main/screenshots/destory.png) 
![Local Setup](https://raw.githubusercontent.com/sannnn1234/SkillTest-3/main/screenshots/destoryed.png)

---

##  Teardown

Running:

```bash
terraform destroy
```


