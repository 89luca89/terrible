FROM alpine:3.12.1

LABEL authors="Luca Di Maio, Alessio Greggi"

ARG ANSIBLE_VERSION=2.9
ARG TERRAFORM_VERSION=0.12.0
ARG TERRAFORM_PROVIDER_VERSION=0.6.2
ARG TERRAFORM_PROVIDER_RELEASE=0.6.2+git.1585292411.8cbe9ad0

# Installing Ansible
RUN apk add --no-cache --virtual .temp \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        py-pip \
    && pip3 install \
        ansible=="$ANSIBLE_VERSION" \
    && apk del .temp

# Installing Terraform
RUN apk add --no-cache --virtual .temp \
        unzip \
        curl \
    && curl -sLo /tmp/terraform.zip \
        https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip \
    && unzip -d /usr/local/bin /tmp/terraform.zip \
    && apk del .temp

