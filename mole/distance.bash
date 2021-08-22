set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

dir1="${1}"
dir2="${2}"

mole_dir="${here}/../repos/mole"
conda_bin=`get_conda "${env}"`

## TODO: the file path is not right
for f1 in "${dir1}"/*/*.csv; do
	for f2 in "${dir2}"/*/*.csv; do
		echo "[${f1}] vs [${f2}]:"
		"${conda_bin}" run \
			-n workload-sim \
			python3 "${mole_dir}/data-analysis/prom_metrics_feature_score.py" \
			-b "${f1}" -t "${f2}"
	done
done
