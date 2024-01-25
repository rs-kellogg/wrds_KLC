The repo has notebooks and scripts that demonstrate how to connect with the WRDS server.
A few steps for using the notebook on KLC.
```
# Connect to KLC
# https://www.kellogg.northwestern.edu/academics-research/research-support/computing/kellogg-linux-cluster.aspx

# Clone the repo
git clone https://github.com/rs-kellogg/wrds_KLC

cd wrds_KLC

# Set up .pgpass file at your $HOME directory
# wrds-pgdata.wharton.upenn.edu:9737:wrds:username:your_password
nano ~/.pgpass


# Activate pre-built conda environment
module load mamba
source activate /kellogg/software/envs/wrds_env/

# Add the conda environment kernel locally (only need to run once)
python -m ipykernel install --user --name wrds_env --display-name "Python (wrds_env)"

### IMPORTANT ###
# Use editor of your choice, mod

# IMPORTANT
# Modify "username" in .ipynb, .py or .R scripts to your username for WRDS

# Launch the jupyter notebook in FastX
# Select the "Python (wrds_env)" kernel before you run cells
jupyter notebook --browser=firefox

# To run the python script
python ./demo_python.py

# To run the R script
Rscript ./demo_R.R

# Leave the environment
conda deactivate
```