set -euo pipefail

sql_result=''

function run_sql() {
	local sql="${1}"
	sql_result=`mysql -h "${host}" -P "${port}" -u "${user}" -e "${sql}" --vertical`
}

function run_sql_file() {
	local sql_file="${1}"
	sql_result=`cat "${sql_file}" | mysql -h "${host}" -P "${port}" -u "${user}" --vertical`
}

function check_contains() {
	if ! echo "${sql_result}" | grep -Fq "$1"; then
		echo "TEST FAILED: OUTPUT DOES NOT CONTAIN '$1'"
		echo "____________________________________"
		echo "${sql_result}"
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
		exit 1
	fi
}
