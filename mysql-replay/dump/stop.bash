set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

host=`must_env_val "${env}" 'my-rep.dump.host'`
dir=`must_env_val "${env}" 'my-rep.dump.dir'`

"${here}/../scripts/stop-remote-dump.sh" "${host}" "${dir}"
