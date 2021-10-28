set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

bench_begin=`must_env_val "${env}" 'bench.begin'`
workload=`must_env_val "${env}" 'bench.workload'`
bench_tag=`must_env_val "${env}" 'bench.tag'`
data_tag=`must_env_val "${env}" 'tidb.data.tag'`
echo "summary info:"
echo "    test id:  ${bench_begin}"
echo "    workload: ${workload}"
echo "    bench tag: ${bench_tag}"

backup_begin=`must_env_val "${env}" 'br-t.backup.begin'`
backup_end=`must_env_val "${env}" 'br-t.backup.end'`
((backup_dur=backup_end-backup_begin))
echo "duration of br-t.backup:"
echo "    ${backup_dur}s"

restore_begin=`must_env_val "${env}" 'lightning.csv.begin'`
restore_end=`must_env_val "${env}" 'lightning.csv.end'`
((restore_dur=restore_end-restore_begin))
echo "duration of lightning.csv import:"
echo "    ${restore_dur}s"

mask_begin=`must_env_val "${env}" 'sql-masker.mask.begin'`
mask_end=`must_env_val "${env}" 'sql-masker.mask.end'`
((mask_dur=mask_end-mask_begin))
echo "duration of sql-masker.mask:"
echo "    ${mask_dur}s"

backup_dir=`must_env_val "${env}" 'br.backup-dir'`
backup_size=`du -sh "${backup_dir}"`
echo "backup size of br-text"
echo "    ${backup_size}"

run_begin=`must_env_val "${env}" 'bench.run.begin'`
run_end=`must_env_val "${env}" 'bench.run.end'`
((run_dur=run_end-run_begin))
echo "duration of ${workload}.run:"
echo "    ${run_dur}s"

replay_begin=`must_env_val "${env}" 'my-rep.rep.begin'`
replay_end=`must_env_val "${env}" 'my-rep.rep.end'`
((replay_dur=replay_end-replay_begin))
echo "duration of replay:"
echo "    ${replay_dur}s"

replay_dir=`must_env_val "${env}" 'my-rep.store.dir'`
replay_size=`du -sh "${replay_dir}"`
echo "flow dump/replay size:"
echo "    ${replay_size}"

mask_stats=`must_env_val "${env}" 'sql-masker.mask.stats'`
echo "mask stats:"
echo "    ${mask_stats}"

queries=`must_env_val "${env}" 'my-rep.rep.queries'`
queries_err=`must_env_val "${env}" 'my-rep.rep.queries.err'`
echo "replay queries:"
echo "    OK:  ${queries}"
echo "    ERR: ${queries_err}"
stmt=`must_env_val "${env}" 'my-rep.rep.stmt.exe'`
stmt_err=`must_env_val "${env}" 'my-rep.rep.stmt.exe.err'`
echo "replay stmt:"
echo "    OK:  ${stmt}"
echo "    ERR: ${stmt_err}"
stmt_pp=`must_env_val "${env}" 'my-rep.rep.stmt.prepares'`
stmt_pp_err=`must_env_val "${env}" 'my-rep.rep.stmt.prepares.err'`
echo "replay stmt prepares:"
echo "    OK:  ${stmt_pp}"
echo "    ERR: ${stmt_pp_err}"

mole_distance_report=`must_env_val "${env}" 'mole.distance.report-file-path'`
cat "${mole_distance_report}"
# TODO:
mole_dir=`must_get_mole_collect_dir "${env}" 'false'`
