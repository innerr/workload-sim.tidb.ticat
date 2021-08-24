# workload-sim.tidb.ticat
A [ticat](https://github.com/innerr/ticat) modules repo: TiDB workload simulation auto test


## Get ticat
[Download ticat](https://github.com/innerr/ticat/releases), or:

Build from source, `golang` is needed:
```
$> git clone https://github.com/innerr/ticat
$> cd ticat
$> make
```
Highly recommend to set `ticat` dir to system `$PATH`, it's handy.


## Usage:
Download or build ticat first, then fetch modules in this repo:
```bash
$> ticat hub.add innerr/workload-sim.tidb.ticat
```

Then run tests:
```bash
(st=selftest)

## Test BR-Text with TPCC/TPCH/Sysbench
$> ticat st.br-t

## Test BR-Text with tpcc
$> ticat conf.tpcc : st.br-t.workload

## Test mole feature collecting and calculating with TPCC/TPCH/Sysbench
$> ticat st.mole

## Test mole feature collecting and calculating with TPCC
$> ticat conf.tpcc : st.mole.workload
```
