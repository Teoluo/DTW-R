library(e1071)
#��ȡ����
new <- read.csv(file="F:/R����/����/data/all3_.csv")
new <- new[,-1]#��ȡҪʹ�õ���
new <- new[,-2]
new <- new[,-3]
new <- new[,-4]
new <- new[,-5]
new
A <- 3.7
B <- 3.0
#gpa�ֵȼ�A,B,C,D
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
#�������ݷ��㱴Ҷ˹������
new1 <- data.frame(UID=new[,"uid"],DTW=new[,"DTW"],TIME1=new[,"stuNum"],TIME2=new[,"stuNum2"],GPA=new[,"gpa.all"])
#�������ݼ�
model <- naiveBayes(new1[,2:4],new1[,5])
#����Ԥ��
pred<-predict(model,new1)
#��ʾԤ����
print(pred)
#����ǰ�����ݱȽ�
count = 0
for (i in 1:length(new1[,5])) {
  if(new1[i,5] == pred[i]){
    count = count + 1
  }
}

sum <- count / length(new1[,5])
sum                   