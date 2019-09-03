#### (실습 해보기2) Bike 데이터를 불러온 후, Bike 데이터를 이용하여 선형 회귀 모델을 만들어 보자.

# .libPath("~/myrlibrary")
# install.packages("Amelia")
# 최신 유지 : update.pacages()
# 최신 베타 버전 설치
# install.packages("Amelia", repos = "http://gking.harvard.edu")

library(Amelia)

setwd("D:\\dataset\\Bike")
train <- read.csv("train.csv")
test <- read.csv("test.csv")

dim(train); dim(test)
missmap(train)
missmap(test)

## 데이터 살펴보기 
dim(train); dim(test)
missmap(train)
missmap(test)
# pairs(train[, 2:9])

str(train)
## 모델 생성
model <- lm(count~temp+humidity, data=train)
model

## 예측
pred <- predict(model, newdata=test)
pred
