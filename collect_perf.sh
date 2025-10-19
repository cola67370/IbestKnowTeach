#!/bin/sh

PID=2470
OUT_FILE=/data/local/tmp/perf_data.txt
INTERVAL=1
DURATION=60  # 采样次数，可调整

echo "Start collecting performance data for PID $PID" > $OUT_FILE

i=0
while true
do
    if [ $i -ge $DURATION ]; then
        break
    fi

    echo "------ Sample $i ------" >> $OUT_FILE
    date >> $OUT_FILE
    top -p $PID -n 1 >> $OUT_FILE
    hidumper -s meminfo >> $OUT_FILE
    sleep $INTERVAL

    i=`busybox expr $i + 1 2>/dev/null`
    if [ -z "$i" ]; then
        i=$(($i + 1))  # 如果 busybox 不可用，用 shell 算术替代
    fi
done

echo "Data collection completed. Saved to $OUT_FILE" >> $OUT_FILE
