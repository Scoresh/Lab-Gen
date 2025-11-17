---
author: Daniel Sabalakov
quote:  \``\\textit{May the Force Be With You}'' \\\\ \\textemdash{} General Jan Dodonna
class: DE Introduction to Probability and Statistics, Portsmouth High School
title: Q1 Grade Analysis
---

# Overview {-}

Grades in Great Bay Stat. are categorized in three ways: Formative, Summative, Final. Each are weighted 20%, 70%, and 10%, respectively; meaning that, technically, only the Summative Grade is required to pass the course. All grades analyzed will not include individual weights. 

Let's analyse Daniel Sabalakov's, a student at Great Bay Stat., grades. 

# Data set {-}

## Formative {-}

Frequency Table for Formative:

<!-- +------+-----+-----+-----+-----+-----+
| x    | 92  | 93  | 95  | 100 | 101 |
+======+=====+=====+=====+=====+=====+
|p(X=x)|0.077|0.077|0.077|0.538|0.231|
+------+-----+-----+-----+-----+-----+ -->

|x|92|93|95|100|101|
|:--|---|---|---|---|---|
|N(X=x)|1|1|1|7|3|

Raw Data for Formative Grades:
{100,101,100,100,93,92,101,100,101,100,100,95,100}

Formative Bar Graph and Box Plot

@!image path="C:/Users/score/Downloads/form_bp.png" width=0.6!@

@!raw \\pagebreak !@


### Formative Mean and Standard Deviation, In Context {-}

The mean of the Formative category is 98.692, and the standard deviation is 3.146. The standard deviation of 3.146 points is the typical distance between Daniel Sabalakov's average Formative score of 98.692 points and one of Daniel Sabalakov's scores.

### Formative Median and IQR, In Context {-}

The median of the Formative category is 100 points, and the IQR of the Formative category is 0 points. (Q3-Q1=100-100=0) This means that the middle point of Daniel Sabalakov's ordered points is a 100 and that the 25th percentile and the 75th percentile are 0 points apart. 

### Formative Outliers, In Context {-}

Using our two outlier rules of thumb, we can determine the left fence for each outlier.

1. Mean & Standard Deviation R.O.T: $Outliers <,> \mu \pm 2\sigma$
    * Outliers < $98.692 - 2*3.146$ ==> Outliers < 92.4
    * Outliers > $98.692 + 2*3.146$ ==> Outliers > 104.984
2. Median & IQR R.O.T: $Outliers <,> Q_{1,3} \pm 1.5(Q_3-Q_1)$
    * Outliers < 100 - 1.5 * (100 - 100) ==> Outliers < 100
    * Outliers > 100 + 1.5 * (100 - 100) ==> Outliers > 100

Using the Mean & Standrard Deviations, scores under 92.4 are considered outliers for the data set. Daniel Sabalakov only had one score that is considered an outlier; the score of 92 is considered an outiler because 92 < 92.4

Using the Median & IQR, scores under or over 100 are considered outliers. This yields a result of 6 outlier points. This means that points are very clustered around the 100 point mark since at least 50% of data points in the Formative section are 100's. 

## Summative {-}


Frequency Table for Summative Grades:

|x|75|86|95|96|100|101|
|:--|---|---|---|---|---|---|
|N(X=x)|1|1|4|1|4|1|

Raw Data for Summative Grades:
{96,95,75,100,100,100,101,95,95,86,100,95}


@!image path="C:/Users/score/Downloads/sum_bg.png" width=0.8!@

@!image path="C:/Users/score/Downloads/sum_bp.png" width=0.8!@

@!raw \\pagebreak !@

### Summative Mean and Standard Deviation, In Context {-}

The mean of the Summative category is 94.833, and the standard deviation is 7.493. The standard deviation of 7.493 points is the typical distance between Daniel Sabalakov's average Summative scores of 94.833 points and one of Daniel Sabalakov's scores.

### Summative Median and IQR, In Context {-}

The median of the Summative category is 95.5 points, and the IQR of the Summative category is 5 points (Q3-Q1=100-95=5) This means that the middle point of Daniel Sabalakov's ordered points is a 95.5 and that the 25th percentile and the 75th percentile are 5 points apart. 

