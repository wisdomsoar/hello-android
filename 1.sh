#!/bin/sh
/vendor/bin/qcarcam_test -config=/system/etc/loopback_test.xml &
sleep 8
screencap -p /data/local/tmp/1.png
cd /data/local/tmp/
STAT=`diff golden.png 1.png -s | grep identical`
if [ -z "$STAT" ]  ; then
	#
	echo "compare fail"
	#echo "host" > /sys/devices/platform/soc/a600000.ssusb/mode
else
	echo "compare good"	
fi

killall -9 qcarcam_test
