set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

tag=`must_env_val "${env}" 'tidb.data.tag'`
dir_root=`must_env_val "${env}" 'br.backup-dir'`

dir="${dir_root}/${tag}"
dir_text="${dir_root}/rewrite-text${tag}"

debug=`must_env_val "${env}" 'br-text.tikv.debug-build'`
echo "[:-] use debug build = '${debug}'"
rewrite_bin=`build_rewrite "${here}/../repos/tikv" "${debug}"`

echo rm -rf "${dir_text}"
rm -rf "${dir_text}"
echo "${rewrite_bin}" "${dir}" "${dir_text}"
"${rewrite_bin}" "${dir}" "${dir_text}"

echo rm -rf "${dir}"
rm -rf "${dir}"
echo "${rewrite_bin}" "${dir_text}" "${dir}"
"${rewrite_bin}" "${dir_text}" "${dir}"
