#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]
  then
	 case "$TOXENV" in
          ubuntu)
            # Install some custom on Ubuntu Ansible doesn't play well with virtualenv
	    echo "Ubuntu"
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update -qq
            sudo apt upgrade -y
            sudo apt dist-upgrade -y
            sudo apt -y -o Dpkg::Options::="--force-confnew" install docker-ce
            docker --version
	    echo 'DOCKER_OPTS="-H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock -s devicemapper"' | sudo tee /etc/default/docker > /dev/null
	    sudo systemctl restart docker
	    sleep 5
	    sudo docker run hello-world
	    sudo -H pip install docker-py
	    ;;
	  centos7)
	     # Travis CI not yet support Centos we keep this for future
	    echo "Prepare Docker For Centos7"
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update -qq
            sudo apt upgrade -y
            sudo apt dist-upgrade -y
            sudo apt -y -o Dpkg::Options::="--force-confnew" install docker-ce
            docker --version
	    echo 'DOCKER_OPTS="-H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock -s devicemapper"' | sudo tee /etc/default/docker > /dev/null
	    sudo systemctl restart docker
	    sleep 5
	    sudo docker run hello-world
	    sudo -H pip install docker-py
	    ;;
	  stretch)
	     # Travis CI not yet support Debian we keep this for future
	    echo "Prepare Docker For Debian Stretch"
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update -qq
            #sudo apt upgrade -y
            #sudo apt dist-upgrade -y
            sudo apt -y -o Dpkg::Options::="--force-confnew" install docker-ce
            docker --version
	    echo 'DOCKER_OPTS="-H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock -s devicemapper"' | sudo tee /etc/default/docker > /dev/null
	    sudo systemctl restart docker
	    sleep 5
	    sudo docker run hello-world
	    sudo -H pip install docker-py
	    ;;
	 esac
  else
	  echo "other os"
fi
