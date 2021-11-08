set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

dir=`must_env_val "${env}" 'br.backup-dir'`
store_dir=`must_env_val "${env}" 'my-rep.store.dir'`

output="${store_dir}/name-map.json"
echo "name map will be stored at ${output}"

masker_bin=`build_masker "${here}/../repos/sql-masker"`

echo "${masker_bin}" -d "${dir}" name -o "${output}"
"${masker_bin}" -d "${dir}" name -o "${output}"

echo "sql-masker.mask.name-map=${output}" >> "${env_file}"
