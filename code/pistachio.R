library(dplyr)
library(writexl)
# read csv file
df=read.csv('G:\\Il mio Drive\\Estate\\git\\pistachio.csv')
# select only some variables
set.seed(181299)
n=sample(nrow(df),500)
df=df[n,c(17,16,1,11)]
# create dummy from chr var
df=df %>% 
  mutate(Class=ifelse(Class=='Kirmizi_Pistachio',1,0))
# simulate categorical variables
origin=rbinom(nrow(df),6,0.6)
color=rbinom(nrow(df),3,0.5)
# add to df
df=cbind(df,color,origin)
# change names
for (i in 1:ncol(df)){
  names(df)[i]=paste('V',i,sep='')
}
# introduce missing values randomly 
nmiss=50
for (j in c(2,5)){
  set.seed(181299*j)
  miss=sample(nrow(df),nmiss)
  df[miss,j]=NA
}
# see how many obs have at least one missing value
j=1
miss=c()
for (j in 1:ncol(df)){
  m=which(is.na(df[,j]))
  miss=c(miss,m)
}
# some obs might have NAs in both vars, need to reduce to unique
length(unique(miss))
# 290 out of 1718 have at least one missing value
write_xlsx(df,'G:\\Il mio Drive\\Estate\\git\\pistna.xlsx')

