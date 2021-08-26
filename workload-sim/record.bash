set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

bench_begin=`must_env_val "${env}" 'bench.begin'`

backup_begin=`must_env_val "${env}" 'br-t.backup.begin'`
backup_end=`must_env_val "${env}" 'br-t.backup.end'`
restore_begin=`must_env_val "${env}" 'br-t.restore.begin'`
restore_end=`must_env_val "${env}" 'br-t.restore.end'`

run_begin=`must_env_val "${env}" 'bench.run.begin'`
run_end=`must_env_val "${env}" 'bench.run.end'`
replay_begin=`must_env_val "${env}" 'my-rep.rep.begin'`
replay_end=`must_env_val "${env}" 'my-rep.rep.end'`

queries=`must_env_val "${env}" 'my-rep.rep.queries'`
queries_err=`must_env_val "${env}" 'my-rep.rep.queries.err'`
stmt=`must_env_val "${env}" 'my-rep.rep.stmt.exe'`
stmt_err=`must_env_val "${env}" 'my-rep.rep.stmt.exe.err'`
stmt_pp=`must_env_val "${env}" 'my-rep.rep.stmt.prepares'`
stmt_pp_err=`must_env_val "${env}" 'my-rep.rep.stmt.prepares.err'`

mole_dir=`must_get_mole_collect_dir "${env}" 'false'`
