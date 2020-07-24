
adb wait-for-device
adb root
sleep 2 
adb remount
sleep 2 
adb root
sleep 2 
adb remount 
sleep 2


for count in {1..20000};
do
  echo $count
  current=`date "+%Y-%m-%d %H:%M:%S"`
  echo $current

  adb logcat -c
  adb logcat  > logcat_$count.txt &
  sleep 1
  adb shell "killall -9 ais_server"
  sleep 10
  #adb shell "ps -e|grep ais"
  #sleep 3
  #adb shell "ps -e|grep ais"
  #sleep 3
  #adb shell "ps -e|grep ais"
  #sleep 3

  adb shell "/data/local/tmp/1.sh |tee /mnt/user/csi_result.txt"
  adb pull /mnt/user/csi_result.txt csi_result_$count.txt  
  grep "compare good" csi_result_$count.txt
  if [ "$?" == "0" ]; then
      echo "$count: ok "
      #adb pull /data/local/tmp/1.png ./Sucss_desktop_$count.png
  else
      adb shell "dmesg > /data/local/tmp/dmesg.txt"
      adb pull /data/local/tmp/dmesg.txt dmesg.txt
      mv dmesg.txt Error_dmesg$count.txt
      touch ${count}_NG.txt
      adb pull /data/local/tmp/1.png ./Error_desktop_$count.png
	  cp logcat_$count.txt Error_logcat_$count.txt
  fi
  
  rm logcat_$count.txt
  
  
  adb shell "killall -9 logcat"
  sleep 2
done
