#install.packages("rJava")
#install.packages("memoise")
#install.packages("KoNLP")

library(rJava)
library(memoise)
library(KoNLP)

### 사전 설정하기
useNIADic()

### 데이터 준비하기(스파이더맨 데이터)
# URL : https://github.com/youngwoos/Doit_R/blob/master/Data/hiphop.txt
txt <- readLines("D:\\dataset\\movieText\\SpiderMan.txt")
head(txt)

### 문자열 처리하기
# install.packages("stringr")
library(stringr)

### 특수문자 제거
txt <- str_replace_all(txt, "\\W", " ")
txt

### 명사 추출
### KoNLP의 extractNoun()를 이용
extractNoun("오늘은 즐거운 날이다. 당신은 소중한 사람입니다.")
nouns <- extractNoun(txt)
wordCount <- table(unlist(nouns))

### 데이터 프레임 전환
df_word <- as.data.frame(wordCount, stringsAsFactors = F)

### 변수명 수정
library(dplyr)
df_word <- rename(df_word, word=Var1, freq=Freq)
df_word

### 두글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)
df_word
