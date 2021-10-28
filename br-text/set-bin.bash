set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

bin=`build_br_t "${here}/../repos/tidb"`

echo "[:)] set 'br.bin' to ${bin}"
echo "br.bin=${bin}" >> "${env_file}"
