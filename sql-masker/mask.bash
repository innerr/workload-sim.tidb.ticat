set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

func=`must_env_val "${env}" 'masker.func'`
db=`must_env_val "${env}" 'masker.db'`
ddl_dir=`must_env_val "${env}" 'masker.ddl-dir'`
threads=`must_env_val "${env}" 'masker.threads'`

store_dir=`must_env_val "${env}" 'my-rep.store.dir'`
input_dir="${store_dir}/events"
output_dir="${store_dir}/events.masked"
origin_dir="${store_dir}/events.original"

masker_bin=`build_masker "${here}/../repos/sql-masker"`

mkdir -p "${output_dir}"
echo "${masker_bin}" -d "${ddl_dir}" -m "${func}" event -i "${input_dir}" -o "${output_dir}"
"${masker_bin}" -d "${ddl_dir}" -m "${func}" event -i "${input_dir}" -o "${output_dir}"

echo mv "${input_dir}" "${origin_dir}"
mv "${input_dir}" "${origin_dir}"
echo mv "${output_dir}" "${input_dir}"
mv "${output_dir}" "${input_dir}"
