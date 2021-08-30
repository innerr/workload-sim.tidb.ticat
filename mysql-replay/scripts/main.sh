#!/usr/bin/bash
set -xeu

cd "/tmp/test-sim/my-rep/dump"
sudo tcpdump -w data.%s.pcap -G 60 -Z "${USER}" -z "$(pwd)/rotate-hook.sh" -i "lo" tcp port 4000 &
echo $! > tcpdump.ppid
wait
echo tcpdump stopped
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null *.pcap "127.0.0.1:/tmp/test-sim/my-rep/store"
