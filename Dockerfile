FROM debian:buster-slim

LABEL maintainer1="Luca Di Maio" \
      maintainer2="Alessio Greggi"

ARG ANSIBLE_VERSION=2.9.23
ARG CRYPTOGRAPHY_VERSION=3.3.2
ARG TERRAFORM_VERSION=0.12.0
ARG TERRAFORM_PROVIDER_VERSION=0.6.2
ARG TERRAFORM_PROVIDER_RELEASE=0.6.2+git.1585292411.8cbe9ad0
#ARG TERRIBLE_VERSION=1.1.1

# Installing Ansible
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sshpass \
        openssh-client \
        python3-setuptools \
        python3-pip \
    && pip3 install \
        cryptography==${CRYPTOGRAPHY_VERSION} \
    && pip3 install \
        ansible==${ANSIBLE_VERSION} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt autoremove -y \
    && apt-get clean autoclean

# Installing Terraform
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        unzip \
    && wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && install terraform /usr/local/bin \
    && rm -rf /terraform* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get purge -y \
        wget \
        unzip \
    && apt autoremove -y \
    && apt-get clean autoclean

# Installing Terraform-provider-libvirt
RUN mkdir -p ~/.terraform.d/plugins/linux_amd64
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
    && wget -O terraform-provider-libvirt.tar.gz \
        https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v${TERRAFORM_PROVIDER_VERSION}/terraform-provider-libvirt-${TERRAFORM_PROVIDER_RELEASE}.Ubuntu_18.04.amd64.tar.gz \
    && tar zxvf terraform-provider-libvirt.tar.gz \
    && mv terraform-provider-libvirt ~/.terraform.d/plugins/linux_amd64/ \
    && rm -rf /terraform* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get purge -y \
        wget \
    && apt autoremove -y \
    && apt-get clean autoclean

# Installing Libvirt
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libvirt0 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt autoremove -y \
    && apt-get clean autoclean

# Create the working environment
COPY . /terrible

# Installing terrible
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-pip \
    && cd /terrible \
    && pip3 install --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get purge -y \
        python3-pip \
    && apt autoremove -y \
    && apt-get clean autoclean

WORKDIR /terrible
RUN echo 'export PS1="[\[\e[31m\]\u\[\e[m\]@\[\e[31m\]terrible\[\e[m\]🐧]:\W\\$ "' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]
