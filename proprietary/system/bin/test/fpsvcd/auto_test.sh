#!/system/bin/sh

play_event=/system/bin/play_event
record_frame=/system/bin/record_frame
logfile=/data/log/silead_`date +%s`.log

mkdir -p /data/log
rm $logfile

silead_log()
{
  # echo  $1 >>$logfile
   echo  $1
}
toggle_power_key()
{
    sendevent /dev/input/event2 1 353 1
    sendevent /dev/input/event2 0 0 0 
    sendevent /dev/input/event2 1 353 0
    sendevent /dev/input/event2 0 0 0 
    silead_log "toggle power key"
}

lcd_stats()
{
   screen=`dumpsys power| grep "mScreenOn=false"`
   
   if [ "$screen" = "" ];then
       silead_log "screen on"
       return 1
   fi 

   silead_log "screen off"
   return 0
}

wait_for_booted()
{
    while true
    do
        boot_done=`dmesg| grep "acc_release"` 
        boot_done=($boot_done)
        boot_done=${boot_done[2]}
        if [ "$boot_done" != "" ];then
            silead_log bootdone
            return 1
        fi
        sleep 1
    done
}
is_enter_destop()
{
    destop=`logcat -d |grep "ACTION_USER_PRESENT"`
    if [ "$destop" != "" ];then
        return 1
    fi
    return 0
}
run_fingerprint_unlock()
{
# first fingerprint unlock
   silead_log "unlock by fingerprint"

   lcd_stats
   if [ $? = 1 ]; then
      toggle_power_key
      toggle_power_key
      toggle_power_key
   fi

  #for T in $(seq 5); do
  #      echo  "next $T"
  #      lcd_stats
  #      if [ $? = 0 ]; then
  #         toggle_power_key
  #      #else
  #      #   toggle_power_key
  #      #   toggle_power_key
  #      fi
  #      $record_frame -f
  #done
  #is_enter_destop 
  #if [ $? = 0 ]; then
  #    silead_log " Not enter destop"
  #    run_password_unlock
  #fi
   for T in $(seq 20); do
       #for i in `ls /data/local/tmp/silead_frame_*.dat`; do
       for i in $(seq 24); do
            while true; do
              lcd_stats
              if [ $? = 0 ]; then
                 toggle_power_key
              fi
              if [ ! -f "/data/local/tmp/lock_frame" ]; then
                  cp /data/local/tmp/silead_frame_$i.dat /data/local/tmp/silead_frame.dat
                 # touch /data/local/tmp/lock_frame
                  break
              fi
            done 
       done
   done
   is_enter_destop 
   if [ $? = 0 ]; then
       silead_log " Not enter destop"
       run_password_unlock
   fi
}



run_password_unlock()
{
    silead_log "start password unlock"
    
    lcd_stats
    if [ $? = 1 ]; then
       toggle_power_key
    fi
    for i in $(seq 10); do
        lcd_stats
        if [ $? = 1 ]; then
           $play_event /data/temp  >/dev/null
        fi
           toggle_power_key
        sleep 1
    done

    lcd_stats
    if [ $? = 0 ]; then
       toggle_power_key
    fi
    $play_event /data/temp  >/dev/null
}

wait_for_booted
sleep 3

tee=`date +%s`
((run_times=$tee%10+10))
for i in $(seq $run_times); do
    tee=`date +%s`
    ((var=$tee%2))
    echo times=$i,$var
    if [ $var = 1 ];then
       silead_log "start password unlock"
       run_fingerprint_unlock
       #run_password_unlock
       silead_log "end password unlock"
    else
       silead_log "start fingerprint unlock"
       run_fingerprint_unlock
       silead_log "end fingerprint unlock"
    fi
done
reboot 
