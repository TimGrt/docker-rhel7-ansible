FROM registry.access.redhat.com/ubi7/ubi-init
LABEL maintainer="Tim Gruetzmacher"
ENV container=docker

# Install requirements.
RUN yum makecache fast \
 && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && yum install -y python-pip sudo

# Upgrade Pip to latest version working properly with Python2
RUN python -m pip install --no-cache-dir --upgrade "pip < 21.0"

# # Install Ansible via pip.
RUN pip install --no-cache-dir ansible cryptography

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && printf "[local]\nlocalhost ansible_connection=local\n" > /etc/ansible/hosts

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible

RUN set -xe \
  && useradd -m ${ANSIBLE_USER} \
  && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]