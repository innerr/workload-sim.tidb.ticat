set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

## Dirs and defining files
#
conda_bin=`must_env_val "${env}" 'conda.bin'`
mole_dir="${here}/../../repos/mole"
conda_env_file="${mole_dir}/data-analysis/environment_linux.yml"
env_name=workload-sim

echo "${conda_bin}" env update "${env_name}" --file "${conda_env_file}"
"${conda_bin}" env update "${env_name}" --file "${conda_env_file}"

echo "[:)] updated conda environment: ${env_name}"
