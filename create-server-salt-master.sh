#!/bin/bash
# henkka

# check network id!!!


server_name="salt-master"
volume_name="salt-master-volume01"

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
--user-data ./cloud-init-salt-master.txt \
--nic net-id=3542c375-09ce-4fc1-9e88-16175fb878cf $server_name

sleep 5
echo "create new floating ip..."
floating_ip=`neutron floatingip-create inf_az1_ext-net01 | grep floating_ip_address | sed 's/ //g' | awk -F '|' '{ print $3 }'`

echo "new floating ip: $floating_ip"

echo "add new floating ip to server..."
openstack server add floating ip $server_name $floating_ip

if [ $? -eq 0 ]; then
	echo "floating ip $floating_ip added OK to server $server_name"
fi

