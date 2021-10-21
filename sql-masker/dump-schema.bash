set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

host=`must_env_val "${env}" 'mysql.host'`
port=`must_env_val "${env}" 'mysql.port'`
user=`must_env_val "${env}" 'mysql.user'`
db=`must_env_val "${env}" 'masker.db'`

store_dir=`must_env_val "${env}" 'my-rep.store.dir'`
ddl_dir="${store_dir}/ddl"
output_file="${ddl_dir}/schema-${db}.sql"

mkdir -p "${ddl_dir}"
echo mysqldump -h "${host}" -P "${port}" -u "${user}" -p --no-data "${db}"
mysqldump -h "${host}" -P "${port}" -u "${user}" -p --no-data "${db}" > "${output_file}"

echo "[:)] change 'masker.ddl-dir' to ${ddl_dir}"
echo "masker.ddl-dir=${ddl_dir}" >> "${env_file}"
