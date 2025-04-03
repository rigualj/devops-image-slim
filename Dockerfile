# --- Dockerfile for Terraform + AWS CLI ---

# Start with a lightweight linux base
FROM debian:bullseye-slim

# Set environment variables
ENV TERRAFORM_VERSION=1.11.3

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    python3 \
    python3-pip \
    bash \
    jq \
    git \
    ca-certificates \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN cd /tmp && \
    curl --fail -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chmod +x /usr/local/bin/terraform

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
    rm -rf /var/cache/apk/*

# Verify installations
RUN terraform --version && \
    aws --version

# Set working directory
WORKDIR /workspace

# Default command
CMD ["bash"]