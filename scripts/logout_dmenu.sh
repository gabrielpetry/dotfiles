#!/bin/bash

# If the functions script does not exist,
# Fallback to a empety function
checkIfNetWork() {
   if ping google.com -c 1 -t 2; then
      # network down
      return 1
   fi
   return 1
}

logout_session() {
    i3-msg exit
}

lockscreen() {
    i3lock -i "$HOME/.config/wall.png"
}

restart_system() {
    reboot
}


options="Logout
Lockscreen
Restart
PowerOff"

selection=$(printf "$options"| dmenu )
case $selection in 
    "Logout")
       logout_session
       ;;
   "Lockscreen")
       lockscreen
       ;;
   "Restart")
       restart_system
       ;;
   "PowerOff")
        shutdown --poweroff now
       ;;
   *)
       notify-send "Error runnning command"
esac
