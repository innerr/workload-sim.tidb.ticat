set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

host=`must_env_val "${env}" 'my-rep.dump.host'`
dir=`must_env_val "${env}" 'my-rep.dump.dir'`
network_interface=`must_env_val "${env}" 'my-rep.dump.ni'`

store_host=`must_env_val "${env}" 'my-rep.store.host'`
store_dir=`must_env_val "${env}" 'my-rep.store.dir'`
scripts_dir="${here}/../scripts"

"${scripts_dir}/start-remote-dump.sh" "${host}" "${dir}" "${network_interface}" "${store_host}" "${store_dir}" "${scripts_dir}"
