library("rpart")
library("corrgram")

data<-read.csv("E:/BME-MSc-2.felev/bigdata/Dropbox/data/globalterrorismdb_0617dist.csv", header = T, sep = ";", skipNul = T)

vars2 <- c("iyear","imonth","iday","extended","country","region", "specificity","vicinity","multiple","success","suicide", 
           "attacktype1", "targtype1", "natlty1", "guncertain1", "individual", "weaptype1", "nwound")
round(cor(data[,vars2], use="pair"),2)
corrgram(data[,vars2], order = T, lower.panel = panel.shade, upper.panel = panel.pie)

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

tree<-rpart(factor(classes)~eventid+iyear+imonth+iday+extended+country+region+specificity+vicinity+crit1+crit2+crit3+doubtterr+
            multiple+success+suicide+attacktype1+targtype1+natlty1+guncertain1+individual+weaptype1+property+ishostkid+ransom+
            INT_LOG+INT_IDEO+INT_MISC+INT_ANY+targsubtype1+weapsubtype1+nwound+propextent+alternative+attacktype2+attacktype3+
            targtype2+targsubtype2+natlty2+targtype3+targsubtype3+natlty3+guncertain2+guncertain3+nperps+claimed+claimmode+claim2+
            claimmode2+claim3+claimmode3+compclaim+weaptype2+weapsubtype2+weaptype3+weapsubtype3+weaptype4+weapsubtype4+nwoundte+
            nhostkid+hostkidoutcome+ndays+nreleased,data=train)
plot(tree)
text(tree,cex=.8)