### Summative Outliers, In Context {-}

Using our two outlier rules of thumb, we can determine the left fence for each outlier.

1. Mean & Standard Deviation R.O.T: $Outliers <,> \mu \pm 2\sigma$
    * Outliers < $94.833 - 2*7.493 $ ==> Outliers < 79.846
    * Outliers > $94.833 + 2*7.493 $ ==> Outliers > 109.819
2. Median & IQR R.O.T: $Outliers <,> Q_{1,3} \pm 1.5(Q_3-Q_1)$
    * Outliers < 95.5 - 1.5 * (5) ==> Outliers < 87.5
    * Outliers > 95.5 + 1.5 * (5) ==> Outliers > 103

Using the Mean & Standrard Deviations, scores under 79.846 are considered outliers for the Sumamtive data set. Daniel Sabalakov only had one score that is considered an outlier; the score of 75 is considered an outiler because 75 < 79.846.

Using the Median & IQR, scores under a score of 87.5 or over a score of 103 are considered outliers. This yields a result of 2 outlier points: a score of 86 and a score of 75. 

## Final {-}

Daniel Sabalakov scored exceptionally well on the final, scoring a 100% on each of the three portions of the final. This yields a median and a mean of a 100, and an IQR and Standard Deviation of 0. 

# Analysis and Conclusion {-}


@!raw \\pagebreak !@
@!image path="C:/Users/score/Downloads/both_dp.png" width=0.8!@

A score of 75 in the Summative category, quite frankly, is an outlier beyond doubt. Calculating the z-score of a score of 75, we get: $Z=\frac{y-\mu}{\sigma}$, ==> $Z=\frac{75-94.833}{7.493}$ ==> $Z=-2.669$. Using the Mean and Standard Deviation rule of thumb, any z-score under -2 is considered an outlier. If this is a normal model (which I will discuss in the next section), a Summative score of 75 or lower has a 0.38% chance of occuring. Additionally, using the Median and IQR rule of thumb, any score under 87.5 is an outlier. While Daniel Sabalakov did score a 86, which would be considered an outlier, a score of 75 is even more of an outlier. Hence, a Summative score of 75 is undeniably an outlier from both the Median & IQR perspective and a Mean and Standard Deviation perspective. 

For data to be modeled normally, the following characteristics must be true. 
Of the Summative distribution,

* Symmetry
    - The Summative distribution is **not** symmetric. An outlier of 75 points as well as an atypical 85 points make the curve left-skewed. 
* Bell Shape (Unimodal): 
    - The Summative distribution must be unimodal. The Summative Grade Distribution is **not** unimodal; rather, it is left-skewed. 
* 50%-95%-99% rule
    - The Summative distribution does **not** follow the 50-95-99% rule. A majority of the data is found within 1 standard deviation of the mean; 5/6th of the data is found within 1 standard deviation of the mean. 1/12 of the data (8.3%) is found within 2 standard deviations, and 1/12 of the data (8.3%) is an outlier. (Using the mean & stdev R.O.T)
* Thin tails
    - The Summative distribution does **not** have thin tails on both asymptotes. On the right, the Summative Distribution is not thin-tailed. 

This means that the Summative distribution can not be modeled normally. However, this does not invalidate the point that a score of 75 is an outlier; a normal distribution only contributes a percentage. 

Both the Summative and Formative score distributions are Left-skewed, meaning that the mean will be less than the median for both. If the Summative score of 75 (which is clearly an outlier) is removed from the Summative distribution, Daniel's overall grade will be a 96.9%. Removing the Summative score of 75 will additionally change the outlier rule of a typical distribution. The Summative distribution without the 75 has a mean of 96.63 with a standard deviation of 4.34 points. This means that, on average, a score in the modified distribution will vary by 4.34 points from the mean of 96.63 points. 

## Screenshot of Google Spreadsheet {-}

@!image path="C:/Users/score/Downloads/rstat1.png" width=1 !@
@!image path="C:/Users/score/Downloads/rstat2.png" width=1 !@
