FROM jenkins/jenkins:lts-jdk21

USER root

ENV DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION=1.13.2

RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        unzip \
        git \
        jq \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/terraform && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

RUN terraform version
RUN aws --version

USER jenkins