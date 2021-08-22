set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`

conda_dir=`must_env_val "${env}" 'conda.dir'`
conda_dir=`eval echo "${conda_dir}"`
conda="${conda_dir}/bin/conda"

"${conda}" --version
