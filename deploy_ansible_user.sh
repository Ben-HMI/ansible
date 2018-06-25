#!/bin/bash


user=ansible
password=LkLe1VjTqQCGtw2SE2pp
UID_ROOT=0

function ansible_user()
{

   if [ $UID -ne $UID_ROOT ]
   then 
      echo "you must be root for execute this script "
      exit 1 

   fi 

# " check if ansible user exists on the system "
   cat /etc/passwd | grep -wq  "ansible"
   RE=$?
   if [ $RE -eq "1" ]
   then 
   echo " user " $user "not present in /etc/passwd"
   echo  $user "will be create"
   useradd $user -p $password -s /bin/bash -m
   id $user 2>> /dev/null
   ID=$?
   test $ID -eq 0 && echo "user" $user "is added "
   
   exit 0
   else
   echo "user" $user "is already exists on this system"
    exit 0
   fi


}

ansible_user

