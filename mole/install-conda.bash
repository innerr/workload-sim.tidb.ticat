set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
env_file="${1}/env"

conda_dir=`must_env_val "${env}" 'conda.dir'`
conda_dir=`eval echo "${conda_dir}"`
conda="${conda_dir}/bin/conda"

echo "conda.bin=${conda}" >> "${env_file}"

if [[ -e "${conda}" ]]; then
  echo "miniconda already installed"
  exit 0
fi

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh
bash ./miniconda.sh -b -p "${conda_dir}"
