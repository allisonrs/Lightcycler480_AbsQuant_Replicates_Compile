# Lightcycler480_Replicates_Name
Using R, add names to replicate pair file outputs from an "absolute quantification" analysis on the Roche Lightcycler 480, then merge individual files into a single .csv file.

  The concentration of each well is calculated in the program prior to file export, as determined by 2nd Derivative Max standard curve analysis. 
There are two raw data files that can be exported from this analysis. 
The first file contains information for each individual well.
The second file contains means information of the duplicate pairs of wells, as indicated in the software prior to export.
However, the second file does not contain the sample name of the pairs.

  The first program (Lightcycler480_Replicates_Name) removes extraneous information from the first file, natural sorts each well alphabetically (A1, A2...-H12), 
and exports a .csv of the cleaned data.
It then overwrites the duplicate pair listed in the second file with the name of the sample indicated in the first file,
while keeping information only on the means of the pairs (not the Cp or STD Cp of the pairs). 
If a sample is not part of a duplicate pair, it is still listed in the second file but with "NA" values for the Means, 
as cannot be a mean value taken from a single data point.

  The second program (Lightcycler480_Combine_All) takes the .csv files from Lightcycler480_Replicates_Name and merges them all together into one big .csv file.
This generated file can then be used for downsteram statastical analysis. 

### Lightcycler480_Replicates_Name is written such that it can only be run once in a folder. 
If run again, the list.files(...) function will return the newly created files from the previous run,
which are formatted differently than the original files.
This will cause the program to stop and throw an error message.

Prior to executing the program, ensure the Lightcycler480 output .txt files are converted to .tsv files.
  This can be done using CMD: rename *.txt *.tsv
