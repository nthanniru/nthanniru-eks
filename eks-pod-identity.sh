name : nthanniru-eks-role-pod-idenity
Permissions:
AmazonEC2ReadOnlyAccess
AmazonS3ReadOnlyAccess
AWSCertificateManagerReadOnly

Trust Policy:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "iam.amazonaws.com",
                    "ecs-tasks.amazonaws.com",
                    "s3.amazonaws.com",
                    "ecs.amazonaws.com",
                    "pods.eks.amazonaws.com",
                    "ec2.amazonaws.com",
                    "batchoperations.s3.amazonaws.com",
                    "lambda.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
}

Go to EKS Cluster -> Access -> Pod Identity Assosiation -> Select The Namespace and Role.

Update Env variable for the fastapi and commit and post.

Check the fastapi and it should be able to provide Certs, VPC, Subnets.

#Creating a new Service Account and Testing it.
ku create sa pod-identity-testing
Create POD idenity assosiation in the EKS Cluster.
Use Deployment below with the Service Account.

---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: demo
  name: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      serviceAccountName: pod-identity-testing
      containers:
      - image: sreeharshav/fastapi:latest
        name: fastapi

ku port-forward pods/demo-86447b97b5-t5tts --address 0.0.0.0 8000:80