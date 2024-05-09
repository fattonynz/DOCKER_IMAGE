# Use the official Debian image as the base image
FROM debian:12

# Update the package repository and install required tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip ansible && \
    apt-get clean

# Upgrade pip and install some Python libraries
RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update 
RUN apt-get update
#RUN apt-get install -y git
RUN apt-get install -y python3-openpyxl
RUN apt-get install -y python3-pandas
RUN apt-get install -y python3-netmiko
#RUN apt-get install -y python3-gitpython
RUN apt-get install -y python3-deepdiff
RUN apt-get install -y ca-certificates

#RUN apt-get install -y python3-ansible


RUN  mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.old
RUN  pip3 install ansible-runner
RUN pip3 install watchdog

#RUN pip3 install azure-devops
#RUN apt-get install ansible-runner
#RUN apt-get install -y python3-ansible-runner
RUN apt-get install -y python3-paramiko
RUN apt-get install -y python3-requests
RUN apt-get install -y python3-openpyxl
#RUN apt-get install python3-rich
#RUN apt-get install -y python3-pandas
#RUN apt-get install -y python3-netmiko
#RUN apt-get install -y python3-docker
#RUN pip3 install gitpython
#RUN ansible-galaxy collection install ansible.builtin
RUN ansible-galaxy collection install cisco.ios
RUN ansible-galaxy collection install cisco.iosxr
RUN ansible-galaxy collection install fortinet.fortianalyzer
#RUN ansible-galaxy collection install codeaffen.phpipam
RUN ansible-galaxy collection install fortinet.fortimanager
RUN ansible-galaxy collection install cisco.asa
RUN ansible-galaxy collection install arista.avd
RUN ansible-galaxy collection install arista.cvp
RUN ansible-galaxy collection install arista.eos
ENV OMP_STACKSIZE='64M'
ENV OMP_NUM_THREADS='1'
ENV http_proxy=
ENV https_proxy=
ENV ANSIBLE_HOST_KEY_CHECKING=False
ENV ANSIBLE_LOOKUP_PLUGINS='/app'
ENV PYTHONPATH='/app'
ENV PMP_URL='https://pmp.gen-i.co.nz'
COPY . /app
# Set the working directory
WORKDIR /app

# Display Ansible version
RUN ansible --version

# Command to run when the container starts
CMD ["/bin/bash"]

