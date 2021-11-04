set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

func=`must_env_val "${env}" 'sql-masker.mask.func'`
db=`must_env_val "${env}" 'sql-masker.mask.db'`
ddl_dir=`must_env_val "${env}" 'sql-masker.mask.ddl-dir'`
name_map=`env_val "${env}" 'sql-masker.mask.name-map'`

store_dir=`must_env_val "${env}" 'my-rep.store.dir'`
input_dir="${store_dir}/events"
output_dir="${store_dir}/events.masked"
origin_dir="${store_dir}/events.original"

mask_log_file="${store_dir}/mask.log"
echo "sql-masker log will be at ${mask_log_file}"

masker_bin=`build_masker "${here}/../repos/sql-masker"`

mkdir -p "${output_dir}"
echo "${masker_bin}" -d "${ddl_dir}" --db "${db}" -n "${name_map}" -m "${func}" -v event -i "${input_dir}" -o "${output_dir}"
"${masker_bin}" -d "${ddl_dir}" --db "${db}" -n "${name_map}" -m "${func}" -v event -i "${input_dir}" -o "${output_dir}" 2>&1 | tee "${mask_log_file}" | { grep -v "warn" || true; }

echo mv "${input_dir}" "${origin_dir}"
mv "${input_dir}" "${origin_dir}"
echo mv "${output_dir}" "${input_dir}"
mv "${output_dir}" "${input_dir}"

line=`cat "${mask_log_file}" | grep 'all done' | tail -n 1`
if [ -z "${line}" ]; then
	echo "[:(] mask failed, log: '${mask_log_file}'" >&2
	exit 1
fi
stats=`echo "${line}" | awk -F "\t" '{print $NF}'`

echo "sql-masker.mask.stats=${stats}" >> "${env_file}"
