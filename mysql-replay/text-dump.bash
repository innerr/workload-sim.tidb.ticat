set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

session="${1}"
env=`cat "${session}/env"`
shift

host=`must_env_val "${env}" 'my-rep.store.host'`
dir=`must_env_val "${env}" 'my-rep.store.dir'`

scripts_dir="${here}/scripts"
log="${session}/my-rep.text-dump.log"

"${scripts_dir}/remote-text-dump.sh" "${host}" "${dir}" "${scripts_dir}" | tee "${log}" | grep -v WARN

line=`cat "${log}" | grep 'done' | tail -n 1`
if [ -z "${line}" ]; then
	echo "[:(] text-dump failed, log: '${log}'" >&2
	exit 1
fi
