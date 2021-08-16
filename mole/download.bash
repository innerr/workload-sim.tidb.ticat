set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

## Args checking and handling
#
pd_user=`must_env_val "${env}" 'tidb.pd.user'`
pd_pwd=`env_val "${env}" 'tidb.pd.pwd'`
if [ ! -z "${pd_pwd}" ]; then
	pd_pwd="-p ${pd_pwd} "
fi
dir=`must_env_val "${env}" 'mole.dir'`
mkdir -p "${dir}"

metrics_yaml="${dir}/metrics.yaml"
if [ ! -f "${metrics_yaml}" ]; then
	if [ -f "${here}/metrics.yaml" ]; then
		metrics_yaml="${here}/metrics.yaml"
		echo "[:-] use default metrics.yaml"
	else
		echo "[:(] can't find metrics.yaml in dir: '${dir}'" >&2
		exit 1
	fi
fi

name=`must_env_val "${env}" 'tidb.cluster'`
begin=`must_env_val "${env}" 'bench.run.begin'`
end=`must_env_val "${env}" 'bench.run.end'`

begin=`to_time_str "${begin}"`
end=`to_time_str "${end}"`

pd_addr=`must_pd_addr "${name}"`
prom_addr=`must_prometheus_addr "${name}"`

## Build mole
#
(
	cd "${here}/../repos/mole"
	if [ ! -f "bin/mole" ]; then
		echo "[:(] can't find bin from build dir: mole" >&2
		exit 1
	fi
)
bin="${here}/../repos/mole/bin/mole"

## Download metrics
#
metrics="${bin} metrics \
	-H http://${prom_addr} \
	-o ""${dir}/metrics"" \
	-T ""${metrics_yaml}"" \
	-f=${begin} \
	-t=${end}"

echo "${metrics}"
echo "[:-] download metrics begin"
${metrics}
echo "[:)] download metrics done"

## Download heatmap
#
heatmap="${bin} keyviz \
	-H http://${pd_addr} \
	-o ""${dir}/heatmap"" \
	-u ${pd_user} \
	${pd_pwd}\
	-f=${begin} \
	-t=${end}"

echo "${heatmap}"
echo "[:-] download heatmap begin"
${heatmap}
echo "[:)] download heatmap done"
