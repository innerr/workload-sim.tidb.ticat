. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/ticat.helper.bash/helper.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/tiup.helper.bash/tiup.bash"

function check_cmd_date()
{
	if [ `uname` != 'Linux' ] && [ `uname` != 'Darwin' ]; then
		echo "[:(] TODO: support date converting on '`uname`' platform (fmt: 1628900389 => 2021-08-16T12:44:09+08:00)" >&2
		exit 1
	fi
}

function to_time_str()
{
	local ts="${1}"
	local fmt="+%Y-%m-%dT%H:%M:%S%:z"
	check_cmd_date
	if [ `uname` == 'Linux' ] ; then
		echo `date -d @"${ts}" "${fmt}"`
	else
		echo `date -r "${ts}" "${fmt}"`
	fi
}

function build_bin()
{
	local dir="${1}"
	local bin_path="${2}"
	local make_cmd="${3}"
	(
		cd "${dir}"
		if [ -f "${bin_path}" ]; then
			echo "[:)] found pre-built '${bin_path}' in build dir: '${dir}'" >&2
			return
		fi
		${make_cmd} 1>&2
		if [ ! -f "${bin_path}" ]; then
			echo "[:(] can't build '${bin_path}' from build dir: '${dir}'" >&2
			exit 1
		fi
	)
	echo "${dir}/${bin_path}"
}

function build_mole()
{
	local dir="${1}"
	build_bin "${dir}" 'bin/mole' 'make'
}

function build_br_t()
{
	local dir="${1}"
	build_bin "${dir}" 'bin/br' 'make build_br'
}

function build_rewrite()
{
	local dir="${1}"
	local debug=`to_true "${2}"`
	if [ "${debug}" == 'true' ]; then
		build_bin "${dir}" 'target/debug/rewrite' 'cargo build --package backup_text'
	else
		build_bin "${dir}" 'target/release/rewrite' 'cargo build --package backup_text --release'
	fi
}

function build_masker()
{
	local dir="${1}"
	build_bin "${dir}" 'bin/sql-masker' 'make'
}

function build_tikv()
{
	local dir="${1}"
	local debug=`to_true "${2}"`
	if [ "${debug}" == 'true' ]; then
		build_bin "${dir}" 'target/debug/tikv-server' 'make build'
	else
		build_bin "${dir}" 'target/release/tikv-server' 'make dist_release'
	fi
}

function get_conda()
{
	local env="${1}"
	local conda_dir=`must_env_val "${env}" 'conda.dir'`
	# TODO: test all platforms
	local conda_dir=`eval echo "${conda_dir}"`
	echo "${conda_dir}/bin/conda"
}

function get_metrics_yaml()
{
	local env="${1}"
	local default_path="${2}"

	local yaml=`env_val "${env}" 'mole.metrics'`
	if [ -z "${yaml}" ]; then
		local yaml="${default_path}"
		echo "[:-] use default metrics yaml file '${yaml}'" >&2
	fi

	if [ ! -f "${yaml}" ]; then
		echo "[:(] can't find metrics yaml file '${yaml}'" >&2
		exit 1
	fi

	echo "${yaml}"
}

function must_get_mole_collect_dir()
{
	local env=""${1}
	local search_exists=`to_true "${2}"`

	local dir=`must_env_val "${env}" 'mole.dir'`
	local bench_tag=`must_env_val "${env}" 'bench.tag'`
	local data_tag=`must_env_val "${env}" 'tidb.data.tag'`
	local dir="${dir}/${data_tag}+${bench_tag}"

	if [ ! -e "${dir}" ]; then
		if [ "${search_exists}" == 'true' ]; then
			echo "[:(] collected data dir '${dir}' not exists, try use parent dir"
			local dir=`dirname ${dir}`
		else
			mkdir -p "${dir}"
		fi
	fi
	if [ ! -d "${dir}" ]; then
		echo "[:(] dir '${dir}' not exists" >&2
		exit 1
	fi
	echo "${dir}"
}
