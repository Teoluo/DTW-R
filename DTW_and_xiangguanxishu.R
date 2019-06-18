library(spacetime)
library(trajectories)
library(SimilarityMeasures)

# 将几天的数据分为一天一天来处理
# 每一天里面符合时间段范围的存取下来
# 绘制轨迹 再计算DTW

uid<-c()
DTW<-c()
# 循环从0到结束  遍历文件
for (i in 0:59){
  # 格式化数字
  fileNum<-formatC(i, width = 2, flag = 0)
  tezhengzhi<-0
  # 判断文件是否存在
  if(test <- file.exists(paste('G:/空间数据分析/gps/gps_u',fileNum,'.csv',sep=''))==TRUE){
    
    # 读取文件
    gps_00 <- read.csv(paste('G:/空间数据分析/gps/gps_u',fileNum,'.csv',sep=''),header = TRUE,sep=',')
    
    # 用于存放多条轨迹
    tmp<-c()
    # 用于存放x坐标
    x<-c()
    # 用于存放y坐标
    y<-c()
    # 用于存放时间
    tss<-c()
    # 用于存放DTW计算结果
    result<-c()
    # 
    resultCount<-0
    
    
    # 设置起始和结束时间
    flag <- as.Date("1970-01-01")
    startFlag=paste(flag,"00:00:00")
    endFlag=paste(flag,"23:00:00")
    
    # 遍历所有数据
    for (i in 1:nrow(gps_00) ) {
      
      # t  为时间戳类型数据
      t = gps_00[i,'time']
      
      # ts 为一般的时间类型数据
      ts = as.POSIXct(t, origin="1970-01-01 00:00:00")
      
      # 获取这条数据时间的年月日 并格式化时间
      year <-  format(ts,format = "%Y")
      mouth <-  format(ts,format = "%m")
      day <-  format(ts,format = "%d")
      today <- paste(format(ts,format = "%Y"),format(ts,format = "%m"),format(ts,format = "%d"),sep = "-")
      
      
      if(today != flag) {
        # 如果是新一天 先把flag设为新的日期
        flag<-today
        startFlag=paste(flag,"00:00:00")
        endFlag=paste(flag,"23:00:00")
        
        # 在规定范围之内
        if(length(x)==0 && length(y)==0 ){
          
          # 第一次读数据 前面没有存取任何数据的情况
          if(ts>=startFlag  && ts<endFlag){
            # print("前面没有 又在规定范围之内 记录数据")
            x<-c(x,gps_00[i,'latitude'])
            y<-c(y,gps_00[i,'longitude'])
            tss<-c(tss,gps_00[i,'time'])
          }
        }
        else{
          # print("前面有数据了 说明到新的一次了 ")
          require(rgdal)
          crs = CRS("+proj=longlat +ellps=WGS84")
          tss<-as.POSIXct(tss,origin="1970-01-01 00:00:00")
          length(cbind(x,y))
          length(tss)
          length(data.frame(co2 = rnorm(length(x))))
          if(length(tss)>=2 ){
            stidf = STIDF(SpatialPoints(cbind(x,y),crs),tss,data.frame(co2 = rnorm(length(x))))
            
            # 创建一个轨迹
            A0= Track(stidf)
            # 把轨迹存下来
            tmp<-c(tmp,A0)
          }else {
            
          }
          
          
          # 重置为0
          x<-c()
          y<-c()
          tss<-c()
          
          # 如果数据属于范围之内 就存下来
          if(ts>=startFlag  && ts<endFlag){
            x<-c(x,gps_00[i,'latitude'])
            y<-c(y,gps_00[i,'longitude'])
            tss<-c(tss,gps_00[i,'time'])
          }
        }  
      }
      else {
        # print("前面已经有数据了")
        
        # 有数据了 如果在范围内  就添加数据进去
        if(ts>=startFlag && ts<endFlag){
          x<-c(x,gps_00[i,'latitude'])
          y<-c(y,gps_00[i,'longitude'])
          tss<-c(tss,gps_00[i,'time'])
        }
      }
    }
    
    # 把轨迹存起来
    A = Tracks(tmp)
    end=length(A@tracks)-1
    # 相邻两条轨迹 计算DTW的值，并计算平均权值
    for( i in 1:end){
      D1<-A@tracks[[i]]@sp@coords
      D2<-A@tracks[[i+1]]@sp@coords
      
      #result<-c(result,DTW(D1, D2, -1))
      resultCount<-(resultCount+DTW(D1, D2, -1))
    }
    
    resultCount<-resultCount/end
    print(resultCount)
    
    
  }else{
    # 没有这个数据文件  就执行下一次循环
    # uid <- c(uid,paste('u',fileNum,sep=""))
    # DTW <- c(DTW,NA)
    next()
  }
  
  uid <- c(uid,paste('u',fileNum,sep=""))
  DTW <- c(DTW,resultCount)
}


tezhen<-data.frame(uid,DTW)
write.csv(tezhen,file="G:/空间数据分析/gps/data.csv")


data<-read.csv(file="G:/空间数据分析/gps/data.csv")

gpa<-read.csv(file="G:/空间数据分析/gps/gpa.csv")
# 
library<-read.csv(file="G:/空间数据分析/gps/library.csv")
study2<-read.csv(file="G:/空间数据分析/gps/study2.csv")
x<-0
y<-0
all<-merge(data,library,by="uid")
all2<-merge(gpa,all,by="uid")
all3<-merge(study2,all2,by="uid")
write.csv(all,file="G:/空间数据分析/gps/all.csv")
write.csv(all2,file="G:/空间数据分析/gps/all2.csv")
write.csv(all3,file="G:/空间数据分析/gps/all3.csv")

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
