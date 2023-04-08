#!/bin/bash

if [[ $# -ne 2 ]]; then
    printf "$0 expects two arguments, $# were given"
    exit 1
fi

SERVERS_PER_NODE=$1
CLIENTS_PER_NODE=$2
procid=$SLURM_PROCID

PROCS_PER_NODE=$(( SERVERS_PER_NODE + CLIENTS_PER_NODE ))

is_server(){
    pid=$1
    #In each block, first clients, then servers
    [[ $(( pid % PROCS_PER_NODE )) -ge CLIENTS_PER_NODE ]]
}


if is_server $procid ; then
    echo "Launching proc $procid, a server"
    /users/dewiy/soma-collector/build/examples/example-server -a ofi+verbs://
    #These all call MPI_Comm_split(color=38)
    echo "Server $procid exiting"
else
    echo "Launching proc $procid, a client"
    /users/dewiy/LULESH/build/lulesh2.0 -i 500 -p
    #These all call MPI_Comm_split(color=42)
    echo "Client $procid exiting"
fi
