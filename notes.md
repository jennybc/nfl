Notes on data cleaning
========================================================

> Maybe this would make a decent case study on data cleaning? Case study seems to be the only way to *teach* data cleaning. Or at least it's a good place to start.

Based on a thread on the class Google Group after JB posted her first pass at cleaned data:

Thanks Jenny!  I made a bit of progress on it yesterday as well.  I started with the walk-crawl-run approach and attempted to merge the wr 2010-2012 data.  However, I understand what you mean now about the time it takes to perform data cleaning, even on a dataset that appears to be well organized.  I noticed that between the different files, the columns had similar but different names and also for WR 2011, the column for Targets was missing.  I took more of a brute force approach with it, so I am going to review your code more closely to see how you handled it in R.  

Thanks,
Leah


Leah: Yes! This data isn't even that bad and it takes time to figure out what's going on and address it. It is of course tempting to get in there with Excel to clean it up. I've done it myself in the past. Isn't it harder to clean data in R? Answer: long run NO. Here are lessons I've learned the hard way:

  * diagnosis: In this NFL data, we have to carefully compare variables -- the number of them and their names -- across 3 different datasets (2010, 2011, 2012) for 7 different positions (wide receiver, kicker, etc.). We find several weird problems as you now know. Discovering these "by hand" is really hard and tedious. Once you record the logic and code for comparing variables across datasets, it is easy to scale that up in R. In Excel, there is no such efficiency. In fact, the more positions, variables, years, the more tired and error-prone you get.

  * repeatability: I hope dear Nathan Brixius eventually uploads data for 2013 or 2009 and earlier. And you can bet there will still be gremlins and gotchas, such as oddball filenames and dis-appearing / re-appearing variables. But when we return to this code to clean up and add the new data, it is a happy day to re-open the cleaning script and have a huge head start. There will undoubtedly be NEW problems but at least you aren't re-solving the old ones.

  * documentation and shareability: The ability for you and I to collaborate on this or for me to collaborate with Nathan (hypothetical at this point) is greatly enhanced by writing stuff down (e.g. in R code and .csv files), putting it into a Git repository, and sharing on github. This is MUCH better than us discussing via hand-wavy emails about data-cleaning with Excel workbooks attached. Very related to the whole "save plain text files", "save source code", "use version control", "use github" circle of ideas.

