This project makes use of several docker images I've created for
hosting OpenStack services in Docker containers.  The [ansible][]
playbook will create:

[ansible]: http://www.ansible.com/

- A mysql server, using the official [mysql docker image][].
- A rabbitmq server
- A keystone server
- A glance server

[mysql docker image]: https://registry.hub.docker.com/_/mysql/

Other than the mysql image, all images come from [my docker
repositories][].

[my docker repositories]: https://hub.docker.com/u/larsks/

To deploy these services, edit `settings.yml` as appropriate and then
run:

    ansible-playbook openstack.yml

When the playbook is finished running, you can spin up an interactive
container to experiment with the services by running:

    docker run -it --rm  \
      --link keystone:keystone \
      --link glance:glance \
      --volumes-from glance \
      --volumes-from keystone  \
      --e OS_PASSWORD=$KEYSTONE_ADMIN_PASS_FROM_SETTINGS_DOT_YML \
      larsks/os-apiclient /bin/bash

And once at the shell prompt:

    . /root/keystonerc

You will find keystone and glance logs under `/srv/keystone` and
`/srv/glance`.

