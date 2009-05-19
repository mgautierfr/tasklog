#!/bin/sh

create_depot ()
{
	mkdir depot
	cd depot
	git init -q
	git commit --allow-empty -q -m "creating project"
	git tag "root"
}

init_tasklog ()
{
	if [ ! -e depot ]
	then
		create_depot
	else
		cd depot
	fi
}

