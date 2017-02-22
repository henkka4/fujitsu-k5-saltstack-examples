#!/bin/bash
neutron router-create router01
neutron router-gateway-set router01 inf_az1_ext-net01
neutron router-list
