#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]
  then
	 case "$TOXENV" in
          ubuntu)
            # Install some custom on Ubuntu Ansible doesn't play well with virtualenv
	    echo "Ubuntu"
            sudo apt install -y sshpass software-properties-common python-software-properties
            sudo apt-add-repository -y ppa:ansible/ansible
            sudo apt update -qq
            sudo apt-get install -y ansible
            ansible --version
	    ansible -m ping all
	    ;;
	  centos)
	    echo "Centos"
	    sudo systemctl start docker
	    sudo docker run hello-world
	    rpm --import https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
	    rpm --import https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7Server
	    sudo yum install epel-release
	    sudo yum install ansible
	    ansible --version
	    ansible -m ping all
	    ;;
	 esac
  else
	  echo "other os"
fi
