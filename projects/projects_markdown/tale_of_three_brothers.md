---
author: Daniel Sabalakov
email: danielsabalakov@gmail.com
class: DE Intro to Statistics I
title: Tale of Three Brothers
# quote: \``\\textit{Truth is ever to be found in the simplicity, and not in the multiplicity and confusion of things}'' - Issac Newton
---

# The Tale of the Three Brothers

## Opener. Watch and listen to Hermione Granger read   
*The Tale of the Three Brothers* via [youtube](https://www.youtube.com/watch?v=3-cCDtwsX-g).  Or, read the story [‘The Tale of the Three Brothers.’](https://docs.google.com/document/d/1Ugxtj6TQ6_RpczYdlX9hmL2FLVhYkFpePDHELIJYlKw/edit)  Once you have watched and/or read, make the following estimates, and also post your estimates [here](https://docs.google.com/spreadsheets/d/1owOXUpW_RaPWvUAPDeZWGf9HGYYc9L2ZZCbDVBNRecg/edit?gid=0#gid=0).  It is very reasonable to use decimal numbers.

a. Estimate the population mean word length in letters, .   
**I estimated that the mean word length, mu, is 4.5 letters.**  
b. Estimate the proportion, p, of all words in the story that are 4 letters or less in length.  (Note: if we were going with convention, we would use the Greek letter  to represent the population proportion rather than p).  
**I estimated that the proportion, pi, of words that are 4 letters or less is 45%.**

## Write a definition for a Simple Random Sample design using *your writer’s voice/style*.  Don’t change your answer but compare it to this classic definition: [SRS by Bock, Velleman, and De Veaux](https://docs.google.com/document/d/1Y23tmrR1wHl2AxauksunEjAzkU21Fq9mGP6WFvAAVpg/edit).  
- **A simple random sample should be selected such that each sample has an equal chance of being selected.**  

## How do we actually do a SRS method?  Describe a simple random sample procedure that would allow you to select a sample of twenty-four words (n = 24) from the entire story of 641 total words (N = 641).  

- **I would assign each word a unique id, 1-641 inclusive such that each word corresponds to one id. Then, with the help of a computer program, I would generate 24 unique numbers from 1-641,inclusive, such that no 2 numbers are the same. From then, I would match the generated number with the number associated with a word. A code example would be:**   

## Generate a ***Simple Random Sample*** of size twenty-four (n=24) words from the Harry Potter story, *‘The Tale of the Three Brothers’*.  The numbered words from the text are provided here:  [The Tale of the Three Brothers \- words assigned numbers for SRS and for Stratified Random Sampling](https://docs.google.com/spreadsheets/d/1BMHsKkGDRVfLbewaZK6BFXN65DYBqygb5qfAAnAiH4o/edit#gid=330838861).    This is an excellent [random number generator](https://istats.shinyapps.io/RandomNumbers/).

a. Record the words, their corresponding number designation, and the corresponding word lengths (in number of letters).  Post that information here:    
-   [Position: 446, Word: wizard    , Length:  6],
    [Position: 585, Word: invisibility, Length: 12],
    [Position:  27, Word: of        , Length:  2],
    [Position: 227, Word: had       , Length:  3],
    [Position: 111, Word: the       , Length:  3],
    [Position:  81, Word: he        , Length:  2],
    [Position: 264, Word: for       , Length:  3],
    [Position: 300, Word: hung      , Length:  4],
    [Position: 104, Word: to        , Length:  2],
    [Position:  99, Word: it        , Length:  2],
    [Position: 615, Word: brother's , Length:  9],
    [Position: 486, Word: handed    , Length:  6],
    [Position:  30, Word: to        , Length:  2],
    [Position: 493, Word: death's   , Length:  7],
    [Position: 519, Word: where     , Length:  5],
    [Position: 159, Word: him       , Length:  3],
    [Position: 329, Word: whom      , Length:  4],
    [Position: 428, Word: spoke     , Length:  5],
    [Position:   7, Word: so        , Length:  2],
    [Position: 106, Word: as        , Length:  2],
    [Position: 444, Word: duels     , Length:  5],
    [Position: 373, Word: this      , Length:  4],
    [Position: 215, Word: and       , Length:  3],
    [Position: 364, Word: find      , Length:  4]
b. Make a frequency table of the word lengths \- in number of letters \- and the frequency which they occur in your sample.  Post that here:
-   Word Length: 2, N: 7;
    Word Length: 3, N: 5,;
    Word Length: 4, N: 4;
    Word Length: 5, N: 3;
    Word Length: 6, N: 2;
    Word Length: 7, N: 1;
    Word Length: 9, N: 1;
    Word Length: 12, N: 1;

| Word Length | Frequency |
|:---:|:---:|
|2|7|
|3|5|
|4|4|
|5|3|
|6|2|
|7|1|
|9|1|
|12|1|

c. Determine the ***sample proportion*** of words with four letters or fewer (use the variable p, which represents a sample proportion of success — success in this case is a word with four or fewer letters).
- Proportion p (4) or Lower: p = 0.666 ==> 2/3

## For your next requirement, generate a new sample using a ***stratified random sampling design*** of n \= 24\.  The strata will be words of the following lengths in number of letters:

1-2 letters \-   4
3-4 letters \-   10
5-6 letters \-   6
\> 6 letters \-  4

***Recall, the strata must be proportional.***  

a. Record the words, their corresponding number designation, and the corresponding word lengths (in number of letters).  Post that information here:
- Strata ==> 1,2 ==>
[Position:  24, Word: in        , Length:  2],
[Position:  34, Word: a         , Length:  1],
[Position:  99, Word: it        , Length:  2],
[Position:  15, Word: he        , Length:  2]
- Strata ==> 3,4 ==>
[Position: 192, Word: gave      , Length:  4],
[Position: 186, Word: wand      , Length:  4],
[Position: 218, Word: more      , Length:  4],
[Position:  69, Word: and       , Length:  3],
[Position: 226, Word: upon      , Length:  4],
[Position:  70, Word: the       , Length:  3],
[Position:  73, Word: the       , Length:  3],
[Position: 234, Word: took      , Length:  4],
[Position:  58, Word: the       , Length:  3],
[Position:  90, Word: win       , Length:  3]
- Strata ==> 5,6 ==> 
[Position:  35, Word: killed    , Length:  6],
[Position:  42, Word: river     , Length:  5],
[Position:  39, Word: spoke     , Length:  5],
[Position: 147, Word: truly     , Length:  5],
[Position: 126, Word: throat    , Length:  6],
[Position: 131, Word: lived     , Length:  5]
- Strata ==> >6 ==> 
[Position:  81, Word: brother   , Length:  7],
[Position:  45, Word: without   , Length:  7],
[Position:  16, Word: victims   , Length:  7],
[Position:  38, Word: youngest  , Length:  8]

b. Make a frequency table of the word lengths \- in number of letters \- and the frequency which they occur in your sample.  Post that information here:
-   Word Length: 1, N: 1;
    Word Length: 2, N: 3;
    Word Length: 3, N: 5;
    Word Length: 4, N: 5;
    Word Length: 5, N: 4;
    Word Length: 6, N: 2;
    Word Length: 7, N: 3;
    Word Length: 8, N: 1

| Word Length | Frequency |
|:---:|:---:|
|1|1|
|2|3|
|3|5|
|4|5|
|5|4|
|6|2|
|7|3|
|8|1|

c. Determine the sample proportion of words with four letters or fewer (use the variable p, which represents a sample proportion of success — success in this case is a word with four or fewer letters) .
- Proportion p (4) or Lower: p = 0.5833 ==> 14/24 ==> 7/12

## Make box plots using this [web app](https://istats.shinyapps.io/EDA_quantitative/).   Copy and paste the box plots and statistical summaries here:   
### Freq n=24 SRS
2 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 9 12 

### Freq n=24 STRATIFIED
1 2 2 2 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 7 7 7 8 

@!image path="C:/Users/score/Downloads/tale_srs_v_stratified.png" width=0.9 !@

## ***Compare the distributions*** based on n \= 24 of the SRS design and the stratified random sampling design.  

*Re: When comparing and/or describing distributions, we travel this trail: Big Idea in context, support for that Big Idea, shapes, centers, spreads, outliers.*
- The Simple Random Sample had a mean of 4.17 letters and a standard deviation of 2.48 letters, while the Stratified Sample had a mean of 4.29 BUT had a significantly smaller standard deviation of 1.85 letters. This means that the Stratified sample is less varied than the Simple Random Sample. Furthermore, SRS appears right-skewed, while the Stratified Sample appears roughly unimodal. This means that the Stratified Sample appears MORE normal and appears LESS spread out than the Simple Random Sample.

## Which sampling technique is likely better at estimating the mean word length in letters for all words in the story? Explain.  
- It seems that the Stratified Sample is better at estimating the mean word length for all words in the story. The Stratified Sample takes all strata into account to determine the average number of letters in each strata. This ensures that each letter length strata is represented in the population, hence making the mean more accurate because it ensures that no value is underrepresented.

## The population of word lengths in the number of letters  is displayed by the histogram below.  Note that the vertical axis is a frequency axis (%), not a count axis. Describe how you could use the histogram to determine the median word length of the population.  Determine the median word length in the number of letters.
@!image path="C:/Users/score/Downloads/tale_histogram.png" width=0.9 !@

- I would determine at what "bar" the cumilative sum of bars would equal to approximately 25%, 50%, 75%, yielding Q1, Median, and Q3 respectively. Using this, I figured out that Q1 (25%) is at 3 letters, the Median (50%) is at 4, and Q3 is at 6 letters. Hence, the median word length is 4 letters.

## Make a box plot, ***by hand***,  of the word length (number of letters) for the population given the frequency table below.  Show the 1.5IQR outlier fence work for the right tail of the distribution \- by looking at the frequency distribution table one can discern that there are no outliers on the left tail of the distribution.  Take a picture of your box plot and paste it here.  Ensure that your image is ***oriented correctly.***  

| Word lengths (\# of letters) | Frequency |
| :---: | :---: |
| 1 | 20 |
| 2 | 89 |
| 3 | 170 |
| 4 | 110 |
| 5 | 91 |
| 6 | 57 |
| 7 | 46 |
| 8 | 31 |
| 9 | 19 |
| 10 | 2 |
| 11 | 3 |
| 12 | 3 | 


- Using tech, I found the median and the IQR and compared it to what I answered in the previous question. Now, I can make a box plot using this data.

@!image path="C:/Users/score/Downloads/descstat.png" width=0.9 !@
@!image path="C:/Users/score/Downloads/tale_boxplot.png" width=0.9 !@

##  The mean length of all words in *The Tale of the Three Brothers* is equal to 4.33 letters and the standard deviation is 2.07 letters.  Calculate the z-score for the word ***brothers** **and*** **interpret it in context**.

- Since the mean length of all words is 4.33 letters and the standard deviation is 2.07 letters, the Z score is defined by $\frac{y_1-y}{S_y}$. Substituting into the formula, the Z score will be $\frac{8-4.33}{2.07}$, making the z score: 1.77. This means that in a normal distribution, a word with 8 letters is in the top 96.16% of all letters. Furthermore, this means that "brothers" is an atypical word, because it is between the first and second standard deviation. If the z-score is greater than 2 (or less than -2), the word would be considered an outlier, but since it is between 1 and 2, the word is considered atypical.

# Source Code and Output
## You may be wondering how did I get these numbers? I found this to be a fun problem to do and implement via computer code. 
The source code can be found here: [https://github.com/Scoresh/Daniel-Statistics-Tale-Of-Three-Brothers](https://github.com/Scoresh/Daniel-Statistics-Tale-Of-Three-Brothers). 
The bonus of using a computer to select everything for me was that I could reuse multiple functions to make my overall quality of life easier. Programming is all about taking a 20 minute assignment by hand and making it last multiple hours, as long as you don't have to do anything by hand.
However, the output of the program (and what I used for this assignmnet) was:
```
----jGRASP exec: java Tale
Number: 446
Number: 585
Number: 27
Number: 227
Number: 111
Number: 81
Number: 264
Number: 300
Number: 104
Number: 99
Number: 615
Number: 486
Number: 30
Number: 493
Number: 519
Number: 159
Number: 329
Number: 428
Number: 7
Number: 106
Number: 444
Number: 373
Number: 215
Number: 364


-----------------------------------------------


[Position: 446, Word: wizard    , Length:  6]
[Position: 585, Word: invisibility, Length: 12]
[Position:  27, Word: of        , Length:  2]
[Position: 227, Word: had       , Length:  3]
[Position: 111, Word: the       , Length:  3]
[Position:  81, Word: he        , Length:  2]
[Position: 264, Word: for       , Length:  3]
[Position: 300, Word: hung      , Length:  4]
[Position: 104, Word: to        , Length:  2]
[Position:  99, Word: it        , Length:  2]
[Position: 615, Word: brother's , Length:  9]
[Position: 486, Word: handed    , Length:  6]
[Position:  30, Word: to        , Length:  2]
[Position: 493, Word: death's   , Length:  7]
[Position: 519, Word: where     , Length:  5]
[Position: 159, Word: him       , Length:  3]
[Position: 329, Word: whom      , Length:  4]
[Position: 428, Word: spoke     , Length:  5]
[Position:   7, Word: so        , Length:  2]
[Position: 106, Word: as        , Length:  2]
[Position: 444, Word: duels     , Length:  5]
[Position: 373, Word: this      , Length:  4]
[Position: 215, Word: and       , Length:  3]
[Position: 364, Word: find      , Length:  4]


-----------------------------------------------


Word Length: 2, N: 7
Word Length: 3, N: 5
Word Length: 4, N: 4
Word Length: 5, N: 3
Word Length: 6, N: 2
Word Length: 7, N: 1
Word Length: 9, N: 1
Word Length: 12, N: 1


-----------------------------------------------


Proportion N or Lower: 0.6666666666666666


-----------------------------------------------


MAP LENGTHS: 109
MAP LENGTHS: 280
MAP LENGTHS: 148
MAP LENGTHS: 104


Number: 4.0
Number: 10.0
Number: 6.0
Number: 4.0


-----------------------------------------------


Stratified Number Generations: 
Number: 24
Number: 34
Number: 99
Number: 15
Number: 192
Number: 186
Number: 218
Number: 69
Number: 226
Number: 70
Number: 73
Number: 234
Number: 58
Number: 90
Number: 35
Number: 42
Number: 39
Number: 147
Number: 126
Number: 131
Number: 81
Number: 45
Number: 16
Number: 38


-----------------------------------------------


Strata: 0
[Position:  24, Word: in        , Length:  2]
[Position:  34, Word: a         , Length:  1]
[Position:  99, Word: it        , Length:  2]
[Position:  15, Word: he        , Length:  2]
Strata: 1
[Position: 192, Word: gave      , Length:  4]
[Position: 186, Word: wand      , Length:  4]
[Position: 218, Word: more      , Length:  4]
[Position:  69, Word: and       , Length:  3]
[Position: 226, Word: upon      , Length:  4]
[Position:  70, Word: the       , Length:  3]
[Position:  73, Word: the       , Length:  3]
[Position: 234, Word: took      , Length:  4]
[Position:  58, Word: the       , Length:  3]
[Position:  90, Word: win       , Length:  3]
Strata: 2
[Position:  35, Word: killed    , Length:  6]
[Position:  42, Word: river     , Length:  5]
[Position:  39, Word: spoke     , Length:  5]
[Position: 147, Word: truly     , Length:  5]
[Position: 126, Word: throat    , Length:  6]
[Position: 131, Word: lived     , Length:  5]
Strata: 3
[Position:  81, Word: brother   , Length:  7]
[Position:  45, Word: without   , Length:  7]
[Position:  16, Word: victims   , Length:  7]
[Position:  38, Word: youngest  , Length:  8]


-----------------------------------------------


Strata: 0
Word Length: 1, N: 1
Word Length: 2, N: 3
Strata: 1
Word Length: 3, N: 5
Word Length: 4, N: 5
Strata: 2
Word Length: 5, N: 4
Word Length: 6, N: 2
Strata: 3
Word Length: 7, N: 3
Word Length: 8, N: 1


-----------------------------------------------


There are 14 integers 4 or lower.
The proportion of 4 or lower is: 0.5833333333333334


-----------------------------------------------


COPY PASTABLE: 


Freq n=24 SRS
2 2 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 6 6 7 9 12 

Freq n=24 STRATIFIED
1 2 2 2 3 3 3 3 3 4 4 4 4 4 5 5 5 5 6 6 7 7 7 8 



----jGRASP: operation complete.
```
