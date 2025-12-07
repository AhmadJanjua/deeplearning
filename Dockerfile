# Pytorch base image
FROM pytorch/pytorch:2.9.1-cuda13.0-cudnn9-runtime

# Update and install build-essentials (required by some packages)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set parameters
USER $USERNAME
WORKDIR /workspace

# Upgrade pip and install additional required packages
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Default command
CMD ["bash"]