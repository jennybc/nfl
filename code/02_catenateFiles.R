library(plyr)

jFiles <- list.files("data", "^201[0-9]_[A-Z]+.csv", full.names = TRUE)

if(length(jFiles) != 21) 
  stop("expecting 21 raw data files!\ncheck what's gone wrong!")


## http://stackoverflow.com/questions/4993837/r-invalid-multibyte-string
## helped me troubleshoot this error upon importing a single dataset:
## Error in type.convert(data[[i]], as.is = as.is[i], dec = dec, na.strings = character(0L)) : 
##   invalid multibyte string at '<a0>'

read.table(jFiles[2], header = TRUE, sep = ",", fileEncoding="latin1", quote = )

allRaw <- lapply(jFiles, 
                 function(aFile)
                   read.table(aFile, header = TRUE, sep = ",",
                              fileEncoding="latin1", quote = "\""))
names(allRaw) <- gsub(".csv", "", gsub("data/", "", jFiles))
str(allRaw, max.level = 1)
## OMG they all have different numbers of variables

## assemble number of observations and variables for each dataset
dsetFacts <- ldply(allRaw, function(x) {
  data.frame(nobs = nrow(x), nvar = length(x))
})
dsetFacts <- data.frame(do.call("rbind", strsplit(dsetFacts$.id, "_")),
                        subset(dsetFacts, select = c(nobs, nvar)))
names(dsetFacts) <- c("year", "position", "nobs", "nvar")
dsetFacts

## is the number of variables at least constant within a position?
dlply(dsetFacts, ~ position, function(x) sort(x$nvar))
## no, of course not, that would be too easy
## good ones: DEF = 13, QB = 21, ST = 8
## tricky ones: K = 21, 21, 26; RB = 18, 19, 19; TE = 18, 19, 19; WR = 23, 24, 24

## WHEN I RETURN:
## ANALYZE VARIABLE NAMES WITHIN POSITION
## IF LOOKS REASONABLE, MERGE DATASETS WITHIN POSITION

## WRITE POSITION-SPECIFIC MULTI-YEAR DATASETS