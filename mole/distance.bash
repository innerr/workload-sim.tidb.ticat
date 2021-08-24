set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
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

###

mole_dir="${here}/../repos/mole"
conda_bin=`get_conda "${env}"`

f1s=`find "${dir1}" -name scores.csv`
f2s=`find "${dir2}" -name scores.csv`

echo "${f1s}" | while read f1; do
	echo "${f2s}" | while read f2; do
		echo "--- distance ---"
		echo "feature set: ${f1}"
		echo "feature set: ${f2}"
		"${conda_bin}" run \
			-n workload-sim \
			python3 "${mole_dir}/data-analysis/prom_metrics_feature_score_distance.py" \
			-b "${f1}" -t "${f2}"
	done
done
