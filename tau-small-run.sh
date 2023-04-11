#!/bin/bash
#SBATCH --job-name=soma-lulesh
#SBATCH --account=project_2006549
#SBATCH --partition=medium
#SBATCH --time=00:20:00
#SBATCH --nodes=2
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm-lulesh-%j.out
#SBATCH --error=slurm-lulesh-%j.err

set -eu

module load gcc/9.4.0 openmpi/4.1.2-cuda cuda cmake
. /projappl/project_2006549/spack/share/spack/setup-env.sh

echo "Starting SOMA Collectors..."
export SOMA_SERVER_ADDR_FILE=`pwd`/server.add
export SOMA_NODE_ADDR_FILE=`pwd`/node.add
export SOMA_NUM_SERVER_INSTANCES=2
export SOMA_NUM_SERVERS_PER_INSTANCE=1
export SOMA_SERVER_INSTANCE_ID=0
export SOMA_INSTALL_DIR=/users/sriamesh/SOMA/soma-collector/build

#TAU Paths
export PATH=/users/sriamesh/SYMBIOMON/tau2/x86_64/bin:$PATH
export TAU_PLUGINS_PATH=/users/sriamesh/SYMBIOMON/tau2/x86_64/lib/shared-mpi
export TAU_PLUGINS=libTAU-mochi-soma-remote-collector-plugin.so
export SOMA_TAU_SERVER_INSTANCE_ID=1
export TAU_SOMA_MONITORING_FREQUENCY=50
spack env activate $SOMA_INSTALL_DIR/..

#Make sure number of SOMA servers is SOMA_NUM_SERVER_INSTANCES * SOMA_NUM_SERVERS_PER_INSTANCE
srun -n 2 -N 1 $SOMA_INSTALL_DIR/examples/example-server -a ofi+verbs:// &

sleep 10

echo "Starting LULESH"
srun -n 8 -N 1 tau_exec -T MPI ../lulesh2.0 -i 500 -p
