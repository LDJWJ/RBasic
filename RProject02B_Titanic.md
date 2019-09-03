---
title: "Rproject02B_Titanic"
output: 
  html_document :
    toc: true
    toc_depth: 3
    toc_float: true
---

### 01 라이브러리 불러오기
* dplyr : 데이터 처리
* caret : 모델 평가
* rpart : 의사결정트리
* randomForest : 랜덤 포레스트(앙상블)
```{r}
library(dplyr)
library(caret)
library(rpart)
library(randomForest)
set.seed(1004)
```


### 02 데이터 불러오기
```{r}
train <-  read.csv("./R_Data/titanic_train.csv", stringsAsFactors=F, na.strings = c("", "NA"))
test <- read.csv("./R_Data/titanic_test.csv", stringsAsFactors=F, na.strings = c("", "NA"))
sub <- read.csv("./R_Data/sample_submission.csv", stringsAsFactors=F)
```

### 03 데이터 전처리
* 학습용 데이터, 테스트 데이터를 하나로 만들어 처리.
```{r}
test$Survived <- NA
all <- rbind(train, test)
colSums(is.na(all))
```

### 범주형으로 변환
* 성별(Sex)
* 생존 유무(Survived)
* 등급(Pclass)
```{r}
all$Sex <- as.factor(all$Sex)
all$Survived <- as.factor(all$Survived)
all$Pclass <- as.ordered(all$Pclass)
str(all)
```

### 파생변수 생성 
* Pclass와 Sex를 이용한 변수 생성
```{r}
all$PclassSex[all$Pclass=='1' & all$Sex=='male'] <- 'P1Male'
all$PclassSex[all$Pclass=='2' & all$Sex=='male'] <- 'P2Male'
all$PclassSex[all$Pclass=='3' & all$Sex=='male'] <- 'P3Male'
all$PclassSex[all$Pclass=='1' & all$Sex=='female'] <- 'P1Female'
all$PclassSex[all$Pclass=='2' & all$Sex=='female'] <- 'P2Female'
all$PclassSex[all$Pclass=='3' & all$Sex=='female'] <- 'P3Female'
all$PclassSex <- as.factor(all$PclassSex)
names(all); table(all$PclassSex)
```

### 03 데이터 전처리
#### 결측치 확인 
* Pclass와 Sex를 이용한 변수 생성
```{r}
all[is.na(all$Fare), ]

all[is.na(all$Embarked), ]

```

###
```{r}
names(all)
str(all)
all %>% group_by(PclassSex) %>% summarise(n=n(), 
                                          mean_age=mean(Age, na.rm=T), 
                                          median_age=median(Age, na.rm=T))
```

### 결측치 처리 
* 정박항은 다수의 값으로
* 나이는 등급별/성별 중앙값으로
```{r}
all[ is.na(all$Embarked), 'Embarked'] = 'S'
all[ is.na(all$Fare), 'Fare'] = median(all$Fare,na.rm=T)

all[ is.na(all$Age) & all$PclassSex=="P1Female", 'Age'] = 36
all[ is.na(all$Age) & all$PclassSex=="P1Male", 'Age'] = 42

all[ is.na(all$Age) & all$PclassSex=="P2Female", 'Age'] = 28
all[ is.na(all$Age) & all$PclassSex=="P2Male", 'Age'] = 29.5

all[ is.na(all$Age) & all$PclassSex=="P3Female", 'Age'] = 22
all[ is.na(all$Age) & all$PclassSex=="P3Male", 'Age'] = 25

colSums(is.na(all))
```


### 04 데이터 나누기
* 학습용
* 테스트용(제출)
```{r}
all$Embarked <- as.factor(all$Embarked)
trainClean <- all[!is.na(all$Survived),]
nrow(trainClean); 

# 학습용(모델학습, 모델평가)
idx <- sample(1:nrow(trainClean), size=nrow(trainClean)*0.7, replace=F)
train_tr <- trainClean[idx, ]
train_test <- trainClean[-idx, ]

# 제출용(테스트용)
testClean <- all[is.na(all$Survived),]
nrow(testClean);
```

### 05 데이터 모델 만들기
* 로지스틱 회귀 모델 
```{r}
m <- glm(Survived ~ Pclass + Sex + Age + SibSp + Embarked + PclassSex, family=binomial, data=train_tr)
summary(m)
```

### 05 데이터 모델 학습 후, 예측
```{r}
pred <- predict(m, newdata=train_test, type = "response")
pred[0:15]
pred <- as.integer(pred > 0.5)
pred[0:15]
length(pred)
```

### 05 데이터 모델 학습 후, 예측, 모델 평가
```{r}
actual <- train_test[ ,"Survived"]
xt = xtabs(~ pred + actual) 
xt

# library(caret)
pred <- as.factor(pred)
actual <- as.factor(actual)
confusionMatrix(pred, actual)
```

```{r}
str(train_tr)
```

### 06 데이터 모델 학습 후, 예측, 모델 평가 - 앙상블 모델
```{r}
# library(randomForest)
m2 <- randomForest(Survived ~ Pclass + Sex + PclassSex + SibSp + Age + Fare + Embarked, data=train_tr)
summary(m2)
```

### 06 데이터 모델 학습 후, 예측, 모델 평가 - 앙상블 모델
### 예측
```{r}
rf_pred <- predict(m2, newdata=train_test, type=c("prob"))
rf_pred[0:15]
rf_pred <- predict(m2, newdata=train_test, type=c("class"))
rf_pred[0:15]

length(pred)
```

### 06 데이터 모델 학습 후, 예측, 모델 평가 - 앙상블 모델
```{r}
# library(caret)
actual <- train_test[ ,"Survived"]
pred <- as.factor(rf_pred)
actual <- as.factor(actual)
confusionMatrix(pred, actual)
```

### 07 가장 좋은 모델로 최종 예측
### 예측
```{r}
nrow(testClean)
pred <- predict(m2, newdata=testClean, type="prob")
pred[0:15,2]
length(pred[,2])
pred <- as.integer(pred[,2] > 0.5)
pred[0:15]
length(pred)
```

### 제출
```{r}
sub[ ,'Survived'] = pred
sub[0:15,]
write.csv(sub, file="SecondSub.csv", row.names = F)
list.files(path=".", pattern=NULL)
```


