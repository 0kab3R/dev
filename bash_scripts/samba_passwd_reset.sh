#!/bin/bash

#
#samba must have tbdsam as passdb backend
#

getUsers() {
	echo -n "Enter the number of users who you want to change passwords at next logon: "
	read noUser
	for i in $noUser; do
		echo "Enter username # $i: "
		read user
		echo user >> users
	done
echo $users
}


#
#forces each user to change their password at their next login.
#
applyUsers(){
	loc_users=$(users)
	for i in $loc_users; do
		sudo pdbedit -u $i --force-initialized-passwords
	done
}

help(){
	echo "Usage:"
	echo
	echo "samba_passwd_reset [options d|p] [input]"
	echo
	echo "Options:"
	echo
	echo "-d "
	echo "use direct mode"
	echo "allows input of users directly as [input], useful for bulk updates"
	echo "Example usage: samba_passwd_reset -d user1 user2 user3 ..."
	echo
	echo "-p "
	echo "use prompt mode"
	echo "ignores [input] and prompts for users, useful if you have only a few users to update"
	echo "Example usage: samba_passwd_reset -p"
	echo
	echo "Input:"
	echo
	echo "For used with the -d option,"

}

#sudo pdbedit -u melissa --force-initialized-passwords
#sudo pdbedit -u dave --force-initialized-passwords
#sudo pdbedit -u ian --force-initialized-passwords
#sudo pdbedit -u jordan --force-initialized-passwords


if [[ $1 = "-d" and $2:]]; #if first input is -d then use direct mode and there are 2 or more inputs
	then
		users=$2: #variable users = input 2 - input infinity
		applyUsers #run applyUsers function
else if [[ $1 = "-p" ]]; #if first input is -p then use prompt mode, ignores if there are other inputs
	then
		users=getUsers #run the getUsers function and store output in users variable
		applyUsers #run applyUsers function
fi

#
#
#
