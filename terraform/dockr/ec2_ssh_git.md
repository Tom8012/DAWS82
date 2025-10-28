Cool, here’s a ready‑to‑use Terraform module file that you can reuse whenever you spin up a new EC2 instance. It assumes you have your SSH public key locally (so you don’t need to re‑generate or upload it manually each time), and also sets up user\_data so you can immediately `git clone` and use SSH + GitHub.

You’ll just fill in your public key, adjust AMI, etc.

---

## 🔧 Terraform Module: EC2 with SSH + GitHub Clone

Create a file called e.g. `ec2_ssh_git.tf` with the following content:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "github_repo_ssh" {
  type    = string
  # set to SSH clone URL of your repo, e.g. "git@github.com:Tom80/dockerfiles.git"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_filter_name" {
  type    = string
  default = "amzn2-ami-hvm-*-x86_64-gp2"
}

provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }
}

resource "aws_key_pair" "my_ssh_key" {
  key_name   = "my-ssh-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "sg_ssh_http" {
  name        = "allow-ssh-http"
  description = "Allow SSH (22) and HTTP (80) inbound"
  vpc_id      = aws_vpc.main.id # if using a VPC; else if default VPC skip vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # optionally restrict to your IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_with_git" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_ssh_http.id]
  # subnet_id etc if using custom VPC

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Create .ssh directory
    mkdir -p /home/ec2-user/.ssh
    chmod 700 /home/ec2-user/.ssh

    # Add the public key to authorized_keys
    echo "${file(var.public_key_path)}" >> /home/ec2-user/.ssh/authorized_keys
    chmod 600 /home/ec2-user/.ssh/authorized_keys
    chown -R ec2-user:ec2-user /home/ec2-user/.ssh

    # Install Git
    yum update -y
    yum install -y git

    # Clone the GitHub repo if not already done
    cd /home/ec2-user
    if [ ! -d "$(basename ${var.github_repo_ssh} .git)" ]; then
      git clone ${var.github_repo_ssh}
      chown -R ec2-user:ec2-user $(basename ${var.github_repo_ssh} .git)
    fi
  EOF

  tags = {
    Name = "ec2-ssh-git"
  }
}

output "ec2_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.ec2_with_git.public_ip
}
```

---

## ⚙ How to Use

1. Save the file above (e.g. `ec2_ssh_git.tf`)
2. In the same directory, create a `terraform.tfvars` file, for example:

```hcl
github_repo_ssh = "git@github.com:Tom80/dockerfiles.git"
public_key_path = "/home/yourusername/.ssh/id_ed25519.pub"
instance_type   = "t3.micro"
```

3. Initialize Terraform:

```bash
terraform init
```

4. Plan:

```bash
terraform plan
```

5. Apply:

```bash
terraform apply
```

After apply, you'll get the instance IP from the output. You can SSH in using:

```bash
ssh -i ~/.ssh/id_ed25519 ec2-user@<output-ec2_ip>
```

---

If you like, I can also generate a version that uses AWS Secrets Manager or Parameter Store for private keys so you don’t store them locally or in Terraform state. Do you want that variant?
