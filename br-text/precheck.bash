set -euo pipefail

here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../helper/helper.bash"

env_file="${1}/env"
env=`cat "${env_file}"`
shift

dir=`must_env_val "${env}" 'br.backup-dir'`
dest_dir="${dir}/csv2sst"
src_dir="${dir}/sst2csv"

br_bin=`build_br_t "${here}/../repos/tidb"`

echo "[:)] setup br.bin=${br_bin}"
echo "br.bin=${br_bin}" >> "${env_file}"
