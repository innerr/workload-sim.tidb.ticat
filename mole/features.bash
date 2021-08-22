set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

dir=`must_env_val "${env}" 'mole.dir'`

input_dir="${dir}/metrics"
cal_dir="${dir}/calculating"
reshaped_dir="${cal_dir}/reshaped"
scores_dir="${cal_dir}/scores"

mole_dir="${here}/../repos/mole"
mole_bin=`build_mole "${mole_dir}"`
conda_bin=`get_conda "${env}"`

####

reshape_rules="${mole_dir}/example/reshape_rules.yaml"
echo "[:-] reshape begin"
for range_dir in "${input_dir}"/*; do
	range_name=`basename "${range_dir}"`
	echo "${range_name}:"
	if [ ! -e "${range_dir}" ]; then
		echo "[:(] dir not exists, skipped: '${range_dir}'" >&2
		continue
	fi
	"${mole_bin}" reshape \
		-i "${range_dir}" \
		-o "${reshaped_dir}/${range_name}" \
		--rule "${reshape_rules}"
done
echo "[:)] reshape done"

####

feature_function="${mole_dir}/data-analysis/example/feature_function.yaml"

echo
echo "[:-] calculate features begin"
for range_dir in "${input_dir}"/*; do
	range_name=`basename "${range_dir}"`
	echo "${range_name}:"
	scores_path="${scores_dir}/${range_name}/scores.csv"
	mkdir -p `dirname "${scores_path}"`
	if [ ! -e "${reshaped_dir}/${range_name}" ]; then
		echo "[:(] dir not exists, skipped: '${reshaped_dir}/${range_name}'" >&2
		continue
	fi
	"${conda_bin}" run -n workload-sim \
		python3 "${mole_dir}/data-analysis/prom_metrics_feature_score.py" \
		-f "${feature_function}" \
		-i "${reshaped_dir}/${range_name}" \
		-o "${scores_path}"
done
echo "[:)] calculate features done"
