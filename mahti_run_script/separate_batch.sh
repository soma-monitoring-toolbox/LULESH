#!/bin/bash
#SBATCH --account=project_2006549
#SBATCH --partition=test
#SBATCH --time=00:30:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=9
#SBATCH --output=slurm-lulesh-soma-%j.out
#SBATCH --error=slurm-lulesh-soma-%j.err

set -eu

#module purge

#module load openmpi/4.1.2-cuda
#module load cuda

echo "Starting SOMA Collectors..."
export SOMA_SERVER_ADDR_FILE=`pwd`/server.add
export SOMA_NODE_ADDR_FILE=`pwd`/node.add
export SOMA_NUM_SERVER_INSTANCES=1
export SOMA_NUM_SERVERS_PER_INSTANCE=8
export SOMA_SERVER_INSTANCE_ID=0

#Make sure number of SOMA servers is SOMA_NUM_SERVER_INSTANCES * SOMA_NUM_SERVERS_PER_INSTANCE
srun -n 8 -N 1 /users/dewiy/soma-collector/build/examples/example-server -a ofi+verbs:// &

sleep 10

echo "Starting LULESH"

srun -n 8 -N 1 /users/dewiy/LULESH/build/lulesh2.0 -i 500 -p
