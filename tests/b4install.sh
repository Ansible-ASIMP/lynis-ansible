#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]
  then
	 case "$TOXENV" in
          ubuntu)
            # Install some custom on Ubuntu Ansible doesn't play well with virtualenv
	    echo "Ubuntu"
            deactivate
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update -qq
            sudo apt -y -o Dpkg::Options::="--force-confnew" install docker-ce
            docker --version
	    ;;
	  centos)
	    echo "Centos"
            deactivate
	    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
	    ;;
	 esac
  else
	  echo "other os"
fi
