set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

dir=`must_env_val "${env}" 'br.backup-dir'`
origin=`must_env_val "${env}" 'tidb.version'`
raw="${origin%%+*}"
patched="${raw}+${dir}"

if [ "${patched}" != "${origin}" ]; then
	if [ "${raw}" != "${origin}" ]; then
		echo "[:(] can't patch tidb.version string '${origin}', it has local dir info" >&2
		exit 1
	else
		echo "tidb.version=${patched}" >> "${env_file}"
		echo "[:)] tidb.version '${origin}' => '${patched}'" >&2
	fi
fi
