#!/usr/bin/bash
set -xeu
file_path="${1}"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${file_path}" "127.0.0.1:/tmp/test-sim/my-rep/store"
rm -f "${file_path}"
