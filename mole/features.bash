set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

###

dir=`must_get_mole_collect_dir "${env}" 'true'`

input_dir="${dir}/metrics"
cal_dir="${dir}/calculating"
reshaped_dir="${cal_dir}/reshaped"
scores_path="${cal_dir}/scores.csv"

mole_dir="${here}/../repos/mole"
mole_bin=`build_mole "${mole_dir}"`
conda_bin=`get_conda "${env}"`

###

reshape_rules="${mole_dir}/example/reshape_rules.yaml"
echo "[:-] reshape begin"
"${mole_bin}" reshape \
	-i "${input_dir}" \
	-o "${reshaped_dir}" \
	--rule "${reshape_rules}"
echo "[:)] reshape done"

####

feature_function="${mole_dir}/data-analysis/example/feature_function.yaml"

echo
echo "[:-] calculate features begin"
"${conda_bin}" run -n workload-sim \
	python3 "${mole_dir}/data-analysis/prom_metrics_feature_score.py" \
	-f "${feature_function}" \
	-i "${reshaped_dir}" \
	-o "${scores_path}"
echo "[:)] calculate features done"
