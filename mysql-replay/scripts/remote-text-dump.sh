#!/bin/bash

set -exuo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/helper.bash"

replay_host="${1}"
replay_path="${2}"
local_pwd="${3}"

may_install_mysql_replay "${replay_host}" "${replay_path}" "${local_pwd}"

# text dump
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${replay_host}" "bash -c 'cd \"${replay_path}\" && \"\$HOME/bin/mysql-replay\" text dump -o events data.*.pcap 2>&1 | tee dump.log'"
