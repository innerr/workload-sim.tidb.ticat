set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

name=`must_env_val "${env}" 'tidb.cluster'`
pd=`must_cluster_pd "${name}"`

threads=`must_env_val "${env}" 'br.threads'`

tag=`must_env_val "${env}" 'tidb.backup.tag'`
dir_root=`must_env_val "${env}" 'br.backup-dir'`
dir="${dir_root}/br-t${tag}"

bin=`build_br_t "${here}/../../repos/br-text"`

checksum=`must_env_val "${env}" 'br.checksum'`
checksum=`to_true "${checksum}"`
if [ "${checksum}" == 'true' ]; then
	checksum=" "
else
	checksum=" --checksum=false"
fi

target=`env_val "${env}" 'br.target'`
if [ -z "${target}" ]; then
	target="full"
else
	target="db --db ${target}"
fi

echo "${bin}" restore ${target} --pd "${pd}" -s "${dir}" --check-requirements=false${checksum} --concurrency "${threads}"
"${bin}" restore ${target} --pd "${pd}" -s "${dir}" --check-requirements=false${checksum} --concurrency "${threads}"
