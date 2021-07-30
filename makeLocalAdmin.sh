#!/bin/sh
LOCAL_ADMIN_FULLNAME=""
LOCAL_ADMIN_SHORTNAME=""
LOCAL_ADMIN_PASSWORD=""

if [[ $LOCAL_ADMIN_SHORTNAME == `dscl . -list /Users UniqueID | awk '{print $1}' | grep $LOCAL_ADMIN_SHORTNAME` ]]; then
	echo "User already exists!"
	exit 0
fi

sysadminctl -addUser $LOCAL_ADMIN_SHORTNAME -fullName "$LOCAL_ADMIN_FULLNAME" -password "$LOCAL_ADMIN_PASSWORD" -home /var/$LOCAL_ADMIN_SHORTNAME -admin
sleep 5
createhomedir -c -u $LOCAL_ADMIN_SHORTNAME

echo "New user `dscl . -list /Users UniqueID | awk '{print $1}' | grep $LOCAL_ADMIN_SHORTNAME` has been created with unique ID `dscl . -list /Users UniqueID | grep $LOCAL_ADMIN_SHORTNAME | awk '{print $2}'`"
