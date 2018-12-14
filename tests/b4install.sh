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
	    sudo systemctl start docker
	    sudo docker run hello-world
	    sudo pip install docker-py
	    ;;
	  centos)
	     # Travis CI not yet support Centos we keep this for future
	    echo "Centos"
            deactivate
	    sudo yum-config-manager --enable centos-extras
	    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
	    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	    sudo gpg --quiet --with-fingerprint tests/gpg-docker-centos
	    rpm --import https://download.docker.com/linux/centos/gpg
	    sudo yum-config-manager --enable docker-ce-edge
	    sudo yum-config-manager --enable docker-ce-test
	    sudo yum install docker-ce
	    ;;
	 esac
  else
	  echo "other os"
fi
