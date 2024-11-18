# ECS Fargate Project with FastAPI

This project deploys a FastAPI application using AWS ECS with Fargate Spot capacity to reduce costs. 

The deployment is managed using Terraform and utilizes AWS resources such as ECS Clusters, IAM roles, task definitions, and ECS services. 

The FastAPI service runs in a Fargate task with network and security configurations.

## Project Structure

```
ecs-fargate/
├── app/
│   ├── main.py           # FastAPI application code
├── .gitignore
├── Dockerfile            # Dockerfile for building the FastAPI container image
├── main.tf               # Terraform configuration file
└── README.md             # Project documentation
```

## Prerequisites

* AWS CLI installed and configured with a profile named qiross.

* Terraform installed.

* Docker installed for building container images.

* AWS account with necessary permissions for ECS, IAM, VPC, and related resources.

## Deployment Steps

### Step 1: Build and Push Docker Image

1. Build the Docker image for your FastAPI application:

```
docker build -t <your-registry>/fastapi-fargate:latest .
```

2. Push the image to DockerHub (ensure you are logged in):

```
docker push <your-registry>/fastapi-fargate:latest
```

### Step 2: Configure and Deploy with Terraform

1. Initialize Terraform:

```
terraform init
```

2. Review the execution plan:

```
terraform plan -out=tfplan
```

3. Apply the plan:

```
terraform apply "tfplan"
```

4. Terraform will provision the necessary AWS resources including:

* ECS Cluster

* IAM Role for ECS task execution

* ECS Task Definition

* ECS Service with Fargate Spot capacity

## Configuration Details

ECS Cluster Name: fastapi-fargate-cluster

Task Definition:

CPU: 256

Memory: 512

Container Port: 80

Network Configuration:

Subnet: subnet-01fb57be965f0ab32 (modify as needed)

Security Group: sg-06b1d2e2e843529f4 (modify as needed)

## Using Fargate Spot

The ECS service uses Fargate Spot capacity to minimize costs. This is specified through the capacity_provider_strategy block in the aws_ecs_service resource.

## Accessing the FastAPI Application

The FastAPI application is exposed publicly through the network configuration specified. Once the deployment completes:

* Find the public IP assigned to the Fargate task.

* Use curl or a web browser to access the application at http://<public-ip>.

## Cleanup

To destroy all resources created by this project:

```
terraform destroy
```

## Notes

* Ensure your security group allows inbound traffic on port 80 for accessing the FastAPI service.

* You may need to update VPC, subnets, and security group configurations based on your AWS setup.

## Future Improvements

* Add an Elastic Load Balancer for better availability and a stable DNS endpoint.

* Implement monitoring and logging for the FastAPI application.

* Consider adding auto-scaling capabilities to the ECS service.