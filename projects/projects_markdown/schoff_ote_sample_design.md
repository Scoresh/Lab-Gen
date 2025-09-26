---
author: Daniel Sabalakov
email: danielsabalakov@gmail.com
class: DE Intro to Statistics I
title: OTE Sample Design
quote: \``\\textit{For the strength of the pack is the wolf, and the strength of the wolf is the pack}''
---

# OTE: Sample Design	  
                                    
Wolf-Pack Name: Daniel Sabalakov

### Questions
(a)  Define simple random sample (SRS) design.	
+ Simple Random Sample (SRS) design is a method to design a sample such that each sample has an equal likelyhood of being chosen. This means that the sample is always inherently random; by doing this, it ensures that there will be minimal bias. In a population, this will ensure that the sample is representative of the population. However, SRS has its flaws when dealing with minorities or skewed destributions of demographics; SRS relies on sampling people at random, so in opinionated surveys, the majority of people would have an overwhelming opinion over the minority opinion.

(b) Describe how you would choose a sample of 100 people from a population of 2,700 people using an SRS design.
+ I would assign each person of the population a unique identifier from 1-2,700 such that there will be no duplicate numbers. Then, with either the help of a random number table or a random number generator, I would choose 100 random people to survey. I would survey them and ensure that a response is recorded; this way, each combination of people has the same chance to be surveyed. I will also conduct this such that the sample is non-replacable so that no person is selected twice.
    + In a random number generator, (In a computer language that gives a random decimal from [0,1) ), I would do the following. 
        + Let the decimal be variable "r". I would multiply by the sample range (2700) and type-cast the decimal to an integer by using the floor function. Then, I would add 1 to ensure that the range will be [1,2700]. 
        + In code, this will be: 
        ```
            double r = Math.random();
            int sample = (int)(r*2700)+1;
        ```
(c) Finish the sentence.  The purpose of sampling is to…
+ __The purpose of sampling is to ensure that the sample is representative of the population by creating a bias-free sample design.__
(d) Identify one of the four types of sampling bias.  Define that form of bias and provide an example of how such bias could occur.
+ One form of sampling bias is undercoverage bias. This occurs when a minority opinion is completely skipped over and is not represented in the sample. For example, if I were to sample people from the High School on opinions on the "Careers in Technical Education" program, I may completely glance over a CTE class if I conduct a small Simple Random Sample because there are fewer students in CTE than in a general class. This will then be biased and non-representative of the population because I skimmed over the CTE class. I would get around this by conducting a Stratified Sample by ensuring that people from CTE have a proportional influence on the sample. This would be done by splitting the sample into "strata:" (CTE, Non-CTE), taking the total number and then finding how many people "should" be sampled from the two, and randomly selecting people in the two to sample. In summary, undercoverage bias occurs when a minority population is not proportionally sampled in the general population.
(e) In New Hampshire, approximately 303,000 people are registered as Democrats, approximately 298,000 are registered as Republicans, and about 399,000 are registered as Independents.   A pollsters decides *to stratify* according  to party registration and wants a sample of 900 registered voters.   Determine the number of voters that should be selected  from registered Democrats, Republicans, and Independents.      
+ Since people are registered politically like the following: {Democrats: 303,000; Republicans: 298,000; Independents: 399,000}, the total number of people in the state registered are approximately 1,000,000 (303000+298000+399000). That is a big number, but percentage wise, people are representative of the population like the following: {Democrats: 30.3%; Republicans: 29.8%; Independents: 39.9%}. (39.9+30.3+29.8=100). In this case, if we are to sample 900 people, multiplying each percentage by 900 yields: {Democrats: 272.7; Republcians: 268.2; Independents: 359.1} (272.7+268.2+359.1=900). However, since we cannot sample a percentage of a person, we will round: {Democrats: 273; Republicans: 268; Independents: 359}. (273+268+359=900). So, to select voters from the Democrats, Republicans, and Independents in a stratified sample of 900 people, we should select 273 Democrats, 268 Republicans, and 359 Independents. 

