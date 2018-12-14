#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]
  then
	 case "$TOXENV" in
          ubuntu)
            # Install some custom on Ubuntu Ansible doesn't play well with virtualenv
	    echo "Ubuntu"
            sudo pip install docker-py
            sudo apt install -y sshpass software-properties-common python-software-properties
            sudo apt-add-repository -y ppa:ansible/ansible
            sudo apt update -qq
            sudo apt-get install -y ansible
            ansible --version
	    ;;
	  centos)
	    echo "Centos"
            deactivate
	    ;;
	 esac
  else
	  echo "other os"
fi
