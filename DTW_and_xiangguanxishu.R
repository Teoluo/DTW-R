library(spacetime)
library(trajectories)
library(SimilarityMeasures)

# ����������ݷ�Ϊһ��һ��������
# ÿһ���������ʱ��η�Χ�Ĵ�ȡ����
# ���ƹ켣 �ټ���DTW

uid<-c()
DTW<-c()
# ѭ����0������  �����ļ�
for (i in 0:59){
  # ��ʽ������
  fileNum<-formatC(i, width = 2, flag = 0)
  tezhengzhi<-0
  # �ж��ļ��Ƿ����
  if(test <- file.exists(paste('G:/�ռ����ݷ���/gps/gps_u',fileNum,'.csv',sep=''))==TRUE){
    
    # ��ȡ�ļ�
    gps_00 <- read.csv(paste('G:/�ռ����ݷ���/gps/gps_u',fileNum,'.csv',sep=''),header = TRUE,sep=',')
    
    # ���ڴ�Ŷ����켣
    tmp<-c()
    # ���ڴ��x����
    x<-c()
    # ���ڴ��y����
    y<-c()
    # ���ڴ��ʱ��
    tss<-c()
    # ���ڴ��DTW������
    result<-c()
    # 
    resultCount<-0
    
    
    # ������ʼ�ͽ���ʱ��
    flag <- as.Date("1970-01-01")
    startFlag=paste(flag,"00:00:00")
    endFlag=paste(flag,"23:00:00")
    
    # ������������
    for (i in 1:nrow(gps_00) ) {
      
      # t  Ϊʱ�����������
      t = gps_00[i,'time']
      
      # ts Ϊһ���ʱ����������
      ts = as.POSIXct(t, origin="1970-01-01 00:00:00")
      
      # ��ȡ��������ʱ��������� ����ʽ��ʱ��
      year <-  format(ts,format = "%Y")
      mouth <-  format(ts,format = "%m")
      day <-  format(ts,format = "%d")
      today <- paste(format(ts,format = "%Y"),format(ts,format = "%m"),format(ts,format = "%d"),sep = "-")
      
      
      if(today != flag) {
        # �������һ�� �Ȱ�flag��Ϊ�µ�����
        flag<-today
        startFlag=paste(flag,"00:00:00")
        endFlag=paste(flag,"23:00:00")
        
        # �ڹ涨��Χ֮��
        if(length(x)==0 && length(y)==0 ){
          
          # ��һ�ζ����� ǰ��û�д�ȡ�κ����ݵ����
          if(ts>=startFlag  && ts<endFlag){
            # print("ǰ��û�� ���ڹ涨��Χ֮�� ��¼����")
            x<-c(x,gps_00[i,'latitude'])
            y<-c(y,gps_00[i,'longitude'])
            tss<-c(tss,gps_00[i,'time'])
          }
        }
        else{
          # print("ǰ���������� ˵�����µ�һ���� ")
          require(rgdal)
          crs = CRS("+proj=longlat +ellps=WGS84")
          tss<-as.POSIXct(tss,origin="1970-01-01 00:00:00")
          length(cbind(x,y))
          length(tss)
          length(data.frame(co2 = rnorm(length(x))))
          if(length(tss)>=2 ){
            stidf = STIDF(SpatialPoints(cbind(x,y),crs),tss,data.frame(co2 = rnorm(length(x))))
            
            # ����һ���켣
            A0= Track(stidf)
            # �ѹ켣������
            tmp<-c(tmp,A0)
          }else {
            
          }
          
          
          # ����Ϊ0
          x<-c()
          y<-c()
          tss<-c()
          
          # ����������ڷ�Χ֮�� �ʹ�����
          if(ts>=startFlag  && ts<endFlag){
            x<-c(x,gps_00[i,'latitude'])
            y<-c(y,gps_00[i,'longitude'])
            tss<-c(tss,gps_00[i,'time'])
          }
        }  
      }
      else {
        # print("ǰ���Ѿ���������")
        
        # �������� ����ڷ�Χ��  ���������ݽ�ȥ
        if(ts>=startFlag && ts<endFlag){
          x<-c(x,gps_00[i,'latitude'])
          y<-c(y,gps_00[i,'longitude'])
          tss<-c(tss,gps_00[i,'time'])
        }
      }
    }
    
    # �ѹ켣������
    A = Tracks(tmp)
    end=length(A@tracks)-1
    # ���������켣 ����DTW��ֵ��������ƽ��Ȩֵ
    for( i in 1:end){
      D1<-A@tracks[[i]]@sp@coords
      D2<-A@tracks[[i+1]]@sp@coords
      
      #result<-c(result,DTW(D1, D2, -1))
      resultCount<-(resultCount+DTW(D1, D2, -1))
    }
    
    resultCount<-resultCount/end
    print(resultCount)
    
    
  }else{
    # û����������ļ�  ��ִ����һ��ѭ��
    # uid <- c(uid,paste('u',fileNum,sep=""))
    # DTW <- c(DTW,NA)
    next()
  }
  
  uid <- c(uid,paste('u',fileNum,sep=""))
  DTW <- c(DTW,resultCount)
}


tezhen<-data.frame(uid,DTW)
write.csv(tezhen,file="G:/�ռ����ݷ���/gps/data.csv")


data<-read.csv(file="G:/�ռ����ݷ���/gps/data.csv")

gpa<-read.csv(file="G:/�ռ����ݷ���/gps/gpa.csv")
# 
library<-read.csv(file="G:/�ռ����ݷ���/gps/library.csv")
study2<-read.csv(file="G:/�ռ����ݷ���/gps/study2.csv")
x<-0
y<-0
all<-merge(data,library,by="uid")
all2<-merge(gpa,all,by="uid")
all3<-merge(study2,all2,by="uid")
write.csv(all,file="G:/�ռ����ݷ���/gps/all.csv")
write.csv(all2,file="G:/�ռ����ݷ���/gps/all2.csv")
write.csv(all3,file="G:/�ռ����ݷ���/gps/all3.csv")

for(i in 1:nrow(all3)){
  x=x+all3[i,'DTW']
  y=y+all3[i,'gpa.all']
}
xp<-x/nrow(all3)
yp<-y/nrow(all3)
xp
yp


s1<-0
for(i in 1:nrow(all3)){
  s1=s1+(all3[i,'DTW']-xp)*(all3[i,'gpa.all']-yp)
}
sxy=s1/(nrow(all3)-1)
sxy
s2=0
for(i in 1:nrow(all3)){
  s2=s2+(all3[i,'DTW']-xp)**2
}
sx=(s2/(nrow(all3)-1))**(1/2)
sx

s3=0
for(i in 1:nrow(all3)){
  s3=s3+(all3[i,'gpa.all']-yp)**2
}
sy=(s3/(nrow(all3)-1))**(1/2)
sy

rxy=sxy/(sx*sy)
rxy