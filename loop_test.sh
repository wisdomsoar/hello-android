for count in {1..20000};
do
  echo $count
  
  adb wait-for-device
  adb root
 
  adb logcat -s ais_server qcarcam_test > logcat_${count}.txt &

  sleep 200
  
  adb shell "/data/local/tmp/1.sh > /mnt/user/csi_result.txt"

  adb pull /mnt/user/csi_result.txt csi_result_${count}.txt
  
  grep "compare good" csi_result_${count}.txt
  if [ "$?" == "0" ]; then
      echo "$count: ok "
  else
      touch ${count}_NG.txt

      adb pull /data/local/tmp/1.png


  fi

  adb shell "dmesg > /data/local/tmp/dmesg.txt"

  adb pull /data/local/tmp/dmesg.txt dmesg.txt
  
  mv dmesg.txt dmesg${count}.txt
  
  adb shell "killall -9 logcat"

  adb reboot
done
