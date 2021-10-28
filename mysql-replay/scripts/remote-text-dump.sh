#!/bin/bash

set -exuo pipefail

replay_host="${1}"
replay_path="${2}"
local_pwd="${3}"

# create mysql-replay installing script
cat <<EOF > "${local_pwd}/install-mysql-replay.sh"
#!/usr/bin/bash
set -xe
if [ ! -x "\$HOME/bin/mysql-replay" ]; then
    cd "${replay_path}"
    rpm -q libpcap-devel || sudo yum install -y libpcap-devel
    test -d mysql-replay || git clone https://github.com/zyguan/mysql-replay.git
    cd mysql-replay
    go build -o "\$HOME/bin/mysql-replay" ./
fi
EOF

# install mysql-replay if necessary
chmod +x "${local_pwd}/install-mysql-replay.sh"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${local_pwd}/install-mysql-replay.sh" "${replay_host}:${replay_path}"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${replay_host}" "bash -c \"${replay_path}/install-mysql-replay.sh\""

# dump
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${replay_host}" "bash -c 'cd \"${replay_path}\" && \"\$HOME/bin/mysql-replay\" text dump -o events data.*.pcap 2>&1 | tee dump.log'"
