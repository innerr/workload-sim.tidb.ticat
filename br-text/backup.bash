set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env=`cat "${1}/env"`
shift

## Handle args
#
name=`must_env_val "${env}" 'tidb.cluster'`
pd=`must_cluster_pd "${name}"`

threads=`must_env_val "${env}" 'br.threads'`

tag=`must_env_val "${env}" 'tidb.data.tag'`
dir_root=`must_env_val "${env}" 'br.backup-dir'`
dir="${dir_root}/br-t${tag}"

skip_exist=`must_env_val "${env}" 'tidb.backup.skip-exist'`
skip_exist=`to_true "${skip_exist}"`

checksum=`must_env_val "${env}" 'br.checksum'`
checksum=`to_true "${checksum}"`
if [ "${checksum}" == 'true' ]; then
	checksum=" "
else
	checksum=" --checksum=false"
fi

target=`env_val "${env}" 'br.target'`
if [ -z "${target}" ] || [ "${target}" == '-full' ] || [ "${target}" == '--full' ]; then
	target="full"
else
	target="db --db ${target}"
fi

## Handle existed data
#
if [ -f "${dir}/backup.lock" ]; then
	if [ "${skip_exist}" == 'true' ]; then
		echo "[:-] '${dir}' data exist, skipped"
		exit 0
	else
		if [ -z "${dir_root}" ]; then
			echo "[:(] assert failed, '${dir}' not right"
			exit 1
		fi
		echo "[:-] '${dir}' data exist, removing"
		rm -rf "${dir}"
	fi
fi

bin=`build_br_t "${here}/../repos/tidb"`

# TODO: get user name from tiup
mkdir -p "${dir}" && chown -R tidb:tidb "${dir}"

#echo "${bin}" backup ${target} --pd "${pd}" -s "${dir}" --check-requirements=false${checksum} --concurrency "${threads}"
#"${bin}" backup ${target} --pd "${pd}" -s "${dir}" --check-requirements=false${checksum} --concurrency "${threads}"

echo "${bin}" backup ${target} --pd "${pd}" -s "${dir}" --check-requirements=false${checksum}
"${bin}" backup ${target} --pd "${pd}" -s "${dir}" --check-requirements=false${checksum}
