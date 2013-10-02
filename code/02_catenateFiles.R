## bring the individual datasets into one big file
## NOTE FROM THE FUTURE: probably not going to happen
## compromise: merge the year-specific datsets into one dataset per position

library(plyr)

(jFiles <- list.files("data", "^201[0-9]_[A-Z]+.csv", full.names = TRUE))

if(length(jFiles) != 21) 
  stop("expecting 21 raw data files!\ncheck what's gone wrong!")

## http://stackoverflow.com/questions/4993837/r-invalid-multibyte-string
## helped me troubleshoot this error upon importing a single test dataset:
## Error in type.convert(data[[i]], as.is = as.is[i], dec = dec, na.strings = character(0L)) : 
##   invalid multibyte string at '<a0>'

allRaw <- lapply(jFiles, 
                 function(aFile)
                   read.table(aFile, header = TRUE, sep = ",",
                              fileEncoding="latin1", quote = "\""))
names(allRaw) <- gsub(".csv", "", gsub("data/", "", jFiles))
str(allRaw, max.level = 1)
## OMG they all have different numbers of variables

## assemble number of observations and variables for each dataset
getDsetFacts <- function(z) {
  dsetFacts <-
    ldply(z, function(x) data.frame(nobs = nrow(x), nvar = length(x)))
  dsetFacts <-
    data.frame(do.call("rbind", strsplit(dsetFacts$.id, "_")), dsetFacts)
  names(dsetFacts) <- c("year", "position", "ID", "nobs", "nvar")
  dsetFacts$year <- as.numeric(as.character(dsetFacts$year))
  dsetFacts
}
dsetFacts <- getDsetFacts(allRaw)
dsetFacts

## is the number of variables at least constant within a position?
dlply(dsetFacts, ~ position, function(x) x$nvar)
## no, of course not, that would be too easy
## good ones: DEF = 13, QB = 21, ST = 8
## tricky ones: K = 26, 21, 21; RB = 19, 18, 19; TE = 19, 18, 19; WR = 24, 23, 24

## which variables appear, by position?

## first, rearrange dsetFacts and allRaw by position, then year
newOrder <- with(dsetFacts, order(position, year))
dsetFacts <- dsetFacts[newOrder, ]
allRaw <- allRaw[dsetFacts$ID]

llply(allRaw, names)

## visual inspection of the tricky ones

## K = 26, 21, 21
## in 2010, we have field goals in 5 different length classes missed? made? attempted?
## in 2011 and 2012, we have only made and attempted?
## that explains the extra 5 variables in 2010

## RB = 19, 18, 19 and TE = 19, 18, 19 and WR = 24, 23, 24
## 2010 has Rec.Tgt
## 2011 had nothing
## 2012 has Targets

## fix individual datasets to facilitate merging

## in 2010_K, drop variables that start with X[0-9], should be 5 of them
allRaw[["2010_K"]] <- 
  subset(allRaw[["2010_K"]],
         select = !grepl("^X[0-9]", names(allRaw[["2010_K"]])))

## in 2010_RB, 2010_TE, 2010_WR, rename Rec.Tgt to Targets
jFun <- function(x) rename(x, c(Rec.Tgt = "Targets"))
allRaw[["2010_RB"]] <- jFun(allRaw[["2010_RB"]])
allRaw[["2010_TE"]] <- jFun(allRaw[["2010_TE"]])
allRaw[["2010_WR"]] <- jFun(allRaw[["2010_WR"]])

## in 2011_RB, 2011_RB, 2011_WR, create a variable Targets, all values NA
jFun <- function(x) {
  x$Targets <- rep(NA_integer_, nrow(x))
  x
}
allRaw[["2011_RB"]] <- jFun(allRaw[["2011_RB"]])
allRaw[["2011_TE"]] <- jFun(allRaw[["2011_TE"]])
allRaw[["2011_WR"]] <- jFun(allRaw[["2011_WR"]])

## let's count the variables again ...
dsetFacts <- getDsetFacts(allRaw)
dsetFacts
dlply(dsetFacts, ~ position, function(x) sort(x$nvar))
## YES! within position, the number of variables is now constant

## but do they really have the same names?
jPosition <- levels(dsetFacts$position)

## visual inspection of this:
lapply(jPosition, function(x) {
  y <- allRaw[dsetFacts$position == x]
  foo <- llply(y, names)
  foo <- data.frame(ID = rep(names(foo), sapply(foo, length)),
                    varName = unlist(foo))
  rownames(foo) <- NULL
  with(foo, table(varName, ID))  
})
## our only troublesome position is WR
## retained bits that show the problems:
#           ID
# varName    2010_WR 2011_WR 2012_WR
# KR.Lng         1       0       0
# KR.Long        0       1       1
# Lng            0       1       1
# Rec.Lng        1       0       0

allRaw[["2010_WR"]] <- rename(allRaw[["2010_WR"]], c(KR.Lng = "KR.Long"))
allRaw[["2010_WR"]] <- rename(allRaw[["2010_WR"]], c(Rec.Lng = "Lng"))

## REPEAT visual inspection of this:
lapply(jPosition, function(x) {
  y <- allRaw[dsetFacts$position == x]
  foo <- llply(y, names)
  foo <- data.frame(ID = rep(names(foo), sapply(foo, length)),
                    varName = unlist(foo))
  rownames(foo) <- NULL
  with(foo, table(varName, ID))  
})

## READY TO MERGE THE DATASETS AT EACH POSITION

## WRITE POSITION-SPECIFIC MULTI-YEAR DATASETS