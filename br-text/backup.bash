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

tag=`must_env_val "${env}" 'tidb.backup.tag'`
dir_root=`must_env_val "${env}" 'br.backup-dir'`
dir="${dir_root}/br-t${tag}"

skip_exist=`must_env_val "${env}" 'tidb.backup.skip-exist'`
skip_exist=`to_true "${skip_exist}"`

## Handle existed data
#
if [ -f "${dir}/backupmeta" ]; then
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

bin=`build_br_t "${here}/../repos/br-text"`

# TODO: get user name from tiup
mkdir -p "${dir}" && chown -R tidb:tidb "${dir}"

"${bin}" backup full --pd "${pd}" -s "${dir}" --check-requirements=false --concurrency "${threads}"
