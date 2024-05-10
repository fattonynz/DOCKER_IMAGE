# # Use the official Debian image as the base image
# FROM debian:12

# # Update the package repository and install required tools
# RUN apt-get update && \
#     apt-get install -y python3 python3-pip ansible && \
#     apt-get clean

# # Upgrade pip and install some Python libraries
# RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update 
# RUN apt-get update
# #RUN apt-get install -y git
# RUN apt-get install -y python3-openpyxl
# RUN apt-get install -y python3-pandas
# RUN apt-get install -y python3-netmiko
# #RUN apt-get install -y python3-gitpython
# RUN apt-get install -y python3-deepdiff
# RUN apt-get install -y ca-certificates

# #RUN apt-get install -y python3-ansible


# RUN  mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.old
# RUN  pip3 install ansible-runner
# RUN pip3 install watchdog

# #RUN pip3 install azure-devops
# #RUN apt-get install ansible-runner
# #RUN apt-get install -y python3-ansible-runner
# RUN apt-get install -y python3-paramiko
# RUN apt-get install -y python3-requests
# RUN apt-get install -y python3-openpyxl
# #RUN apt-get install python3-rich
# #RUN apt-get install -y python3-pandas
# #RUN apt-get install -y python3-netmiko
# #RUN apt-get install -y python3-docker
# #RUN pip3 install gitpython
# #RUN ansible-galaxy collection install ansible.builtin
# RUN ansible-galaxy collection install cisco.ios
# RUN ansible-galaxy collection install cisco.iosxr
# RUN ansible-galaxy collection install fortinet.fortianalyzer
# #RUN ansible-galaxy collection install codeaffen.phpipam
# RUN ansible-galaxy collection install fortinet.fortimanager
# RUN ansible-galaxy collection install cisco.asa
# RUN ansible-galaxy collection install arista.avd
# RUN ansible-galaxy collection install arista.cvp
# RUN ansible-galaxy collection install arista.eos
# ENV OMP_STACKSIZE='64M'
# ENV OMP_NUM_THREADS='1'
# ENV http_proxy=
# ENV https_proxy=
# ENV ANSIBLE_HOST_KEY_CHECKING=False
# ENV ANSIBLE_LOOKUP_PLUGINS='/app'
# ENV PYTHONPATH='/app'
# ENV PMP_URL='https://pmp.gen-i.co.nz'
# COPY . /app
# # Set the working directory
# WORKDIR /app

# # Display Ansible version
# RUN ansible --version

# # Command to run when the container starts
# CMD ["/bin/bash"]
FROM alpine:3.15


ENV ANSIBLE_LOOKUP_PLUGINS='/app'
ENV PYTHONPATH "${PYTHONPATH}:/app"

# Install System Dependencies
RUN apk add --update --no-cache python3 py3-pip openssl openssh sshpass
# Install Build Dependencies
RUN apk add --update --virtual build-dependencies gcc build-base python3-dev libffi-dev openssl-dev

# Copy Additional Python Libraries for Arista CloudVision
COPY . /app

# Install Python & Ansible Dependencies
RUN pip3 install --no-cache --upgrade pip
# Install Python libraries for Arista CloudVision
#RUN pip3 install --no-cache -r /app/requirements/requirements.txt
RUN pip3 install wheel>=0.37.1
RUN pip3 install netaddr>=0.7.19
RUN pip3 install Jinja2>=2.11.3
RUN pip3 install treelib>=1.5.5
#RUN pip3 install cvprac>=1.0.7
RUN pip3 install paramiko>=2.7.1
RUN pip3 install jsonschema>=3.2.0
RUN pip3 install requests>=2.25.1
RUN pip3 install PyYAML>=5.4.1
RUN pip3 install md-toc>=7.1.0
RUN pip3 install iptools>=0.7.0
RUN pip3 install jsonrpclib>=0.2.1
RUN pip3 install ruamel.yaml>=0.17.21
# Install Ansible 
RUN pip3 install --no-cache ansible-core>=2.11.3

# Remove unused system build dependencies
RUN apk del build-dependencies
RUN rm -rf /var/cache/apk/*

# Install general yaml
RUN ansible-galaxy collection install community.general

# Install Ansible Galaxy Collection for Arista Validated Design/EOS collections
RUN ansible-galaxy collection install arista.avd:==3.4.0 &&\
	ansible-galaxy collection install arista.cvp:==3.3.1 &&\
	ansible-galaxy collection install arista.eos:==5.0.0

# Install Ansible Galaxy Collection for Cisco 
RUN ansible-galaxy collection install cisco.ios:==3.1.0 &&\
	ansible-galaxy collection install cisco.nxos

# Install Ansible Galaxy Collection for Fortinet 
RUN ansible-galaxy collection install fortinet.fortimanager

# Remove Proxy Environment Variables
ENV http_proxy=
ENV https_proxy=

# Set up working directory
WORKDIR /app
	
