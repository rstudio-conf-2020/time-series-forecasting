Tidy Time Series and Forecasting in R
================

### rstudio::conf 2020

by Rob J Hyndman

-----

INSTRUCTIONS FOR INSTRUCTORS: Please insert information about your
workshop below. Then, add workshop content in the materials folder and
link to each session’s materials from the schedule below. You are
welcomed to add more rows to the schedule. We just ask that you take
breaks at the specified times. Once you are done adding information, you
can remove these instructions from the README.

-----

:spiral_calendar: January 27 and 28, 2020
:alarm_clock:     09:00 - 17:00
:hotel:           \[ADD ROOM\]
:writing_hand:    [rstd.io/conf](http://rstd.io/conf)

-----

## Overview

It is becoming increasingly common for organizations to collect huge amounts of data over time, and existing time series analysis tools are not always suitable to handle the scale, frequency and structure of the data collected. In this workshop, we will look at some new packages and methods that have been developed to handle the analysis of large collections of time series.

On day 1, we will look at the tsibble data structure for flexibly managing collections of related time series. We will look at how to do data wrangling, data visualizations and exploratory data analysis. We will explore feature-based methods to explore time series data in high dimensions. A similar feature-based approach can be used to identify anomalous time series within a collection of time series, or to cluster or classify time series Primary packages for day 1 will be tsibble, lubridate and feast (along with the tidyverse of course).

Day 2 will be about forecasting. We will look at some classical time series models and how they are automated in the fable package. We will look at creating ensemble forecasts and hybrid forecasts, as well as some new forecasting methods that have performed well in large-scale forecasting competitions. Finally, we will look at forecast reconciliation, allowing millions of time series to be forecast in a relatively short time while accounting for constraints on how the series are related.

## Learning objectives

Attendees will learn:

1. How to wrangle time series data with familiar tidy tools.
2. How to compute time series features and visualize large collections of time series.
3. How to select a good forecasting algorithm for your time series.
4. How to ensure forecasts of a large collection of time series are coherent.

## Is this course for me?

This course will be appropriate for you if you answer yes to these questions:

1. Do you already use the tidyverse packages in R such as dplyr, tidyr, tibble and ggplot2?
2. Do you need to analyse large collections of related time series?
3. Would you like to learn how to use some new tidy tools for time series analysis including visualization, decomposition and forecasting?

## Prework

Attendees are expected to have R and RStudio installed on their own computers, along with the tidyverse, tsibble, tsibbledata, feasts and fable packages and their dependencies.

\[ADD INFORMATION YOU WANT LEARNERS TO HAVE / STEPS THEY WANT THEM TO
COMPLETE PRIOR TO THE WORKSHOP. THIS COULD BE A LINK TO A THREAD ON
RSTUDIO COMMUNITY, PACKAGE INSTALL INSTRUCTIONS, HOW TO GET AN
RSTUDIO.CLOUD ACCOUNT, ETC.\]

## Schedule

| Time          | Activity         |
| :------------ | :--------------- |
| 09:00 - 10:30 | Session 1        |
| 10:30 - 11:00 | *Coffee break*   |
| 11:00 - 12:30 | Session 2        |
| 12:00 - 13:30 | *Lunch break*    |
| 13:30 - 15:00 | Session 3        |
| 15:00 - 15:30 | *Coffee break*   |
| 15:30 - 17:00 | Session 4        |

## Instructor

**Rob J Hyndman** is Professor of Statistics and Head of the [Department of Econometrics and Business Statistics](http://business.monash.edu/econometrics-and-business-statistics) at [Monash University](https://www.monash.edu). From 2005 to 2018 he was Editor-in-Chief of the *[International Journal of Forecasting](http://ijf.forecasters.org/)* and a Director of the [International Institute of Forecasters](http://forecasters.org/). Rob is the author of over 150 research papers and 5 books in statistical science. In 2007, he received the Moran medal from the Australian Academy of Science for his contributions to statistical research, especially in the area of statistical forecasting. For over 30 years, Rob has maintained an active consulting practice, assisting hundreds of companies and organizations around the world. He has won awards for his research, teaching, consulting and graduate supervision.

He has coauthored about 40 R packages, many of which are on CRAN. He is best known for the [**forecast**](https://cran.r-project.org/package=forecast) package. This workshop will be based around a suite of new packages he has been developing to do time series analysis and forecasting using tidy principles.

-----

![](https://i.creativecommons.org/l/by/4.0/88x31.png) This work is
licensed under a [Creative Commons Attribution 4.0 International
License](https://creativecommons.org/licenses/by/4.0/).
