#!/bin/bash

set -exuo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/helper.bash"

replay_host="${1}"
replay_path="${2}"
target_dsn="${3}"
local_pwd="${4}"

may_install_mysql_replay "${replay_host}" "${replay_path}" "${local_pwd}"

# play
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${replay_host}" "bash -c 'cd \"${replay_path}\" && \"\$HOME/bin/mysql-replay\" text play --target-dsn \"${target_dsn}\" events 2>&1 | tee play.log'"
