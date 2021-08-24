set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"
. "${here}/helper.bash"

env=`cat "${1}/env"`

host=`must_env_val "${env}" 'mysql.host'`
port=`must_env_val "${env}" 'mysql.port'`
user=`must_env_val "${env}" 'mysql.user'`

run_sql 'DROP DATABASE IF EXISTS vt;'
run_sql_file "${here}/load.sql"
