import os
import pandas as pd
from pathlib import Path
from datetime import datetime
import wrds

# Establish connection 
# AT THIS POINT, EXPECT A DUO PUSH
# Need to update username
conn = wrds.Connection(wrds_username='username')

# Define function for downloading data
def download_dsf(year, outdir, logfile, user_name):
    # Define an SQL query
    query = f"SELECT cusip, permco, permno, date, prc, ret, numtrd, vol FROM crsp.dsf WHERE date >= '{year}-01-01' AND date <= '{year}-12-31'"

    # Execute the query
    df_result = conn.raw_sql(query)

    # Save to .csv file
    filename = f"dsf_{year}_{datetime.now().date()}.csv"
    outfile = outdir / filename
    df_result.to_csv(outfile, index=True)

    # Write to activity log 
    stringout = f"{datetime.now().date()}|{user_name}|{outfile.absolute()}|{year}|{len(df_result)}"
    with open(logfile, 'a') as file:
        file.write(f"{stringout}\n")


# Start demo project 
startyr = 2002
endyr = 2003
# Need to set your outdir before running script
outdir = Path("./data_python")

if not outdir.exists():
    os.makedirs(outdir)

# Create an activity log file
logfile = outdir / "activity_log.txt"
if not logfile.exists():
    with open(logfile, 'w') as file:
        file.write("Date|User|Filepath|Year|nrows\n")

user_name = "yourname"
# Call the download function
for i in range(startyr, endyr + 1):
    download_dsf(i, outdir, logfile, user_name)
