#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]; then

    # Install some custom requirements on Linux
    # e.g. apt yum

    case "${TOXENV}" in
        ubuntu)
            # Install some custom on Ubuntu
            # Ansible doesn't play well with virtualenv
            deactivate
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update -qq
            sudo apt -y -o Dpkg::Options::="--force-confnew" install docker-ce

            sudo pip install docker-py
            sudo apt install -y sshpass software-properties-common python-software-properties
            sudo apt-add-repository -y ppa:ansible/ansible
            sudo apt update -qq
            sudo apt-get install -y ansible
            ansible --version

            ;;
        centos)
            # Install some custom on Centos
            ;;
    esac
else
    # Install some custom requirements on osx
fi
