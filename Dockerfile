FROM debian:buster-slim

LABEL maintainer1="Luca Di Maio" \
      maintainer2="Alessio Greggi"

ARG ANSIBLE_VERSION=2.9.15-1ppa~trusty
ARG TERRAFORM_VERSION=0.12.0
ARG TERRAFORM_PROVIDER_VERSION=0.6.2
ARG TERRAFORM_PROVIDER_RELEASE=0.6.2+git.1585292411.8cbe9ad0
ARG TERRIBLE_VERSION=1.1.1

# Installing Ansible
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg2 \
    && apt-key adv \
        --keyserver keyserver.ubuntu.com \
        --recv-keys 93C4A3FD7BB9C367 \
    && echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ansible=${ANSIBLE_VERSION} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get purge -y \
        gnupg2 \
    && apt autoremove -y \
    && apt-get clean autoclean

#RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list \
#    && apt-get update \
#    && apt-get install -y --no-install-recommends \
#        ansible=${ANSIBLE_VERSION} \
#    && rm -rf /var/lib/apt/lists/* \
#    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
#    && apt-get clean autoclean

#RUN apt-get update \
#    && apt-get install -y --no-install-recommends \
#       sshpass \
#       openssh-client \
#       python3-setuptools \
#       python3-wheel \
#       python3-cryptography \
#       python3-pip \
#    && pip3 install \
#        ansible==${ANSIBLE_VERSION} \
#    && rm -rf /var/lib/apt/lists/* \
#    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
#    && apt-get clean autoclean

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

# Installing terrible
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        unzip \
        python3-pip \
    && cd /root \
    && wget https://github.com/89luca89/terrible/archive/${TERRIBLE_VERSION}.zip \
    && unzip ${TERRIBLE_VERSION}.zip \
    && pip3 install --no-cache-dir -r terrible-${TERRIBLE_VERSION}/requirements.txt \
    && rm -rf ${TERRIBLE_VERSION}.zip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get purge -y \
        wget \
        unzip \
        python3-pip \
    && apt autoremove -y \
    && apt-get clean autoclean

WORKDIR /root/terrible-${TERRIBLE_VERSION}

CMD ["/bin/bash"]
