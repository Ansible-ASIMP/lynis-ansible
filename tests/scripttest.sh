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
	     # Travis CI not yet support Centos we keep this for future
	    echo "Run in Docker Centos7"
            container_id=$(mktemp)
	    PWD=`pwd`
            'sudo docker run --detach --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --volume="${PWD}":"${PWD}":ro centos7:ansible > "${container_id}"'
	    sudo cat ${container_id}
	    sudo docker logs --follow $(cat ${container_id})
            'sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook -v tests/test.yml --syntax-check'
            'sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook -v tests/test.yml'
	    'sudo docker exec "$(cat ${container_id})" env ANSIBLE_FORCE_COLOR=1 ansible-playbook -e 'host_key_checking=False' -i tests/inventory tests/test.yml --connection=local | grep -q 'failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)'
            'sudo docker rm -f "$(cat ${container_id})"'
	    ;;
	 esac
  else
	  echo "other os"
fi
