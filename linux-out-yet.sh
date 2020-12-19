#!/bin/bash

function pr_usage() {
	echo "Usage: $0 [OPTION]... <version>"
	echo
	echo "OPTION"
	echo "  --repo <path>	Specify local repository"
	exit 1
}

while [ $# -ne 0 ]
do
	case $1 in
	"--repo")
		if [ $# -lt 2 ]
		then
			echo "<path> not given"
			pr_usage
			exit 1
		fi
		local_repo=$2
		shift 2
		continue
		;;
	*)
		if [ ! -z "$version" ]
		then
			echo "more than one <version>"
			pr_usage
			exit 1
		fi
		version=$1
		shift 1
		continue
		;;
	esac
done

if [[ ! "$version" =~ ^v[0-9]+\.[0-9]+ ]]
then
	echo "wrong version"
	exit 1
fi

major_version=$(echo $version | awk -F'[v.]' '{print $2}')
if [ $major_version -lt 3 ]
then
	echo "Only v3.x or later supported"
	exit 1
fi

if [ ! -z "$local_repo" ] && \
	git --git-dir=$local_repo/.git tag | grep -qe "^$version$"
then
	echo "Out"
	exit 0
fi

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
	exit 0
else
	echo "Not out yet"
	exit 1
fi
