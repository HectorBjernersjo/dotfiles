#!/bin/bash
for i in {1..3}; do paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga; done
zenity --warning --text="Time to stand up and do some squats!" --title="Squat Reminder" --width=600 --height=300
