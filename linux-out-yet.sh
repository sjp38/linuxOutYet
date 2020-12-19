#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <version>"
	exit 1
fi

version=$1

url="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tag/"
url+="?h=$version"

if curl -sI "$url" | grep -qe "^HTTP/1.1 200 OK"
then
	echo "Out"
else
	echo "Not out yet"
fi
