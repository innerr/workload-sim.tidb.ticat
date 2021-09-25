set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

###

dir1="${1}"
if [ -z "${dir1}" ] || [ ! -d "${dir1}" ]; then
	echo "[:(] dir '${dir1}' not exists" >&2
	exit 1
fi
dir2="${2}"
if [ -z "${dir2}" ] || [ ! -d "${dir2}" ]; then
	echo "[:(] dir '${dir2}' not exists" >&2
	exit 1
fi
output_path="${3}"
if [ -z "${output_path}" ]; then
	output_path='/dev/null'
else
	mkdir -p `dirname "${output_path}"`
fi

###

mole_dir="${here}/../repos/mole"
conda_bin=`get_conda "${env}"`

f1s=`find "${dir1}" -name scores.csv`
f2s=`find "${dir2}" -name scores.csv`

echo "${f1s}" | while read f1; do
	echo "${f2s}" | while read f2; do
		echo "--- distance (data + performance) ---"
		echo "feature set: ${f1}"
		echo "feature set: ${f2}"
		"${conda_bin}" run \
			-n workload-sim \
			python3 "${mole_dir}/data-analysis/prom_metrics_feature_score_distance.py" \
			-b "${f1}" -t "${f2}" | tee "${output_path}"
	done
done

if [ "${output_path}" != '/dev/null' ]; then
	echo "mole.distance.report-file-path=${output_path}" >> "${env_file}"
fi
