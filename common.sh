#!/bin/sh

if [[ "x$PROJECTDIR" == "x" ]]
then
	PROJECTDIR=~/.tasklog
fi

create_depot ()
{
	mkdir $PROJECTDIR
	cd $PROJECTDIR
	git init -q
	git commit --allow-empty -q -m "creating project"
	git tag "root"
}

init_tasklog ()
{
	if [ ! -e $PROJECTDIR ]
	then
		create_depot
	else
		cd $PROJECTDIR
	fi
}

list_task ()
{
	git branch --no-color | awk '{print $NF}' | grep -v master
}

create_task ()
{
	if [[ `git branch --no-color | awk '{print $NF}' | grep -w $1` == "$1" ]] 
	then
		echo "task named $1 already exist"
		exit
	fi
	test $# != 1 && usage
	git checkout -q -b $1 root
	git commit --allow-empty -q -m "Creating task $1"
}

close_task ()
{
	if [[ `git branch --no-color | awk '{print $NF}' | grep -w $1` != "$1" ]] 
	then
		echo "no task named $1"
		exit
	fi
	git tag $1 $1
	git checkout -q master
	git merge -s ours --no-ff -m "Closing task $1" `git-show-ref --hash --heads $1` 1>/dev/null 2>&1
	git branch -d $1 1>/dev/null 2>&1
}

list_action ()
{
	git log $1 --pretty=tformat:"%Cblueaction: %Creset%s%n%Cbluedetails:%Creset%n%b" --
}

create_action ()
{
	if [[ `git branch --no-color | awk '{print $NF}' | grep $1` != "$1" ]] 
	then
		echo "no task named $1"
		exit
	fi
	git checkout $1 1>/dev/null 2>&1
	read message
	message="$message\n"
	read line
	until [[ $line == "" ]]
	do
		message="$message\n$line"
		read line
	done
	git commit --allow-empty -q -m "`echo -e $message`"
}

