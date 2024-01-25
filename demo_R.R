library(RPostgres)

# Global parameters
startyr <- 2002
endyr   <- 2003 
# !!!! Need to set your outdir before running script
currdir <- getwd()
outdir <- paste(currdir, "/data_r", sep="")

# Test for existence of outdir before attempting to write
if (!dir.exists(outdir)) {
  dir.create(outdir)
}

# Create an activity log file
logfile = paste(outdir,"/activity_log.txt",sep="")
if (!file.exists(logfile)){
  fileConn <- file(logfile)
  writeLines("Date|User|Filepath|Year|nrows", fileConn)
  close(fileConn)
}

# Create a connection called "wrds"
# Need to update username
wrds <- dbConnect(Postgres(),
                  host='wrds-pgdata.wharton.upenn.edu',
                  port=9737,
                  dbname='wrds',
                  sslmode='require',
                  user='username')
# AT THIS POINT, EXPECT A DUO PUSH


# FUNCTION TO PULL ONE YEAR OF CRSP DAILY STOCK FILE
download_dsf <- function(year, outdir) {
  # Define an SQL query
  query = "select cusip, permco, permno, date, prc, ret, numtrd, vol "
  query = paste(query, "from crsp.dsf ", sep="")
  query = paste(query, "where date >= '", year, "-01-01' and ", sep="")
  query = paste(query, "date <= '", year, "-12-31'", sep="")
  query

  # Execute the query
  res <- dbSendQuery(wrds, query)
  data <- dbFetch(res)

  outfile = paste("dsf",year,Sys.Date(),sep="_")
  outpath = paste(outdir, "/", sep="") 
  outpath = paste(outpath, outfile, ".csv", sep="")
  
  # Write "data" dataframe to external file
  write.csv(data, outpath, row.names=TRUE)
  
  # Write to activity log 
  user_name = "yourname"
  stringout = ""
  stringout = paste(Sys.Date(),user_name,outpath,year,nrow(data),sep="|")
  write(stringout,file=logfile,append=TRUE)
  
  # Clean up workspace
  dbClearResult(res)

} #end download_dsf


# Call the download function
for (i in startyr:endyr) {
  download_dsf(i, outdir)
}

