# Flask & Express Deployment on AWS using Terraform

## Project Overview

This project demonstrates three different deployment architectures for a Flask backend and an Express frontend application using AWS and Terraform. The deployments progress from a simple single EC2 setup to a production-style containerized architecture using Docker, Amazon ECR, ECS Fargate, and an Application Load Balancer.

All infrastructure is provisioned using Terraform (Infrastructure as Code), ensuring repeatable, scalable, and auditable deployments.

---

## Technologies Used

- AWS EC2
- AWS VPC, Subnets, Security Groups
- AWS ECR
- AWS ECS (Fargate)
- AWS Application Load Balancer (ALB)
- Docker
- Terraform
- Flask (Python)
- Express (Node.js)

---

# Task 1: Deploy Flask and Express on a Single EC2 Instance

## Objective

Deploy both the Flask backend and the Express frontend on a single EC2 instance using Terraform. Both applications must run on different ports and be accessible via the EC2 public IP.

---

## Architecture

- One EC2 instance
- Flask backend on port 5000
- Express frontend on port 3000
- Security group allows inbound traffic on ports 22, 3000, and 5000

---

## Implementation

1. Terraform provisions an EC2 instance.
2. A security group allows SSH, Flask, and Express ports.
3. Dependencies installed using user-data or manual setup.
4. Flask and Express applications started on different ports.
5. PM2 used to keep the Express application running.

---


# Task 1: Deploy Flask and Express on a Single EC2 Instance

## Objective

Deploy both the Flask backend and the Express frontend on a single EC2 instance using Terraform. Both applications must run on different ports and be accessible via the EC2 public IP.

---

## Architecture

- One EC2 instance
- Flask backend on port 5000
- Express frontend on port 3000
- Security group allows inbound traffic on ports 22, 3000, and 5000

---

## Implementation

1. Terraform provisions an EC2 instance.
2. A security group allows SSH, Flask, and Express ports.
3. Dependencies installed using user-data or manual setup.
4. Flask and Express applications started on different ports.
5. PM2 used to keep the Express application running.

---



# Task 2: Deploy Flask and Express on Separate EC2 Instances

## Objective

Deploy the Flask backend and Express frontend on two separate EC2 instances using Terraform, with proper security group communication.

---

## Architecture

- EC2 Instance 1: Flask backend (port 5000)
- EC2 Instance 2: Express frontend (port 3000)
- Security groups allow public access and backend communication

---

## Implementation

1. Terraform provisions two EC2 instances.
2. Separate security groups created for backend and frontend.
3. Flask backend deployed on backend EC2.
4. Express frontend deployed on frontend EC2.
5. Frontend communicates with backend using backend public IP.






---

## Terraform Best Practices

- Variables defined in variables.tf
- Outputs defined in outputs.tf
- Reusable and modular code
- terraform plan used before apply

---

## How to Deploy

Example for Task 3:

```bash
cd terraform_ecs_docker
terraform init
terraform plan
terraform apply
```



