library("rpart")

data<-read.csv("E:/BME-MSc-2.felev/bigdata/Dropbox/data/globalterrorismdb_0617dist.csv", header = T, sep = ";", skipNul = T)

# Itt adjuk hozzá az osztályozást az adatokhoz
borders <- as.matrix(c(1,5,10,100))
classes<-rep(0,nrow(data))
for (i in 1:nrow(data))
{
  if(is.na(data[i,'nkill']))
    classes[i]<--1
  else
  {
    for (j in 1:nrow(borders)) 
    {
      if (data[i,'nkill']<borders[j])
      {
        classes[i]<-j
        break()
      }
    }
    if(classes[i]==0)
      classes[i]<-5
  }
}
newdata<-cbind(data,classes)
newdata<-newdata[newdata[,'classes']!=-1,]

tr_idx<-sample(nrow(newdata), nrow(newdata)*0.8)
train<-newdata[tr_idx,]
test<-newdata[-tr_idx,]

tree<-rpart(factor(classes)~iyear+success+suicide+attacktype1+weaptype1+multiple+targtype1+region+country,data=train)
plot(tree)
text(tree,cex=.8)
