#!/bin/bash

homename=$(basename "$HOME")
homescreen() {
	cd "$HOME"/password-manager
	yad --window-icon=icon.png --image=icon.png --title="Password Manager" --text="Welcome, $homename. What do you want to do?" --button="Add Password":10 --button="Browse Passwords":20 --width=300 --height=300
	answer=$?
	cd "$HOME"/.passwords
	if [ $answer == 10 ]
	then
		if username=$(zenity --entry --title="Username" --text="Type your username" --width=300)
		then
			username="${username// /_}"
			if password=$(zenity --password --title="Password" --width=300)
			then
				echo "$password" > "$username"
				zenity --info --icon-name=emblem-default --title="Success" --text="$username's password has been added." --width=300 &
			fi
		fi
		homescreen
	elif [ $answer == 20 ]
	then
		list() {
			list=$(ls -Q)
			username=$(yad --list --title="Passwords" --window-icon="$HOME"/password-manager/icon.png --no-headers --column="Username" ${list//'"'} --button="Back":10 --button="Reveal Password":20 --button="Delete Password":30 --height=300)
			answer=$?
			if [ $answer == 10 ]
			then
				homescreen
			elif [ $answer == 20 ]
			then
				password=$(cat "${username//|}")
				list &
				sleep 1
				zenity --info --title="Password" --text="$password" --width=300 &
			elif [ $answer == 30 ]
			then
				unlink "${username//|}"
				list &
				sleep 1
				zenity --info --icon-name=emblem-default --title="Success" --text="${username//|}'s password has been deleted." --width=300
			fi
		}
		list
	fi
}
homescreen
