set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

threads=`must_env_val "${env}" 'br-text.threads'`

dir=`must_env_val "${env}" 'br.backup-dir'`
dest_dir="${dir}/sst2txt"

debug=`must_env_val "${env}" 'br-text.tikv.debug-build'`
echo "[:-] use debug build = '${debug}'"
rewrite_bin=`build_rewrite "${here}/../repos/tikv" "${debug}"`

if [ -e "${dest_dir}" ]; then
	echo rm -rf "${dest_dir}"
	rm -rf "${dest_dir}"
fi

echo "${rewrite_bin}" -t "${threads}" ToText "${dir}" "${dest_dir}"
"${rewrite_bin}" -t "${threads}" ToText "${dir}" "${dest_dir}"
