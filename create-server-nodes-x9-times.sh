#!/bin/bash
# henkka

# check salt-master server ip first in cloud-init settings!!
# check network id!!

for i in {1..4}
do

server_name="node-$i"
volume_name="node-$i-volume01"

echo "create volume for server..."
openstack volume create --image "Ubuntu Server 14.04 LTS (English) 02" --size 30 --availability-zone fi-1a $volume_name


ready="init"
while [ $ready != "available" ]
do
	echo "check if volume is ready..."
	ready=`openstack volume list | grep $volume_name | sed 's/ //g' | awk -F '|' '{ print $4 }'`
	echo "status: $ready"
	sleep 10
done


echo "create server..."

openstack server create \
--flavor S-1 \
--volume $volume_name \
--key-name dirty-gloves \
--security-group dirty-gloves-SG \
--user-data ./cloud-init-salt-minion.txt \
--nic net-id=3542c375-09ce-4fc1-9e88-16175fb878cf $server_name


done

