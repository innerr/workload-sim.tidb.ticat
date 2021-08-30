#!/usr/bin/bash
set -xe
if [ ! -x "$HOME/bin/mysql-replay" ]; then
    cd "/tmp/test-sim/my-rep/store"
    rpm -q libpcap-devel || sudo yum install -y libpcap-devel
    test -d mysql-replay || git clone https://github.com/zyguan/mysql-replay.git
    cd mysql-replay
    go build -o "$HOME/bin/mysql-replay" ./
fi
