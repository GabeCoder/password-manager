#!/bin/bash

cd "$HOME"/password-manager/.passwords
authentication() {
	password=$(cat .authentication)
	if userpass=$(zenity --password --title="Authentication")
	then
		if [ "$userpass" == "$password" ]
		then
			homescreen() {
				cd "$HOME"/password-manager
				yad --window-icon=icon.png --image=icon.png --title="Password Manager" --text="Welcome, "$USER". What do you want to do?" --button="Add Password":10 --button="Browse Passwords":20 --width=300 --height=300
				answer=$?
				cd .passwords
				if [ $answer == 10 ]
				then
					if username=$(zenity --entry --title="Username" --text="Type your username" --width=300)
					then
						username="${username// /_}"
						if password=$(zenity --password --title="Password")
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
		else
		zenity --error --text="Authentication failed, please try again." --width=300 &
		authentication
		fi
	fi
}
authentication
