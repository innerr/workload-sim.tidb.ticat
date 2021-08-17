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
		${make_cmd}
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
	build_bin "${dir}" 'bin/br' 'make br'
}

function build_tikv()
{
	local dir="${1}"
	local debug=`to_true "${2}"`
	if [ "${debug}" == 'true' ]; then
		build_bin "${dir}" 'target/release/tikv-server' 'make build'
	else
		build_bin "${dir}" 'target/debug/tikv-server' 'dist_release'
	fi
}
