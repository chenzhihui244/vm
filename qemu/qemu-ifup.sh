#!/bin/sh
set -x

BR_TYPE=linux  # linux or ovs
BRIDGE=br0
TAP=$1


set -x

if [ -n "$TAP" ]; then
	### Create BRIDGE if there is no
	#ip link show $BRIDGE > /dev/null 2>&1
	#if [ $? -ne 0 ]; then
	#	echo "Create $BRIDGE.."
	#	if [ "$BR_TYPE" = "linux" ]; then
	#		ip link add $BRIDGE type bridge
	#		ip link set $BRIDGE up
	#		sleep 0.5s
	#	else
	#		ovs-vsctl add-br $BRIDGE
	#	fi
	#fi

	## add tapx interface to BRIDGE
        ip tuntap add $TAP mode tap user `whoami`
        ip link set $TAP up
        sleep 0.5s
	if [ "$BR_TYPE" = "linux" ]; then
		ip link set $TAP master $BRIDGE
	else
		ovs-vsctl add-port $BRIDGE $TAP
	fi
        exit 0
else
        echo "Error: no interface specified"
        exit 1
fi

set +x
