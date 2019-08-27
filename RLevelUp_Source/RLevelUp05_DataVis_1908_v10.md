---
title: "RLevelUp05_DataVis"
output:
  html_document: default
  word_document: default
---

### 05 미국 주별 강력 범죄율 구분도
### 학습 내용

### 01 패키지 준비
* install.packages("ggiraphExtra")
* ggiraphExtra 패키지를 이용 

```{r}
library(ggiraphExtra)
search()
```


```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
