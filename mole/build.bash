set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

mole_bin=`build_mole "${here}/../repos/mole"`
echo "[:)] mole bin: ${mole_bin}"
