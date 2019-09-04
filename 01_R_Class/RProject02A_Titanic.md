---
title: "R_ML_PROJECT01_Titanic"
output: 
   html_document:
    toc: true
    toc_depth: 3
    toc_float: true
---

### 00 라이브러리
```{r}
library(Amelia)
library(ggplot2)
```

### 01 데이터 불러오기
* na.strings : 해당되는 문자열을 NA로 처리
* stringsAsFactors : 문자열을 팩터로 할 것인가?
```{r}
train <-  read.csv("./R_Data/titanic_train.csv", stringsAsFactors=F, na.strings = c("", "NA"))
test <- read.csv("./R_Data/titanic_test.csv", stringsAsFactors=F, na.strings = c("", "NA"))
# train <-  read.csv("./R_Data/titanic_train.csv", stringsAsFactors=F)
# test <- read.csv("./R_Data/titanic_test.csv", stringsAsFactors=F)
sub <- read.csv("./R_Data/sample_submission.csv", stringsAsFactors=F)
dim(train); dim(test); dim(sub)
```

### 02 데이터 탐색
* 학습 데이터에 Survived 있음. 
* 테스트 데이터에 Survived가 없음.
```{r}
names(train)
cat("\n")
names(test)
cat("\n")
names(sub)
cat("\n")
str(train)
```

### 03 데이터 결측치 확인 및 처리
* train에 Age
* test에 Age와 Fare

```{r}
# library(Amelia)
missmap(train)
missmap(test)
```

```{r}
colSums(is.na(train))
```

```{r}
colSums(is.na(test))
```

```{r}
par(mfrow=c(1,2))
boxplot(train$Age)
boxplot(test$Age)
```

### 결측치 처리
* 나이(Age)는 중앙값으로 대체
* 정박항(Embarked)는 많이 나온 값으로 대체
```{r}
quantile(train$Age, na.r=T); quantile(test$Age, na.r=T)
```

#### 나이(Age) 결측치 처리
* train(학습 데이터)는 177개 처리
```{r}
## 학습용 데이터 처리 
nrow( train[ is.na(train$Age), ] )
train[ is.na(train$Age), 'Age'] = median(train$Age, na.rm=T)

## 테스트용 데이터 처리 
nrow( test[ is.na(test$Age), ] )
test[ is.na(test$Age), 'Age'] = median(test$Age, na.rm=T)

## 확인
nrow( train[ is.na(train$Age), ] ); nrow( test[ is.na(test$Age), ] )
```

#### 정박항(Embarked) 결측치 처리
```{r}
cnt_tr <- table(train$Embarked, useNA='always')
cnt_test <- table(test$Embarked, useNA='always')
cnt_tr; cnt_test

par(mfrow=c(1,2))
barplot(cnt_tr)
barplot(cnt_test)

ggplot(data=train, aes(x=Embarked)) + geom_bar()
ggplot(data=test, aes(x=Embarked)) + geom_bar()
```

```{r}
## 학습용 데이터 처리 
nrow( train[ is.na(train$Embarked), ] )
train[ is.na(train$Age), 'Age'] = median(train$Age, na.rm=T)

## 테스트용 데이터 처리 
nrow( test[ is.na(test$Embarked), ] )
test[ is.na(test$Age), 'Age'] = median(test$Age, na.rm=T)

train[ is.na(train$Embarked), 'Embarked'] = 'S'
nrow( train[ is.na(train$Embarked), ] )
```

### 데이터 확인
```{r}
colSums(is.na(train))
colSums(is.na(test))
```

### 04 데이터 모델 만들기
```{r}
m <- glm(Survived ~ Pclass + Age + SibSp, family=binomial, data=train)
summary(m)
```

### 예측
```{r}
pred <- predict(m, newdata=test, type = "response")
pred[0:15]
pred <- as.integer(pred > 0.5)
pred[0:15]
```

### 제출
```{r}
sub[ ,'Survived'] = pred
sub[0:15,]
getwd()
write.csv(sub, file="firstSub.csv", row.names = F)
list.files(path=".", pattern=NULL)
```



