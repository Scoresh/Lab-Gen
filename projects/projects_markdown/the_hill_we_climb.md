---
    author: Daniel Sabalakov
    class: DE Intro to Statistics I
    title: The Hill We Climb
---

In this activity we will use Amanda Gorman’s *The Hill We Climb,* the poem she authored and recited at Joe Biden’s Presidential Inauguration on January 21, 2021, as a vehicle to apply many Big Idea Great Bay Stat concepts.  

Although we will use the words in the poem for inference purposes, it should be clear that inference would not be necessary in this instance.  Why?  Because the population word length of *The Hill We Climb* is relatively small, N=559.  If we really wanted to know actual population parameters \- such as , the mean word length (in number of letters), or p, the actual proportion of words that are nouns and verbs \- we could simply do a census, count every word, and we could calculate  and p, and we could calculate any other population parameter of interest to us for that matter (like ).

1\. Watch this [youTube video](https://www.youtube.com/watch?v=LZ055ilIiN4) of Ms. Gorman’s recital, ***then estimate the actual proportion of all words in The Hill We Climb that are nouns or verbs***.  To be clear, we are categorizing nouns and verbs as ***successes***, all other parts of speech are categorized as failures.

[Parts of speech](https://www.google.com/search?q=parts+of+speech&rlz=1CAHKDC_enUS921&oq=parts+of+sp&aqs=chrome.0.0i433j69i57j0l5j69i60.2492j0j7&sourceid=chrome&ie=UTF-8): a category to which a word is assigned in accordance with its syntactic functions. In English the main parts of speech are noun, pronoun, adjective, determiner, verb, adverb, preposition, conjunction, and interjection.

In order to weigh the evidence about your claim about the proportion of nouns+verbs, let’s use a significance test.  ***You will use your estimate for the value of p0.***  

2.a. *Identify by name the inference procedure*:

b. *Define the population parameter of interest* \- what variable are you using and what does it represent:

c. *Write the null and alternative hypotheses*.  In this case, you should choose the inequality for the alternative hypothesis based on whether you think you are underestimating or overestimating p.  And if you have no idea about your estimate, then go with a two-tailed test, HA: p p0.  Recall, you can only use three of the five inequalities when performing tests of significance.  

***We never use these two*****: pp0   pp0.  *Ever.***

d. In order to perform this type of inference, we need to work with an approximately normal model as guaranteed by the Central Limit Theorem.  One assumption is that n must be large enough.  We check that by computing whether we would expect to observe at least ten successes and ten failures based on our value of p0.  *Use your values for p0 and q0, determine the minimum sample size required*.  Show your work, and write your answer here:

3\. You will conduct *a simple random sample* to generate the minimum number of words you calculated in 2\. charlie.  

a. *In your own words, without consulting your notes/Googling, define a SRS sampling technique*.

b. Use technology \- your TI-84 will work well, or this [random number app](https://istats.shinyapps.io/RandomNumbers/), or this [random number generator](https://www.random.org/integer-sets/) \- and this [Google Sheet](https://docs.google.com/spreadsheets/d/1fUKuJAjf9OSsTm7Mvz2GqZs8BGEXNp6u54-k3S36YiU/edit#gid=0) to conduct a SRS.  Note: column Alpha contains all 559 words but not in the correct order, which does not matter for sampling purposes.  The poem can be read in the correct order using columns Foxtrot thru Juliet.

c. *Write the words from your sample here*:

d.  *How many words are successes as we defined success (nouns and verbs)*?

e. Write the equation for your sample proportion using the correct variable on one side and the unsimplified fraction on the other side.

4\. The assumptions for inference are reasonably met.  ***Independent trials?***   We randomly selected words from the population, and chances are that our sample size is less than 10% of the population size:  n \< 0.10N.  We guaranteed that ***n would be large enough*** in the data collection planning phase.    
Let’s continue with the test. 

a. Draw and label the normal model.  Recall, we know the mean of this model, p0, and the standard deviation, p0q0n.  Place your sample proportion on the model.  Shade in the correct direction *based on your alternative hypothesis*.  This [app](https://istats.shinyapps.io/NormalDist/) will work very well.  Copy and paste the image here.

b. Calculate the *test statistic* \- the z-score \- and the *corresponding p-value*.

Recall, for a one prop z-test:  z \= p \- p0p0q0n   

5\. Use an alpha level, aka a significance level, of 0.05.  Write a dynamic conclusion in context.

6\. Based on your decision in question 5., identify which one of the two types of errors you could have made.  Explain.  

7\. ***Interpret*** the probability-value (typically simply called the p-value) in context.  Recall, the p-value is conditional.   The p-value is the probability of observing the sample statistic from your data collection effort, or one even more extreme, given that the null hypothesis is true.  The sample statistic we use in a one-proportion z-test is the sample proportion, p.

