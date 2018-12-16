#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]
  then
	 case "$TOXENV" in
          ubuntu)
	    echo "Ubuntu"
            sudo apt install -y sshpass software-properties-common python-software-properties
            sudo apt-add-repository -y ppa:ansible/ansible
            sudo apt update -qq
            sudo apt-get install -y ansible
            ansible --version
	    ansible -m ping all
	    ;;
	  centos7)
	    echo "Docker Centos7"
	    sudo docker pull centos:7
	    sudo docker build --no-cache --rm --file=tests/Dockerfile.centos7 --tag=centos7:ansible tests
	    ;;
	  stretch)
	    echo "Docker Debian Stretch"
	    sudo docker pull debian:stretch
	    sudo docker build --no-cache --rm --file=tests/Dockerfile.stretch --tag=stretch:ansible tests
	    ;;
	 esac
  else
	  echo "other os"
fi
