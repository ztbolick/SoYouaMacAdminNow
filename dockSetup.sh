#!/usr/bin/env bash
# This script will add applications you pass as arguments
# If you pass no arguments and set no vareables
# IT WILL CLEAR THE DOCK
# If you pass a ";" seperated list it will add those items

# GLOBAL VARS
dockUtil="/usr/local/bin/dockutil"
APPLICATIONS="Google Chrome;TextEdit"

if [[ $1 ]]; then
	APPLICATIONS=$1
else
	IFS=';' read -ra dockItems <<<"$APPLICATIONS"
fi

## DockUtil
## Check for DockUtil and install it if not found
checkDockUtil() {
	if [[ -e "$dockUtil" ]]; then
		return
	else
		for ((i = 0; i < 3; i++)); do
			echo "Trying do download..."
			echo "Attempt $i"
			curl -L "https://download1490.mediafire.com/igawb0vorz7g/luk9ef9eico8twh/cocoaDialog_3.pkg" -o "/private/tmp/dockutil.pkg"
			installer -pkg "/private/tmp/dockutil.pkg" -target /
			sleep 5
		done
	fi
}

getUsers() {
	nonServiceUsers=$(dscl . list /Users | grep -v '^_')
	usersWithHomes=$(ls /Users)
}

setupDock() {
	for user in ${usersWithHomes[@]}; do
		if [[ "$nonServiceUsers" =~ "$user" ]]; then
			userHome=/Users/$user
			
			$dockUtil --remove all --no-restart "$userHome"

			for dockItem in "${dockItems[@]}"; do
				$dockUtil --add "/Applications/$dockItem.app" --no-restart "$userHome"
			done
		fi
	done
}

killall cfprefsd
sleep 3
checkDockUtil
getUsers
setupDock
killall Dock
