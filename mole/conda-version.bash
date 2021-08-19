set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`

conda=`must_env_val "${env}" 'conda.bin'`

${conda} --version
