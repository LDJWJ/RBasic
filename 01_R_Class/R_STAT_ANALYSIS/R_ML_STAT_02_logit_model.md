---
title: "R_ML_STAT_02_모델만들기"
output: html_document
---

## 02 미국에 사는 인디언들의 당뇨병 예측 

### 학습 내용
* 로지스틱 회귀분석을 이용하여 당뇨병 여부 예측해 보기

### 라이브러리 불러오기
* 패키지가 없다고 뜨면 install.packages()를이용하여 설치를 진행
* install.packages("faraway")
* install.packages("pscl")
```{r cars}
library(faraway)
library(pscl)
library(caret)
library(ROCR)
search()

```

### 01 데이터 준비 및 나누기
```{r}
data(pima, package="faraway")
pima$test <- factor(pima$test)
dim(pima)
head(pima)
str(pima)
```

* (직접 해보기) 데이터의 확인 내용을 간단하게 Notepad에 적어보자.

### pima
* pregnant : Number of times pregnant
* glucose  : Plasma glucose concentration at 2 hours in an oral glucose tolerance test
* diastolic : Diastolic blood pressure (mm Hg)
* triceps : Triceps skin fold thickness (mm)
* insulin : 2-Hour serum insulin (mu U/ml)
* bmi : Body mass index (weight in kg/(height in metres squared))
* diabetes : Diabetes pedigree function
* age : Age (years)
* test : test whether the patient shows signs of diabetes (coded 0 if negative, 1 if positive)
* The data may be obtained from UCI Repository of machine learning databases at http://archive.ics.uci.edu/ml/


### 02 데이터 나누기
* 학습용 데이터 50%
* 테스트 용 데이터 50%

```{r}
# 샘플 5:5
idx <- sample(NROW(pima)/2)

# 데이터 셋 나누기
train <- pima[idx, ]
test <- pima[-idx, ]
```

### 03 로지스틱 회귀(Logistic regression) 모델 구하기
* 지도학습(Supervised Learning)의 한 종류 
* 종속변수가 범주형인 데이터에 사용되는 기법.
* 
```{r}
m <- glm(test ~ pregnant + glucose + bmi, family=binomial, data=train)
m
```

```{r}
summary(m)
```
* pregnant, glucose, bmi의 p-value중에 가장 낮은 것이 glucose이므로 예측력이 좀 더 강해 보인다.

### 04 모델을 이용하여 예측을 수행하기
* predict(모델, newdata=데이터, type=[])
```{r}
pred <- predict(m , newdata = test , type = "response")
pred[0:10]  # 10개만 보기

# 0 또는 1로 해야 하므로 0.5를 기준으로 TRUE(1), FALSE(0)로 나눈다.
pred <- as.integer(pred > 0.5)
pred[0:10]  # 10개만 보기
```

### 05 모델 평가

### (1) 분할표 확인
```{r}
actual <- test[ , "test"]
xt = xtabs( ~ pred + actual)
xt
# 확률로 분할표 보기 
prop.table(xt)
```

### (2) confusionMatrix 확인
```{r}
# caret 패키지를 이용한 정확도 및 기타 확인
# library(caret)
pred <- as.factor(pred)
confusionMatrix(pred, actual)
```

* 약 80%의 정확도

### (3) ROC 커브 그리기
```{r}
library(ROCR)
pred_prob <- predict(m , newdata = test , type = "response")  # 확률 값
str(test)

# ROC 커브를 위한 pima의 test 변수을 labels로 지정
labels <- test[  ,"test"] 
pred3 <- prediction(pred_prob , labels)
plot(performance(pred3 , "tpr" , "fpr"))

# AUC 값 확인(1의 값에 가까울 수록 좋다.)
performance(pred3, "auc")
```


### 더 알아보기
### 로지스틱 회귀에서의 R^2유사한 개념
* Mcfadden R^2
* r2CU를 확인해 보면 약 35%임을 알 수 있음.
```{r}
library(pscl)
pR2(m)
```
