#!/usr/bin/env bash
# shellcheck shell=bash

set -o errexit
set -o pipefail
set -o xtrace


sudo apt-get update && sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible && sudo apt-get install ansible -y
sudo ansible-galaxy collection install community.general

# Update apt and install required packages
sudo apt-get update
sudo apt-get install -y \
    gdisk \
    e2fsprogs \
    debootstrap \
    nvme-cli



ansible-playbook /tmp/ansible-playbook/ansible.yml -vvv
