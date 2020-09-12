# gc-log-parser
G1 GC log parser
The script here takes in 2 arguments and gives a breakdown of G1 pause times(with epoch times i.e since the start of the java application)

# Usage:
````
bash For_gc_log_parsing_mixed_gcs.sh <GC log file> <mixed/young>
````

# Result:

````
157212.996 marking end
157214.751   [Eden: 2424.0M(2416.0M)->0.0B(2408.0M) Survivors: 344.0M->352.0M Heap: 16.4G(18.0G)->14.2G(18.0G)]
157214.751 38.2 2.9 92.5 6.8 Total: 140.4 (A)
157227.191   [Eden: 2520.0M(2520.0M)->0.0B(2408.0M) Survivors: 240.0M->352.0M Heap: 16.3G(18.0G)->13.9G(18.0G)]
157227.191 57.4 21.7 100.7 30.2 Total: 210
157233.111   [Eden: 2408.0M(2408.0M)->0.0B(2408.0M) Survivors: 352.0M->352.0M Heap: 16.3G(18.0G)->14.1G(18.0G)] (B)
157233.111 47.3 0.1 94.7 8.0 Total: 150.1
157235.147 marking end (C)


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
- For Line type (B) :
  - Gives the information about heap size changes in format :  Before -> After 
  - First column here can be used to match with the heap timings (statements of type (A) )
- For Line type (C):
  - First number is the epoch => Time spent since start of java application
  - Informs about the time when concurrent marking phase ends => Required to trigger mixed gcs
  
  
# Sources of information :
- Some hands on knowledge about reading gc logs: https://www.jfokus.se/jfokus13/preso/jf13_GCLogs.pdf
- https://www.redhat.com/en/blog/collecting-and-reading-g1-garbage-collector-logs-part-2
- G1Gc Tips for RSet Details: https://www.infoq.com/articles/tuning-tips-G1-GC/
