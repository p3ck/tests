#!/bin/sh

# Source the common test script helpers
. /usr/bin/rhts_environment.sh

function SysStats()
{
    # Collect some stats prior to running the test
    echo "***** System stats *****" >> $OUTPUTFILE
    vmstat >> $OUTPUTFILE
    echo "---" >> $OUTPUTFILE
    free -m >> $OUTPUTFILE
    echo "---" >> $OUTPUTFILE
    cat /proc/meminfo >> $OUTPUTFILE
    echo "---" >> $OUTPUTFILE
    cat /proc/slabinfo >> $OUTPUTFILE
    echo "***** System stats *****" >> $OUTPUTFILE

    logger -t USEXINFO -f $OUTPUTFILE 
}

# ---------- Start Test -------------
INFILE=rhtsusex.tcf
MYARCH=`uname -m`
if [ "$MYARCH" = "x86_64" -o "$MYARCH" = "s390x" ]  ; then
    ln -s /usr/lib64/libc.a /usr/lib/libc.a
fi

if [ -z "$OUTPUTDIR" ]; then                                                                                                                                 
    OUTPUTDIR=/mnt/testarea                                                                                                                                  
fi

#if ppc64 has less than or equal to 1 GB of memory don't run the vm tests
ONE_GB=1048576
if [ "$MYARCH" = "ppc64" ] ; then
    mem=`cat /proc/meminfo |grep MemTotal|sed -e 's/[^0-9]*\([0-9]*\).*/\1/'`
    test "$mem" -le "$ONE_GB" && INFILE=rhtsusex_lowmem.tcf
    logger -s "Running the rhtsusex_lowmem.tcf file"
fi

SysStats

./usex -i $INFILE -l $OUTPUTFILE --nodisplay -R $OUTPUTDIR/report.out

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
