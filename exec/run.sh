#!/bin/bash
#SBATCH --account=rrg-bengioy-ad                        # Yoshua pays for your job
#SBATCH --nodes=1                                       # Ask for 1 node
#SBATCH --ntasks=2                                      # Ask for 2 tasks
#SBATCH --cpus-per-task=4                               # Ask for 8 CPUs (2 runs)
#SBATCH --gres=gpu:1                                    # Ask for 1 GPU (enough for 2 runs)
#SBATCH --mem=32G                                       # Ask for 32 GB of RAM
#SBATCH --time=00:30:00                                 # The job will run for 12 hours
#SBATCH -o /home/maxwab/scratch/outfiles/slurm-%j.out   # Write the log in $SCRATCH

# NOT TO USE: SBATCH --array=1-20%1                                  # Run a 20-job array, one job at a time.

# 0. Create env variables
export CODE_FOLDER="Rainbow"

# 1. Create your environement locally
module load python/3.6
virtualenv --no-download $SLURM_TMPDIR/rl
source $SLURM_TMPDIR/rl/bin/activate
python -m pip install --no-index -r $HOME/dev/$CODE_FOLDER/requirements.txt

# 4. Launch your job, tell it to save the model in $SLURM_TMPDIR
#    and look for the dataset into $SLURM_TMPDIR
#    When allocating memory divide the total by the number of tasks!
cd $HOME/dev/$CODE_FOLDER
srun -l --mem=16G --multi-prog exec/2games.conf

# 5. Copy whatever you want to save on $SCRATCH -> Done in the python script
