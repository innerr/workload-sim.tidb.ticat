set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

if [ ! -z "${1+x}" ]; then
	tikv_bin="${1}"
fi
if [ -z "${tikv_bin}" ]; then
	debug=`must_env_val "${env}" 'br-text.tikv.debug-build'`
	tikv_bin=`build_tikv "${here}/../repos/tikv" "${debug}"`
else
	tikv_bin="${1}"
fi

if [ ! -f "${tikv_bin}" ]; then
		echo "[:(] can't find built tikv bin '${tikv_bin}'" >&2
		exit 1
fi

origin=`must_env_val "${env}" 'tidb.version'`
raw="${origin%%+*}"
patched="${raw}+${tikv_bin}"

if [ "${patched}" != "${origin}" ]; then
	if [ "${raw}" != "${origin}" ]; then
		echo "[:(] can't patch tidb.version string '${origin}', it has local dir info" >&2
		exit 1
	else
		echo "tidb.version=${patched}" >> "${env_file}"
		echo "[:)] tidb.version '${origin}' => '${patched}'" >&2
	fi
fi
