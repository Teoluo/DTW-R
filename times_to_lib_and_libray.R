library(spacetime)
library(trajectories)
library(SimilarityMeasures)
# 定义一个向量来存储所有学生的图书馆访问次数
stuNum2<-c()
id<-c()
# 循环从0到结束  遍历文件
for (i in 0:59){
    fileNum<-formatC(i, width = 2, flag = 0)
    if(test <- file.exists(paste('G:/空间数据分析/gps/gps_u',fileNum,'.csv',sep=''))==TRUE){
    gps_00 <- read.csv(paste('G:/空间数据分析/gps/gps_u',fileNum,'.csv',sep=''),header = TRUE,sep=',')
    tras<-c()
    
    # 存放多条轨迹
    tmp<-c()
    # 存放x坐标
    x<-c()
    # 存放y坐标
    y<-c()
    # 存放学生ID
    id<-c(id,i)
    
    # tss<-c()
    # result<-0
    # 该学生在一天内去过图书馆就加一
    count=0
    A=0

    flag <- as.Date("1970-01-01")
    for (i in 1:nrow(gps_00) ) {
        # i 为时间戳类型数据
        t = gps_00[i,'time']
        
        ts = as.POSIXct(t, origin="1970-01-01 00:00:00")
        #print(paste(t,ts,gps_00[i,'latitude']))
      
        year <-  format(ts,format = "%Y")
        mouth <-  format(ts,format = "%m")
        day <-  format(ts,format = "%d")
        # 此字段的日期
        today <- paste(format(ts,format = "%Y"),format(ts,format = "%m"),format(ts,format = "%d"),sep = "-")
      
        if(today != flag){
          
          # 图书馆1
          polyx1 = c(43.704625, 43.704264, 43.704264, 43.704625)
          polyy1 = c(-72.288379, -72.288379, -72.287990, -72.287990)
          # 图书馆2
          polyx2 = c(43.706062, 43.706923, 43.706923, 43.706062)
          polyy2 = c(-72.288131, -72.288131, -72.286695, -72.286695)
          
          # 43.704122, -72.289391 43.702509, -72.287785
          # 43.703180, -72.291517 43.702967, -72.290439
          # 43.705025, -72.294287 43.703241, -72.291347
          # 43.703917, -72.286132 43.707903, -72.283260
          # 43.704625, -72.288379 43.704264, -72.287990
          # 43.706923, -72.288131 43.706062, -72.286695
          # # 图书馆1
          # polyx1 = c(43.705901, 43.704699, 43.704699, 43.705901)
          # polyy1 = c(-72.289419, -72.289419, -72.288153, -72.288153)
          # # 图书馆2
          # polyx2 = c(43.704971, 43.706460, 43.706460, 43.704971)
          # polyy2 = c(-72.286634, -72.286634, -72.286079, -72.286079)
          
          flag<-today
          x<-c(x,gps_00[i,'latitude'])
          y<-c(y,gps_00[i,'longitude'])
          
          # 判断在一天内 是否去过图书馆一次 
          if(((x<polyx1[1] && x>polyx1[2]) && (y<polyy1[3] && y>polyy1[1])) || ((x<polyx2[2] && x>polyx2[1]) && (y<polyy2[3] && y>polyy2[1])))
          {
            print("AAAAAAAAAAAAA")
            count=count+1
            A=1
            next()
          }
        }else{
          # print("在工作")
          x<-c(x,gps_00[i,'latitude'])
          y<-c(y,gps_00[i,'longitude'])
          if(((x<polyx1[1] && x>polyx1[2]) && (y<polyy1[3] && y>polyy1[1])) || ((x<polyx2[2] && x>polyx2[1]) && (y<polyy2[3] && y>polyy2[1])))
          {
            if(A==0)
            {
              print("BBBBBBBBBBBBB")
              count=count+1
              next()
            }
          }
        }
    }
    stuNum2<-c(stuNum2,count)
    }else{
      # 没有这个数据文件  就执行下一次循环
       next()
    }
    print("OK")
}

df <- data.frame(uid,stuNum2)
write.csv(df,file="G:/空间数据分析/gps/study2.csv")
