set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

session="${1}"
env=`cat "${session}/env"`
shift

host=`must_env_val "${env}" 'my-rep.store.host'`
dir=`must_env_val "${env}" 'my-rep.store.dir'`
dsn=`must_env_val "${env}" 'my-rep.replay.dsn'`

scripts_dir="${here}/scripts"
log="${session}/my-rep.replay.log"

"${scripts_dir}/remote-replay.sh" "${host}" "${dir}" "${dsn}" "${scripts_dir}" | tee "${log}" | grep -v WARN

line=`cat "${log}" | grep 'done' | tail -n 1`
if [ -z "${line}" ]; then
	echo "[:(] replay failed, log: '${log}'" >&2
	exit 1
fi

# Result sample: ... {"connections": 0, "conn.running": 0, "conn.waiting": 0, "queries": 43513, "stmt.executes": 273027, "stmt.prepares": 63, "err.queries": 0, "err.stmt.executes": 0, "err.stmt.prepares": 99}"

function json_val()
{
	local line="${1}"
	local key="${2}"
	echo "${line}" | awk -F "${key}" '{print $2}' | awk '{print $2}' | awk -F ',' '{print $1}' | awk -F '}' '{print $1}'
}

q_g=`json_val "${line}" 'queries'`
q_e=`json_val "${line}" 'err.queries'`
echo "my-rep.rep.queries=${q_g}" >> "${session}/env"`
echo "my-rep.rep.queries.err=${q_e}" >> "${session}/env"`

st_g=`json_val "${line}" 'stmt.executes'`
st_e=`json_val "${line}" 'err.stmt.executes'`
echo "my-rep.rep.stmt.exe=${st_g}" >> "${session}/env"`
echo "my-rep.rep.stmt.exe.err=${st_e}" >> "${session}/env"`

sp_g=`json_val "${line}" 'stmt.prepares'`
sp_e=`json_val "${line}" 'err.stmt.prepares'`
echo "my-rep.rep.stmt.prepares=${sp_g}" >> "${session}/env"`
echo "my-rep.rep.stmt.prepares.err=${sp_e}" >> "${session}/env"`
