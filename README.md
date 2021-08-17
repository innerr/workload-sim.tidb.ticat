# workload-sim.tidb.ticat
A [ticat](https://github.com/innerr/ticat) modules repo: TiDB workload simulation auto test

## Usage:
Download or build ticat first, then fetch modules in this repo:
```bash
$> ticat hub.add innerr/workload-sim.tidb.ticat
```

Then run tests:
```bash
$> ticat selftest.br-t
$> ticat selftest.sim
```
