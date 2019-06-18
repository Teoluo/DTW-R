library(spacetime)
library(trajectories)
library(SimilarityMeasures)
# ����һ���������洢����ѧ����ͼ��ݷ��ʴ���
stuNum2<-c()
id<-c()
# ѭ����0������  �����ļ�
for (i in 0:59){
    fileNum<-formatC(i, width = 2, flag = 0)
    if(test <- file.exists(paste('G:/�ռ����ݷ���/gps/gps_u',fileNum,'.csv',sep=''))==TRUE){
    gps_00 <- read.csv(paste('G:/�ռ����ݷ���/gps/gps_u',fileNum,'.csv',sep=''),header = TRUE,sep=',')
    tras<-c()
    
    # ��Ŷ����켣
    tmp<-c()
    # ���x����
    x<-c()
    # ���y����
    y<-c()
    # ���ѧ��ID
    id<-c(id,i)
    
    # tss<-c()
    # result<-0
    # ��ѧ����һ����ȥ��ͼ��ݾͼ�һ
    count=0
    A=0

    flag <- as.Date("1970-01-01")
    for (i in 1:nrow(gps_00) ) {
        # i Ϊʱ�����������
        t = gps_00[i,'time']
        
        ts = as.POSIXct(t, origin="1970-01-01 00:00:00")
        #print(paste(t,ts,gps_00[i,'latitude']))
      
        year <-  format(ts,format = "%Y")
        mouth <-  format(ts,format = "%m")
        day <-  format(ts,format = "%d")
        # ���ֶε�����
        today <- paste(format(ts,format = "%Y"),format(ts,format = "%m"),format(ts,format = "%d"),sep = "-")
      
        if(today != flag){
          
          # ͼ���1
          polyx1 = c(43.704625, 43.704264, 43.704264, 43.704625)
          polyy1 = c(-72.288379, -72.288379, -72.287990, -72.287990)
          # ͼ���2
          polyx2 = c(43.706062, 43.706923, 43.706923, 43.706062)
          polyy2 = c(-72.288131, -72.288131, -72.286695, -72.286695)
          
          # 43.704122, -72.289391 43.702509, -72.287785
          # 43.703180, -72.291517 43.702967, -72.290439
          # 43.705025, -72.294287 43.703241, -72.291347
          # 43.703917, -72.286132 43.707903, -72.283260
          # 43.704625, -72.288379 43.704264, -72.287990
          # 43.706923, -72.288131 43.706062, -72.286695
          # # ͼ���1
          # polyx1 = c(43.705901, 43.704699, 43.704699, 43.705901)
          # polyy1 = c(-72.289419, -72.289419, -72.288153, -72.288153)
          # # ͼ���2
          # polyx2 = c(43.704971, 43.706460, 43.706460, 43.704971)
          # polyy2 = c(-72.286634, -72.286634, -72.286079, -72.286079)
          
          flag<-today
          x<-c(x,gps_00[i,'latitude'])
          y<-c(y,gps_00[i,'longitude'])
          
          # �ж���һ���� �Ƿ�ȥ��ͼ���һ�� 
          if(((x<polyx1[1] && x>polyx1[2]) && (y<polyy1[3] && y>polyy1[1])) || ((x<polyx2[2] && x>polyx2[1]) && (y<polyy2[3] && y>polyy2[1])))
          {
            print("AAAAAAAAAAAAA")
            count=count+1
            A=1
            next()
          }
        }else{
          # print("�ڹ���")
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
      # û����������ļ�  ��ִ����һ��ѭ��
       next()
    }
    print("OK")
}

df <- data.frame(uid,stuNum2)
write.csv(df,file="G:/�ռ����ݷ���/gps/study2.csv")