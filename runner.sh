#! /bin/bash
# vim: set ts=4 sw=4 et :

SCRIPT=$(basename $0)
STD_WL_PATH=/usr/share/filebench/workloads

function usage() {
    cat - <<USAGE
Usage:
  $SCRIPT <personality> [commands ...]
    personality     A workload personality to load.
    commands        Commands to be run after the workload file is loaded.
                    This includes: overriding variables and issuing the
                    'run <time>' command.
USAGE
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

workload=$1
shift

combined_workload=$(mktemp --tmpdir filebench-XXXXXX.f)
echo "load $workload" >> $combined_workload
while [[ $# -gt 0 ]]; do
    echo "$1" >> $combined_workload
    shift
done

echo "Prepared composite workload file $combined_workload:"
cat $combined_workload
echo "Here we go..."

filebench -f $combined_workload

rm -f $combined_workload
