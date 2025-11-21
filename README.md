# DevOps Intern Assignment - Powerplay

## Objective
This project demonstrates the setup of a Linux EC2 instance, web server configuration, automated system monitoring, and AWS CloudWatch integration.

## Part 1: Environment Setup
* **Infrastructure:** Launched an Ubuntu t2.micro EC2 instance on AWS Free Tier.
* **User Management:** Created user `devops_intern` with sudo privileges.
* **Hostname:** Updated server hostname to `aniket-devops`.
* **Proof:** See screenshot `part1_SS.png`.

## Part 2: Simple Web Service
* **Web Server:** Installed Nginx.
* **Configuration:** Created a custom `index.html` that dynamically fetches the AWS Instance ID (using IMDSv2 token authentication) and displays the server uptime.
* **Proof:** See screenshot `part2_SS.png`.

## Part 3: Monitoring Script
* **Script:** Created `/usr/local/bin/system_report.sh` to capture:
  * Uptime, CPU, Memory, Disk Usage, and Top 3 Processes.
* **Automation:** Configured a cron job to run the script every 5 minutes.
  * Cron Schedule: `*/5 * * * *`
* **Proof:**
  * Cron config: `part3_1_SS.png`
  * Log output: `part3_2_SS.png`

## Part 4: AWS Integration
* **Log Group:** Created CloudWatch log group `/devops/intern-metrics`.
* **CLI Upload:** Used Python to format logs as JSON and pushed them using the AWS CLI.
* **Command Used:**
  ```bash
  aws logs put-log-events --log-group-name "/devops/intern-metrics" --log-stream-name "ec2-instance-logs" --log-events file://payload.json
  Proof: See screenshot part4_cloudwatch.png.

Usage
To reproduce the monitoring setup:

Copy system_report.sh to /usr/local/bin/.

Make it executable: chmod +x /usr/local/bin/system_report.sh.

Add the cron job listed above.


## to Reproduce the Environment

Follow the steps to recreate the setup for a Ubuntu EC2 instance.

### 1. Environment Setup
* **AWS EC2:** Launch an Ubuntu instance (t2.micro).
* **Security Group:** Allow Inbound traffic on **Port 22 (SSH)** and **Port 80 (HTTP)**.
* **Connect:** SSH into the server using the key pair.

### 2. System Configuration
Create the required user and configure permissions:
```bash
# Create the user as requires
sudo adduser devops_intern

# Grant without password sudo access
echo "devops_intern ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Update the hostname to your name
sudo hostnamectl set-hostname aniket-devops
3. Web Server Setup
Install Nginx and create the HTML file:

Bash

sudo apt update
sudo apt install nginx -y

# Fetch Instance ID and create the html dile
INSTANCE_ID=$(wget -q -O - [http://169.254.169.254/latest/meta-data/instance-id](http://169.254.169.254/latest/meta-data/instance-id))
sudo bash -c "cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<body>
    <h1>DevOps Intern Assignment</h1>
    <p><strong>Name:</strong> Aniket Kumar</p>
    <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
    <p><strong>Uptime:</strong> \$(uptime -p)</p>
</body>
</html>
EOF"
4. Automation (Monitoring Script)
Copy the system_report.sh script to /usr/local/bin/.

Make the script executable:

Bash

sudo chmod +x /usr/local/bin/system_report.sh
Configure the Cron Job to run every 5 minutes:

Bash

# Open crontab
sudo crontab -e

# Add the following line:
*/5 * * * * /usr/local/bin/system_report.sh >> /var/log/system_report.log 2>&1
5. AWS CloudWatch Integration
Install AWS CLI:

Bash

sudo snap install aws-cli --classic
aws configure  # Enter the Access Key and Your Secret Key
Create Log Group & Stream:

Bash

aws logs create-log-group --log-group-name "/devops/intern-metrics"
aws logs create-log-stream --log-group-name "/devops/intern-metrics" --log-stream-name "ec2-instance-logs"
Push Logs: Used Python to safely format logs as JSON before uploading:

Bash

# Format it sp the output of logs is in JSON
tail -n 50 /var/log/system_report.log | python3 -c "import time, json, sys; print(json.dumps([{'timestamp': int(time.time() * 1000), 'message': sys.stdin.read()}]))" > payload.json

# Upload to CloudWatch
aws logs put-log-events --log-group-name "/devops/intern-metrics" --log-stream-name "ec2-instance-logs" --log-events file://payload.json



