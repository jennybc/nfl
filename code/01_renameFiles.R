## download the NFL data proposed for STAT545A by Leah Webber

## available from here
## https://skydrive.live.com/?cid=801F87A75BCB7685&id=801F87A75BCB7685%21483&authkey=%21GsA26YB8OQA%24#cid=801F87A75BCB7685&id=801F87A75BCB7685%21466&authkey=%21GsA26YB8OQA%24

## file storage very UNfriendly to systematic downloading :(

## this script captures my manual process

## manually download the 2012 files with the mouse
(jFiles <- list.files("data/asDownloaded"))
file.rename(from = file.path("data/asDownloaded", jFiles),
            to = file.path("data/asDownloaded", paste0("2012_",jFiles)))

## manually download the 2011 files
(jFiles <- list.files("data/asDownloaded", "^[a-zA-z]"))
file.rename(from = file.path("data/asDownloaded", jFiles),
            to = file.path("data/asDownloaded", paste0("2011_",jFiles)))

## manually download the 2010 files
(jFiles <- list.files("data/asDownloaded", "^[a-zA-z]"))
file.rename(from = file.path("data/asDownloaded", jFiles),
            to = file.path("data/asDownloaded", paste0("2010_",jFiles)))

list.files("data") # what a mess!
# [1] "data/2010_DEF.csv"     "data/2010_K.csv"       "data/2010_QB.csv.txt" 
# [4] "data/2010_RB.csv.txt"  "data/2010_ST.csv.txt"  "data/2010_TE.csv.txt" 
# [7] "data/2010_WR.csv.txt"  "data/2011_Def.csv.txt" "data/2011_K.csv.txt"  
# [10] "data/2011_QB.csv.txt"  "data/2011_RB.csv.txt"  "data/2011_ST.csv.txt" 
# [13] "data/2011_TE.csv.txt"  "data/2011_WR.csv.txt"  "data/2012_DEF.csv.txt"
# [16] "data/2012_K.csv.txt"   "data/2012_QB.csv.txt"  "data/2012_RB.csv.txt" 
# [19] "data/2012_ST.csv.txt"  "data/2012_TE.csv.txt"  "data/2012_WR.csv.txt" 

## get rid of gratuitous ".txt" in filename
(jFiles <- list.files("data/asDownloaded", full.names = TRUE))
file.rename(from = jFiles, to = gsub("(*.csv).txt", "\\1", jFiles))

list.files("data/asDownloaded") # aaaand, of course, the capitalization is not consistent
# [1] "2010_DEF.csv" "2010_K.csv"   "2010_QB.csv"  "2010_RB.csv"  "2010_ST.csv"  "2010_TE.csv" 
# [7] "2010_WR.csv"  "2011_Def.csv" "2011_K.csv"   "2011_QB.csv"  "2011_RB.csv"  "2011_ST.csv" 
# [13] "2011_TE.csv"  "2011_WR.csv"  "2012_DEF.csv" "2012_K.csv"   "2012_QB.csv"  "2012_RB.csv" 
# [19] "2012_ST.csv"  "2012_TE.csv"  "2012_WR.csv"

## GO ALL CAPS for the positions
(jFiles <- list.files("data/asDownloaded"))
file.rename(from = file.path("data/asDownloaded", jFiles),
            to = file.path("data/asDownloaded",
                           gsub("(_[a-zA-Z]+)", "\\U\\1", jFiles, perl = TRUE)))

## THIS is how they should have been named in the first place!
matrix(list.files("data/asDownloaded"), ncol = 3)
# [,1]           [,2]           [,3]          
# [1,] "2010_DEF.csv" "2011_DEF.csv" "2012_DEF.csv"
# [2,] "2010_K.csv"   "2011_K.csv"   "2012_K.csv"  
# [3,] "2010_QB.csv"  "2011_QB.csv"  "2012_QB.csv" 
# [4,] "2010_RB.csv"  "2011_RB.csv"  "2012_RB.csv" 
# [5,] "2010_ST.csv"  "2011_ST.csv"  "2012_ST.csv" 
# [6,] "2010_TE.csv"  "2011_TE.csv"  "2012_TE.csv" 
# [7,] "2010_WR.csv"  "2011_WR.csv"  "2012_WR.csv" 
