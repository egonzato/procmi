# generate random variables 
# set number of obs
n=1000
# dependent 
y=rnorm(n,10,5)
# independent
matrix=matrix(NA,nrow=n,ncol=1)
matrix[,1]=y
# continuous variables
for (i in 1:4){
  set.seed(181299)
  mu=i*12
  sigma=2*sqrt(i)
  cont=rnorm(n,mu,sigma)
  matrix=cbind(matrix,cont)
}
# categorical variables
for (j in 1:4){
  set.seed(181299)
  p=ifelse(j>2,0.25,0.6)
  k=ifelse(j>2,5,7)
  cat=rbinom(1000,k,p)
  matrix=cbind(matrix,cat)
}
# turn to df
matrix=as.data.frame(matrix)
# change name vars
nindep=ncol(matrix)
b=2
for (b in 2:nindep){
names(matrix)[b]=paste('V',b,sep='')
}
# number of missing values to enter cols
nmiss=50
# generate random values in different positions for each variable
for (m in seq(2,8,2)){
  set.seed(10*m)
  miss=sample(n,nmiss)
  matrix[miss,m]=NA
}
# to check missing values are in different positions
verify=c()
for (mm in 1:ncol(matrix)){
  m=which(is.na(matrix[,mm]))
  verify=c(verify,m)
}
# cut to one to say there is at least one missing value
ver.unique=unique(verify)
# 193 observations have at least one missing 80.7% 
# of the dataset has obs for each var
