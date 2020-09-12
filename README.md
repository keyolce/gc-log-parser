# gc-log-parser
G1 GC log parser
The script here takes in 2 arguments and gives a breakdown of G1 pause times(with epoch times i.e since the start of the java application)

# Usage:
````
bash For_gc_log_parsing_mixed_gcs.sh <GC log file> <mixed/young>
````

# Result:

````
157133.272 60.2 28.6 87.0 8.0 Total: 183.8 (A)

157142.520 marking end (B)

157152.534 24.9 35.3 80.2 8.5 Total: 148.9

157167.952 marking end

157176.515 34.5 35.6 86.1 9.6 Total: 165.8
````

# Explanation:
- For Line type (A):
  - First column is the time spent(in seconds) since the start of the application
  - Last column followed by "Total" infofrms about the gc pause time
  - Rest of the columns:
    - 2nd column : Update Rememebered Sets => Time taken to update the RSets of the region
    - 3rd column : Scan Remembered Sets => Time taken to scan the RSets to find out the live objects
    - 4th column : Object copy => Time taken to copy the live objects from old regions (G1 does this to avoid de-fragementation)
    - 5th column : "Others" => Time taken to handle other activities in a GC
- For Line type (B):
  - First number is the epoch => Time spent since start of java application
  - Informs about the time when concurrent marking phase ends => Required to trigger mixed gcs
  
  
Sources of information :
- Some hands on knowledge about reading gc logs: https://www.jfokus.se/jfokus13/preso/jf13_GCLogs.pdf
- https://www.redhat.com/en/blog/collecting-and-reading-g1-garbage-collector-logs-part-2
- G1Gc Tips for RSet Details: https://www.infoq.com/articles/tuning-tips-G1-GC/
