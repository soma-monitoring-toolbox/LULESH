#!/bin/bash
#SBATCH --account=project_2006549
#SBATCH --partition=test
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --output=slurm-lulesh-soma-%j.out
#SBATCH --error=slurm-lulesh-soma-%j.err

set -eu
module load gcc/9.4.0 openmpi/4.1.2-cuda cuda cmake
. /projappl/project_2006549/spack/share/spack/setup-env.sh

echo "Starting SOMA Collectors..."
export SOMA_SERVER_ADDR_FILE=`pwd`/server.add
export SOMA_NODE_ADDR_FILE=`pwd`/node.add
export SOMA_NUM_SERVER_INSTANCES=2
export SOMA_NUM_SERVERS_PER_INSTANCE=$SLURM_NNODES
export SOMA_SERVER_INSTANCE_ID=0
export SOMA_INSTALL_DIR=/users/dewiy/soma-collector/build

#TAU Paths
export PATH=/projappl/project_2006549/tau2/x86_64/bin:$PATH
export TAU_PLUGINS_PATH=/projappl/project_2006549/tau2/x86_64/lib/shared-mpi
export TAU_PLUGINS=libTAU-mochi-soma-remote-collector-plugin.so
export SOMA_TAU_SERVER_INSTANCE_ID=1
export TAU_SOMA_MONITORING_FREQUENCY=50
spack env activate $SOMA_INSTALL_DIR/..

#Make sure number of SOMA servers is SOMA_NUM_SERVER_INSTANCES * SOMA_NUM_SERVERS_PER_INSTANCE
SERVERS_PER_NODE=2
CLIENTS_PER_NODE=$(( SLURM_NTASKS_PER_NODE - $SERVERS_PER_NODE ))

srun ./tau_wrapper.sh $SERVERS_PER_NODE $CLIENTS_PER_NODE

