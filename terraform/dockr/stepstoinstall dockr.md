Sure! Below are the **full steps** to **install Docker** on your **EC2 instance** (for both **Amazon Linux 2** and **Ubuntu**). I will go step-by-step, so you can follow them easily.

---

### **For Amazon Linux 2:**

#### Step 1: **Connect to your EC2 Instance**

First, SSH into your EC2 instance. Use the `test.pem` key or the correct key pair you have associated with the instance:

```bash
ssh -i "test.pem" ec2-user@3.110.85.25
```

#### Step 2: **Update the system**

Make sure your EC2 instance's software is up-to-date:

```bash
sudo yum update -y
```

#### Step 3: **Install Docker**

Install Docker using Amazon Linux extras. This command installs Docker and the required dependencies:

```bash
sudo yum install docker -y
```

#### Step 4: **Start Docker Service**

After Docker is installed, you need to start the Docker service. Use the following command:

```bash
sudo service docker start
```

**Alternatively**, if the service is using systemd, you can try:

```bash
sudo systemctl start docker
```

#### Step 5: **Enable Docker to start on boot**

To ensure Docker starts automatically after a reboot, enable the service:

```bash
sudo systemctl enable docker
```

#### Step 6: **Add `ec2-user` to Docker group (optional)**

To run Docker commands without using `sudo`, add the `ec2-user` to the Docker group:

```bash
sudo usermod -aG docker ec2-user
```

**Log out and log back in** for this to take effect:

```bash
exit
```

Then SSH back into your instance:

```bash
ssh -i "test.pem" ec2-user@3.110.85.25
```

#### Step 7: **Verify Docker Installation**

Check if Docker is correctly installed and running:

```bash
docker --version
```

This should show the installed Docker version.

You can also check the Docker system info:

```bash
docker info
```

#### Step 8: **Test Docker**

Run a simple Docker container to verify everything is working:

```bash
docker run hello-world
```

---

### **For Ubuntu:**

#### Step 1: **Connect to your EC2 Instance**

SSH into your EC2 instance using your private key (`test.pem`):

```bash
ssh -i "test.pem" ubuntu@3.110.85.25
```

#### Step 2: **Update the system**

Make sure your EC2 instance is up-to-date with the latest software packages:

```bash
sudo apt update
```

#### Step 3: **Install Docker**

Install Docker from the default Ubuntu repository:

```bash
sudo apt install -y docker.io
```

#### Step 4: **Start Docker Service**

After Docker installation, start the Docker service:

```bash
sudo systemctl start docker
```

#### Step 5: **Enable Docker to start on boot**

To make Docker start automatically when the instance reboots, use this command:

```bash
sudo systemctl enable docker
```

#### Step 6: **Add `ubuntu` user to Docker group (optional)**

To allow the `ubuntu` user to run Docker commands without `sudo`, add the `ubuntu` user to the Docker group:

```bash
sudo usermod -aG docker ubuntu
```

**Log out and log back in** for the changes to take effect:

```bash
exit
```

Then SSH back into your instance:

```bash
ssh -i "test.pem" ubuntu@3.110.85.25
```

#### Step 7: **Verify Docker Installation**

Check the Docker version to ensure it's installed:

```bash
docker --version
```

You can also check Docker system info:

```bash
docker info
```

#### Step 8: **Test Docker**

Run the "hello-world" Docker container to make sure Docker is working:

```bash
docker run hello-world
```

---

### **Troubleshooting Steps**

If you encounter any issues during installation, you can follow these steps:

1. **Check Docker Service Status:**
   If the service doesn't start, check its status:

   ```bash
   sudo systemctl status docker
   ```

2. **Docker Logs:**
   Check logs to identify the issue:

   ```bash
   sudo journalctl -u docker
   ```

3. **Reboot the Instance:**
   If Docker fails to start, you can reboot the EC2 instance:

   ```bash
   sudo reboot
   ```

4. **Check for Missing Packages or Dependencies:**
   If installation fails, ensure your EC2 instance has access to the internet, and that no dependencies are missing.

---

Let me know if you encounter any issues during the installation! I'm here to help further if needed.
