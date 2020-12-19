#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <version>"
	exit 1
fi

version=$1

git_kernel_org_url="https://git.kernel.org/pub/scm/linux/kernel/git/"

nr_numbers=$(echo $version | awk -F'.' '{print NF}')

if [ $nr_numbers -eq 2 ]
then
	url="$git_kernel_org_url/torvalds/linux.git/tag/?h=$version"
elif [ $nr_numbers -eq 3 ]
then
	url="$git_kernel_org_url/stable/linux.git/tag/?h=$version"
else
	echo "Unsupported version"
fi

if curl -sI "$url" | grep -qe "^HTTP/1.1 200 OK"
then
	echo "Out"
else
	echo "Not out yet"
fi
