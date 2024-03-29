---
title: "R_ML_STAT_02_모델만들기"
output: html_document
---

### 01 데이터 준비 
```{r}
kor <- c(50,70,80,90,100)
eng <- c(77,88,99,100,70)
math <- c(55, 75, 85, 95, 105)
```


```{r}
all_score <- data.frame(kor, eng, math)
all_score
```

### 02. 모델 생성(1)
* lm(패턴, 데이터)
```{r}
model1 <- lm(math~kor, data=all_score)
model1
```

* 모델 y = 1 * x1(kor) + 5


### 02. 모델 생성(2)
* lm(패턴, 데이터)
```{r}
model2 <- lm(math~kor+eng, data=all_score)
model2
```

### 03. 모델을 이용한 예측
* lm(패턴, 데이터) 모델을 이용하여 생성 후, 우리는 predict()를 이용하여 예측값을 구할 수 있다.
```{r}
# 하나의 변수로 이용한 예측
dat <- data.frame(kor=c(80,85))
pred1 <- predict(model1, newdata=dat)
pred1

# 두개의 변수로 이용한 예측
dat <- data.frame(kor=c(80,85), eng=c(50,60))
pred2 <- predict(model2, newdata=dat)
pred2

```

### 04. 모델 평가
* p-value 가 0.05보다 적어 가설이 유의하다.(OK)
* 결정계수 1로 100% 설명이 가능하다. 
```{r}
summary(model1)
```

* p-value 가 0.05보다 적어 가설이 유의하다.(OK)
* 결정계수 1로 100% 설명이 가능하다.
```{r}
summary(model2)
```

#### (실습 해보기1) 국어, 영어, 역사 데이터를 입력 후, 모델을 만들고 아래 새로운 데이터에 대한 예측을 해 보자.

#### (실습 해보기2) Bike 데이터를 불러온 후, Bike 데이터를 이용하여 선형 회귀 모델을 만들어 보자.

