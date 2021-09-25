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
mole_bin=`build_mole "${mole_dir}"`
conda_bin=`get_conda "${env}"`

f1s=`find "${dir1}" -name heatmap`
if [ -z "${f1s}" ]; then
	echo "[:(] can't find heatmap dir in ${dir1}" >&2
	exit 1
fi
"${mole_bin}" split -i "${f1s}" -o "${f1s}/csv"

f2s=`find "${dir2}" -name heatmap`
if [ -z "${f2s}" ]; then
	echo "[:(] can't find heatmap dir in ${dir2}" >&2
	exit 1
fi
"${mole_bin}" split -i "${f2s}" -o "${f2s}/csv"

echo "${f1s}" | while read f1; do
	echo "${f2s}" | while read f2; do
		echo "--- distance (heatmap) ---"
		echo "heatmap: ${f1}/csv"
		echo "heatmap: ${f2}/csv"
		echo "${conda_bin}" run -n workload-sim python3 "${mole_dir}/data-analysis/heatmap_feature_distance.py" -b "${f1}/csv" -t "${f2}/csv" -o "${output_path}"
		"${conda_bin}" run \
			-n workload-sim \
			python3 "${mole_dir}/data-analysis/heatmap_feature_distance.py" \
			-b "${f1}/csv" -t "${f2}/csv" -o "${output_path}"
		cat "${output_path}"
	done
done

if [ "${output_path}" != '/dev/null' ]; then
	echo "mole.heatmap.distance.report-file-path=${output_path}" >> "${env_file}"
fi
