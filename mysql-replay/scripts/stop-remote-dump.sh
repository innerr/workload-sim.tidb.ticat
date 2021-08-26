#!/bin/bash

set -exuo pipefail

remote_host="${1}"
remote_path="${2}"

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
	"${remote_host}" "bash -c 'kill \$(ps --ppid \$(cat \"${remote_path}/tcpdump.ppid\") -o pid=) || true'"
