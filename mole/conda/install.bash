set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`

conda_dir=`must_env_val "${env}" 'conda.dir'`
conda_dir=`eval echo "${conda_dir}"`
conda="${conda_dir}/bin/conda"

echo "conda.bin=${conda}" >> "${env_file}"

if [[ -e "${conda}" ]]; then
	ver=`"${conda}" --version`
	echo "[:)] miniconda already installed, version: ${ver}"
	exit 0
fi

mc_path="${here}/miniconda.sh"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "${mc_path}"
bash "${mc_path}" -b -p "${conda_dir}"
