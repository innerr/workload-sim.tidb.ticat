. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/ticat.helper.bash/helper.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/tiup.helper.bash/tiup.bash"

function check_cmd_date()
{
	if [ `uname` != 'Linux' ]; then
		echo "[:(] TODO: support date converting on '`uname`' platform (fmt: 1628900389 => 2021-08-16T12:44:09+08:00)" >&2
		exit 1
	fi
}

function to_time_str()
{
	local ts="${1}"
	check_cmd_date
	echo `date -d @"$ts" +%Y-%m-%dT%H:%M:%S%:z`
}
