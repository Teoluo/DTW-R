library(e1071)
#读取数据
new <- read.csv(file="F:/R语言/数据/data/all3_.csv")
new <- new[,-1]#提取要使用的列
new <- new[,-2]
new <- new[,-3]
new <- new[,-4]
new <- new[,-5]
new
A <- 3.7
B <- 3.0
#gpa分等级A,B,C,D
for (i in 1:length(new[,3])) {
  if(new[i,3] >= A)
  {
    new[i,3]="A"
  }
  else if(new[i,3]< A && new[i,3] >= B){
    new[i,3] = "B"
  }
  else if (new[i,3] < B){
    new[i,3] = "C"
  }
}
#整理数据方便贝叶斯简单运算
new1 <- data.frame(UID=new[,"uid"],DTW=new[,"DTW"],TIME1=new[,"stuNum"],TIME2=new[,"stuNum2"],GPA=new[,"gpa.all"])
#建立数据集
model <- naiveBayes(new1[,2:4],new1[,5])
#进行预测
pred<-predict(model,new1)
#显示预测结果
print(pred)
#进行前后数据比较
count = 0
for (i in 1:length(new1[,5])) {
  if(new1[i,5] == pred[i]){
    count = count + 1
  }
}

sum <- count / length(new1[,5])
sum                   