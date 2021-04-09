#!/usr/bin/env bash
set -x



touch /var/log/user-data.log
chmod 600 /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

cat << EOF >> /etc/environment
export HMPPS_STACKNAME=${env_identifier}
export HMPPS_STACK="${short_env_identifier}"
export HMPPS_ACCOUNT_ID="${aws_account_id}"
export HMPPS_DOMAIN="${public_domain}"
export INSTANCE_ID="`curl http://169.254.169.254/latest/meta-data/instance-id`"
export REGION="${region}"
export EFS_VOLUME_ID="${efs_volume_id}"
export CLOUDWATCH_LOG_GROUP="${bastion_cloudwatch_log_group}"
EOF

## Ansible runs in the same shell that has just set the env vars for future logins so it has no knowledge of the vars we've
## just configured, so lets export them
$(cat /etc/environment)

cat << EOF > ~/requirements.yml
---

- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-bootstrap
  version: bastion
- name: hardening
  src: dev-sec.os-hardening
- name: yum-cron
  src: jeffwidman.yum-cron
- name: ansible-ssh-hardening
  src: https://github.com/lazzurs/ansible-ssh-hardening
  version: feature/password_key_2fa
- name: users
  src: https://github.com/ministryofjustice/ansible-users
- name: sudo
  src: weareinteractive.sudo
EOF


/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml

# Setup Ansible Vars
cat << EOF > ~/vars.yml
# Cloudwatch Logs
region: "${region}"
cwlogs_log_group: "${bastion_cloudwatch_log_group}"

bastion_external_endpoint: "${bastion_external_endpoint}"
# For user_update cron
remote_user_filename: "${bastion_inventory}"

# for ansible-ssh-hardening
ssh_key_pass_2fa: true
ssh_server_password_login: true

# for EFS
efs_mount_dir: "${efs_mount_dir}"
efs_file_system_id: "${efs_volume_id}"
efs_file_system_id: "${efs_volume_id}"
efs_mount_user: "${efs_mount_user}"
EOF

# Create bootstrap playbook
cat << EOF > ~/ansible_bootstrap.yml
---

- hosts: localhost
  vars_files:
   - "{{ playbook_dir }}/vars.yml"
   - "{{ playbook_dir }}/users.yml"
  roles:
     - bootstrap
     - yum-cron
     - ansible-ssh-hardening
     - sudo
     - users
EOF

cat << EOF >> ~/.bash_profile

alias getenv='. /etc/environment && cat /etc/environment'
alias tailudl='tail -n 100 -F /var/log/user-data.log'
alias udl='less +G /var/log/user-data.log'
alias ud='less /var/lib/cloud/instance/user-data.txt'
## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias src='. ~/.bash_profile'
EOF

# Create boot script to allow for easier reruns if needed
cat << EOF > ~/runboot.sh
#!/usr/bin/env bash
export ANSIBLE_LOG_PATH=\$HOME/.ansible.log
ansible-galaxy install -f -r ~/requirements.yml
ansible-playbook ~/ansible_bootstrap.yml \
   -b -vvvv
EOF
#
chmod u+x ~/runboot.sh

# Run the boot script
~/runboot.sh
