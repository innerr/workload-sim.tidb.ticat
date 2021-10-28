set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

threads=`must_env_val "${env}" 'br-text.threads'`

dir=`must_env_val "${env}" 'br.backup-dir'`
src_dir="${dir}/sst2txt"
dest_dir="${dir}/txt2sst"

debug=`must_env_val "${env}" 'br-text.tikv.debug-build'`
echo "[:-] use debug build = '${debug}'"
rewrite_bin=`build_rewrite "${here}/../repos/tikv" "${debug}"`

if [ -e "${dest_dir}" ]; then
	echo rm -rf "${dest_dir}"
	rm -rf "${dest_dir}"
fi

mkdir -p "${dest_dir}"
echo "${rewrite_bin}" -t "${threads}" -i "local://${src_dir}" -o "local://${dest_dir}" text-to-sst
"${rewrite_bin}" -t "${threads}" -i "local://${src_dir}" -o "local://${dest_dir}" text-to-sst

echo "[:)] change 'br.backup-dir' to ${dest_dir}"
echo "br.backup-dir=${dest_dir}" >> "${env_file}"
