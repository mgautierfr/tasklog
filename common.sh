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

