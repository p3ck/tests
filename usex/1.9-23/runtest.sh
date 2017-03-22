#!/bin/sh

# Source the common test script helpers
. /usr/bin/rhts_environment.sh

function SysStats()
{
    # Collect some stats prior to running the test
    echo "***** System stats *****"
    vmstat >> $OUTPUTFILE
    echo "---" >> $OUTPUTFILE
    free -m >> $OUTPUTFILE
    echo "---" >> $OUTPUTFILE
    cat /proc/meminfo >> $OUTPUTFILE
    echo "***** System stats *****"
}

# ---------- Start Test -------------
MYARCH=`uname -m`
if [ "$MYARCH" = "x86_64" -o "$MYARCH" = "s390x" ]  ; then
    ln -s /usr/lib64/libc.a /usr/lib/libc.a
fi

SysStats

./usex -i rhtsusex.tcf -l $OUTPUTFILE --nodisplay -R $OUTPUTDIR/report.out

SysStats

# Default result to FAIL
export result="FAIL"

# Then post-process the results to find the regressions
export fail=`cat $OUTPUTDIR/report.out | grep "USEX TEST RESULT: FAIL" | wc -l`

if [ "$fail" -gt "0" ]  ; then
    export result="FAIL"
else
    export result="PASS"
fi

report_result $TEST $result $fail
