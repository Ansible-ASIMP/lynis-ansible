#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'linux' ]]
  then
	 case "$TOXENV" in
          ubuntu)
	    echo "Ubuntu"
            echo "[default]\nhost_key_checking = False" > ansible.cfg
            echo "[default]\nansible_ssh_common_args='-o StrictHostKeyChecking=no'\n" >> ansible.cfg
            echo "[local]\nlocalhost ansible_connection=local" >> ansible.cfg
            export ANSIBLE_HOST_KEY_CHECKING=False
            ansible-playbook -v -i tests/inventory tests/test.yml --syntax-check
            ansible-playbook -e 'host_key_checking=False' -i tests/inventory tests/test.yml -vvvv --connection=local
            # Run the role/playbook again, checking to make sure it's idempotent. We only check for failed. Report out alway change.
            ansible-playbook -e 'host_key_checking=False' -i tests/inventory tests/test.yml --connection=local | grep -q 'failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
	    ;;
	  centos7)
	    echo "Run in Docker Centos7"
	    PWD=$(pwd)
	    echo "current working dir $PWD - This will be used to mount docker volume"
	    sudo docker run --detach --privileged --name centos7 --mount type=bind,source="$(pwd)",target=/etc/ansible/roles/lynis-ansible centos7:ansible
            docker inspect centos7
	    DOCKER_CONTAINER_ID=$(docker ps | grep centos7 | awk '{print $1}')
            docker logs $DOCKER_CONTAINER_ID
	    echo $DOCKER_CONTAINER_ID
            sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 centos7 ansible -v all -m setup
            sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 centos7 ansible-playbook -v /etc/ansible/roles/lynis-ansible/tests/test.yml --syntax-check
            sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 centos7 ansible-playbook -v /etc/ansible/roles/lynis-ansible/tests/test.yml
            # Run the role/playbook again, checking to make sure it's idempotent. We only check for failed. Report out alway change.
	    sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 centos7 ansible-playbook -e 'host_key_checking=False' -i /etc/ansible/roles/lynis-ansible/tests/inventory /etc/ansible/roles/lynis-ansible/tests/test.yml --connection=local | grep -q 'failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
	    ;;
	  stretch)
	    echo "Run in Docker Debian Stretch"
	    PWD=$(pwd)
	    echo "current working dir $PWD - This will be used to mount docker volume"
	    sudo docker run --detach --privileged --name stretch --mount type=bind,source="$(pwd)",target=/etc/ansible/roles/lynis-ansible stretch:ansible
            docker inspect stretch
	    DOCKER_CONTAINER_ID=$(docker ps | grep stretch | awk '{print $1}')
            docker logs $DOCKER_CONTAINER_ID
	    echo $DOCKER_CONTAINER_ID
            sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 stretch ansible -v all -m setup
            sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 stretch ansible-playbook -v /etc/ansible/roles/lynis-ansible/tests/test.yml --syntax-check
            sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 stretch ansible-playbook -v /etc/ansible/roles/lynis-ansible/tests/test.yml
            # Run the role/playbook again, checking to make sure it's idempotent. We only check for failed. Report out alway change.
	    sudo docker exec -ti -e ANSIBLE_FORCE_COLOR=1 stretch ansible-playbook -e 'host_key_checking=False' -i /etc/ansible/roles/lynis-ansible/tests/inventory /etc/ansible/roles/lynis-ansible/tests/test.yml --connection=local | grep -q 'failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
	    ;;
	 esac
  else
	  echo "other os"
fi
