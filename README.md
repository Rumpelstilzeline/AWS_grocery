# GroceryMate on AWS ☁️🛒

## 1. Application Description

GroceryMate is an application originally developed by **Alejandro Roman Ibanez** as part of the Masterschool program.  
This project extends his work by deploying the application on the **AWS Cloud** using **Infrastructure as Code (IaC)** with Terraform.  

The application itself is a modern, full-featured **e-commerce platform** designed for seamless online grocery shopping. It provides an intuitive user interface and a secure backend, allowing users to browse products, manage their shopping basket, and complete purchases efficiently.  

### 🛒 Features
- 🛡️ **User Authentication**: Secure registration, login, and session management  
- 🔒 **Protected Routes**: Access control for authenticated users  
- 🔎 **Product Search & Filtering**: Browse products, apply filters, and sort by category or price  
- ⭐ **Favorites Management**: Save preferred products  
- 🛍️ **Shopping Basket**: Add, view, modify, and remove items  
- 💳 **Checkout Process**:  
  - Secure billing and shipping information handling  
  - Multiple payment options  
  - Automatic total price calculation  

---

## 2. AWS Deployment (Infrastructure Layer)

The infrastructure for GroceryMate is defined with **Terraform** and located in the [`infrastructure/`](infrastructure) folder.  
It provisions a complete cloud-native environment with load balancing, auto scaling, monitoring, and persistent storage.

### 2.1 AWS Resources Used
- **Amazon EC2 (Auto Scaling Group)** – runs Docker containers of the GroceryMate app; scales in/out automatically  
- **Amazon ECR (Elastic Container Registry)** – stores the Docker image for the application  
- **Amazon ALB (Application Load Balancer)** – distributes traffic across EC2 instances in multiple Availability Zones  
- **Amazon RDS (PostgreSQL)** – managed relational database service for application data (deployed in a private subnet)  
- **Amazon S3** – stores static assets (e.g., product images, uploads)  
- **Amazon CloudWatch** – monitors application and infrastructure metrics, with alarms for scaling  
- **IAM Roles** – grant EC2 and ECS access to ECR and CloudWatch  
- **Security Groups** – control inbound/outbound traffic (e.g., ALB open to HTTP/HTTPS, EC2 restricted, RDS private)  
- **VPC (Default)** – networking environment with public and private subnets  

---

## 3. Architecture Diagram

The updated cloud architecture is illustrated below:

![Cloud Architecture](docs/Cloud_architektur_Grafik.png)

### Key Points:
- Users access the app through the **Application Load Balancer**  
- ALB routes traffic to the **EC2 Auto Scaling Group** (running Docker containers)  
- EC2 instances connect to the **RDS PostgreSQL** database in a private subnet  
- **S3 bucket** provides static file storage  
- **CloudWatch** collects logs/metrics and triggers scaling policies  

---

## 4. Repository Structure

```bash
AWS_grocery/
│
├── app/                        # Core GroceryMate application code
├── backend/                    # Dockerfile for containerizing the application
├── infrastructure/             # Terraform IaC configurations
│   ├── asg-and-launch-template.tf
│   ├── cloudwatch.tf
│   ├── data-and-common.tf
│   ├── ec2.tf
│   ├── ecr-and-iam.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── rds.tf
│   ├── s3.tf
│   ├── security-and-alb.tf
│   └── variables.tf
└── README.md                   # Project documentation


## 5. Getting Started

### Prerequisites
- AWS Account with proper permissions  
- Installed tools: **AWS CLI**, **Terraform**, **Git**  
- A valid **AWS SSO login** or IAM credentials  
- Configured **SSH Key Pair** for EC2 access  

### Steps
1. Clone this repository:  
   ```bash
   git clone git@github.com:Rumpelstilzeline/AWS_grocery.git
   cd AWS_grocery/infrastructure

2\. Initialize Terraform:

terraform init

3\. Adjust variables in terraform.tfvars

\-region → AWS region

\-key\_name → Name of your SSH key pair

\-my\_ip\_cidr → Your public IP in CIDR format

\-Database credentials (db\_name, db\_username)

\-bucket\_name → S3 bucket name (must be globally unique)

4\. Plan and apply the infrastructure

terraform plan -out plan.out

terraform apply plan.out

5\. Verify deployment

Access the EC2 public IP in your browser

Confirm the database is running in the RDS console

Check that the S3 bucket has been created

6\. Credits

Original application: Alejandro Roman Ibanez

AWS/Terraform integration and cloud deployment: Julia Schwab (Rumpelstilzeline)
