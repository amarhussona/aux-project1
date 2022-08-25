#!/bin/bash 

# Automating creation of new users on linux

userfile=$(cat names.csv)
PASSWORD=password

# To ensure the user running the script is a sudo user
	if [ $(id -u) -eq 0 ]; then
	
# Reading the csv file

		for user in $userfile;
		do
			echo $user
		if id "$user" &>/dev/null
		then
			echo "User Exist"
		else
		
# Create a new user
		useradd -m -d /home/$user -s /bin/bash -g developers $user
		echo "New User Created"
		echo

# Create a ssh folder in the user home folder 
		su - -c "mkdir ~/.ssh" $user
		echo ".ssh directory created for new user"
		echo
		
# Set user permission for the ssh directory
		su - -c "chmod 700 ~/.ssh" $user
		echo "user permission for .ssh directory set"
		echo

# Create an authorized-key file
		su - -c "touch ~/.ssh/authorized_keys" $user
		echo "Authorized key file created"
		echo

# Set permission for the key file
		su - -c "chmod 600 ~/.ssh/authorized_keys" $user
		echo "user permission for the authorized key file set"
		echo
		
# Create and set public key for users in the server
		cp -R "/home/ubuntu/Shell/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
		echo "Copied the public key to new user account on the server"
		echo
		echo
		
		echo "USER CREATED"
# Generate a password
		sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user"
		sudo passwd -x 5 $user
			fi
		done
	else
	echo "Only Admin can onboard a new user"
	fi