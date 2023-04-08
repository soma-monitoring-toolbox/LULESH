#!/bin/bash
#SBATCH --account=project_2006549
#SBATCH --partition=test
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=9
#SBATCH --output=slurm-lulesh-soma-%j.out
#SBATCH --error=slurm-lulesh-soma-%j.err

set -eu

echo "Starting SOMA Collectors..."
export SOMA_SERVER_ADDR_FILE=`pwd`/server.add
export SOMA_NODE_ADDR_FILE=`pwd`/node.add
export SOMA_NUM_SERVER_INSTANCES=1
export SOMA_NUM_SERVERS_PER_INSTANCE=$SLURM_NNODES
export SOMA_SERVER_INSTANCE_ID=0

#Make sure number of SOMA servers is SOMA_NUM_SERVER_INSTANCES * SOMA_NUM_SERVERS_PER_INSTANCE
SERVERS_PER_NODE=1
CLIENTS_PER_NODE=$(( SLURM_NTASKS_PER_NODE - 1 ))

srun ./wrapper.sh $SERVERS_PER_NODE $CLIENTS_PER_NODE

