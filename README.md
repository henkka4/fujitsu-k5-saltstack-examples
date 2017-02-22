# fujitsu-k5-saltstack-example

Example setup for using saltstack on K5 cloud platform.

- create keypair
- create router
- create network and security group with heat blueprint
- create saltstack master server with script, assign public ip and use cloud-init
- create servers and use cloud-init to install salt minions and connect saltstack master


## build infra

Before we start u need to have these python pkgs installed
```bash
$ pip install python-openstackclient python-neutronclient
```


1) Fujitsu K5 - Openstack env
```bash
$ cat k5-dirty-gloves.rc 

export OS_USERNAME=XXX
export OS_PASSWORD=XXX
export OS_PROJECT_NAME=dirty-gloves
export OS_PROJECT_ID=564681cce6274657b1e618064d086e36
export OS_AUTH_URL=https://identity.fi-1.cloud.global.fujitsu.com/v3
export OS_REGION_NAME=fi-1
export OS_VOLUME_API_VERSION=2
export OS_IDENTITY_API_VERSION=3
export OS_USER_DOMAIN_NAME=XXX
export OS_DEFAULT_DOMAIN=XXX
```

2) create router
```bash
$ source k5-dirty-gloves.rc
$ ./create-router.sh
```

3) create K5 cloud ssh keypair for SSH login
```bash
$ ./create-keypair.sh
```

4) run heat blueprint for network
```bash
$ openstack stack create -t heat-dirty-gloves-net.yaml dirty-gloves-net
```

5) create CM server (saltstack master) and assign public ip address
- you need to check earlier created network id for create-server-salt-master.sh

```bash
$ ./create-server-salt-master.sh
```

6) lets just create 9 servers and install salt minion using cloud-init
- you need to check earlier created network id for this script
- you need to check salt-master server ip and edit cloud-init template!
```bash
$ ./create-server-nodes-x9-times.sh
```

7) after servers are up use salt-key on salt master server
```bash
root@salt-master:~# salt-key
Accepted Keys:
node-1
node-2
node-3
node-4
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```


8) add salt stack formulas to salt-master server

https://github.com/saltstack-formulas

https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html

