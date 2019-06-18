# 基于学生轨迹行为的成绩预测分析

## 1.	摘要
a)	收集了60名大学生GPS的路径记录，并提出了一种新的衡量标准，即衡量每个学生的校园日常生活的规律性。实证分析表明，学业表现（GPA）与规律密切相关。</br>
b)	此外，我们还发现，即使在学生的勤奋工作中，“自律性”是预测学业表现的一个重要特征，它也能显著提高预测的准确性。在这些分析的基础上，教育管理人员可在必要的时候引导学生们的校园生活和工作。

## 2.	数据描述
a)	数据来源：成都信息工程大学网络存储</br>
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/5.png)</br>
b)	规模：60个学生的行为记录</br>
c)	数据字段：</br>
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/1.png)</br>

## 3.	分析框架
我们先对学生的GPA的成绩等级有一个相应的划分</br>
在分类中，将学生GPA大于3.65的设置为等级A，GPA范围在3.65到3.0的设置为等级B，GPA范围在3.0以下的设置为等级C。</br>

我们的分析框架主要有三个特征值:</br>
#### (1)轨迹距离DTW
研究样本学生每天的行为特性，获取限定时间段的学生行为轨迹，再根据样本学生的轨迹信息计算出相应的DTW值
#### (2)进入图书馆的次数
为了有达到更多的特征值辅助我们的预测结果，我们再加上每名样本学生每天到图书馆的次数</br>
#### (3)进入实验楼的次数
为了有达到更多的特征值辅助我们的预测结果，我们再加上每名样本学生每天到实验楼的次数</br>

使用三个特征值用于训练朴素贝叶斯分类器模型，最后已经训练好的训练模型来预测数据学生的GPA等级。

## 4.	数据分析
### 数据分类：
根据时间戳找出每名学生在限定日期里，从 14:00:00到 17:00:00的轨迹活动路径，并将坐标与时间分别保存
### 学生的轨迹（示例）：
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/2.png)</br>
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/6.png)</br>
### 特征提取
#### 成绩分类
根据训练样本进行的朴素贝叶斯分类所划分的等级，
#### 基于DTW（动态时间弯曲）距离的特征提取
如果两条轨迹都无记录点，那么DTW距离为0；如果只有一条轨迹无记录点，则DTW距离为无穷大；如果两条轨迹均存在记录点，则采用递归的方式求取最小的距离作为DTW距离。</br>
如图a，某些点(如r_i,s_n)在计算DTW距离时多次使用，实际上是对时间维的局部拉伸；</br>
图b是记录点对应关系的矩阵表示，黑色方块表示的是最优对应关系形成的DTW路径，其中每个方块的权值为相应记录点间的欧式距离，DTW距离就是整条路径的权值之和。
</br>根据两条相邻轨迹计算DTW值，并计算平均权值</br>
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/4.png)</br>
#### 计算进入图书馆的次数（红色区域）
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/10.png)</br>
#### 计算进入实验楼的次数（绿色区域）
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/10.png)</br>

数据样例
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/3.png)</br>
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/8.png)</br>


## 5.相关系数
相关系数(Correlation coefficient)是反应变量之间关系密切程度的统计指标，相关系数的取值区间在1到-1之间。1表示两个变量完全线性相关，-1表示两个变量完全负相关，0表示两个变量不相关。数据越趋近于0表示相关关系越弱。以下是相关系数的计算公式。</br>
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/11.png)</br>
其中rxy表示样本相关系数，Sxy表示样本协方差，Sx表示X的样本标准差，Sy表示y的样本标准差。下面分别是Sxy协方差和Sx和Sy标准差的计算公式。由于是样本协方差和样本标准差，因此分母使用的是n-1。</br>

## 6.	算法介绍
a)	根据已经遍历的.csv文件所绘制的轨迹计算DTW值，设为特征值1</br>
b)  通过查找学生去图书馆的数据，设为特征值2</br>
c)  通过查找学生去实验楼的数据，设为特征值3</br>
d)  通过朴素贝叶斯分类器，进行分类</br>
e)  预测结果，通过与原始数据进行比对，判断预测的正确程度</br>

## 7.结果
![img](https://github.com/cuit201608/Team1_coding/blob/master/3rd/screenshots/7.png)</br>
我们通过添加多个特征值，缩短选取轨迹的时间，精确将成绩分类，最终可以得到的正确率为：**60.4%**
