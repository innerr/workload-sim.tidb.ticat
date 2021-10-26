set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

threads=`must_env_val "${env}" 'br-text.threads'`

dir=`must_env_val "${env}" 'br.backup-dir'`
dest_dir="${dir}/sst2csv"

debug=`must_env_val "${env}" 'br-text.tikv.debug-build'`
echo "[:-] use debug build = '${debug}'"
rewrite_bin=`build_rewrite "${here}/../repos/tikv" "${debug}"`

if [ -e "${dest_dir}" ]; then
	echo rm -rf "${dest_dir}"
	rm -rf "${dest_dir}"
fi

mkdir -p "${dest_dir}"
echo "${rewrite_bin}" -t "${threads}" -i "local://${dir}" -o "local://${dest_dir}" sst-to-csv --copy-schema-sql
"${rewrite_bin}" -t "${threads}" -i "local://${dir}" -o "local://${dest_dir}" sst-to-csv --copy-schema-sql

echo "[:)] set 'lightning.data-source-dir' to ${dest_dir}"
echo "lightning.data-source-dir=${dest_dir}" >> "${env_file}"
