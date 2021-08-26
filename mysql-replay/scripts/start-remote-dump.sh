#!/bin/bash

set -exuo pipefail

remote_host="${1}"
remote_path="${2}"
remote_ni="${3}"
replay_host="${4}"
replay_path="${5}"
local_pwd="${6}"

# ensure tcpdump on remote
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${remote_host}" "bash -c 'rpm -q tcpdump || sudo yum install -y tcpdump'"

# setup working directories
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${remote_host}" "bash -c 'rm -rf \"${remote_path}\" && mkdir -p \"${remote_path}\"'"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${replay_host}" "bash -c 'rm -rf \"${replay_path}\" && mkdir -p \"${replay_path}\"'"

# generate rotate-hook script for tcpdump
cat <<EOF > "${local_pwd}/rotate-hook.sh"
#!/usr/bin/bash
set -xeu
file_path="\${1}"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "\${file_path}" "${replay_host}:${replay_path}"
rm -f "\${file_path}"
EOF
chmod +x "${local_pwd}/rotate-hook.sh"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${local_pwd}/rotate-hook.sh" "${remote_host}:${remote_path}"

# generate main script
cat <<EOF > "${local_pwd}/main.sh"
#!/usr/bin/bash
set -xeu

cd "${remote_path}"
sudo tcpdump -w data.%s.pcap -G 60 -Z "\${USER}" -z "\$(pwd)/rotate-hook.sh" -i "${remote_ni}" tcp port 4000 &
echo \$! > tcpdump.ppid
wait
echo tcpdump stopped
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null *.pcap "${replay_host}:${replay_path}"
EOF
chmod +x "${local_pwd}/main.sh"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${local_pwd}/main.sh" "${remote_host}:${remote_path}"

# start to dump
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${remote_host}" \
	"sudo pkill tcpdump || true"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${remote_host}" \
	"nohup \"${remote_path}/main.sh\" 1>\"${remote_path}/main.log\" 2>&1 &"
