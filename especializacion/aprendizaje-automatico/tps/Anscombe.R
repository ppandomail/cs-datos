Anscombe <- read.csv("L:/Mi unidad/CienciaDeDatos/EspecializacionUNO/RegresionLinealSimple/Clase1/Anscombe.csv")

##### VARIABLES x,y1 ##### 
x=Anscombe$x
y1=Anscombe$y1
reg1=lm(y1~x)
reg1
summary(reg1)

#Grafico de dispersion de los datos
plot(x,y1,pch=19,main="Dispersion x-y1",cex.main=2., xlab="x",ylab = "y1",cex.lab=2.8)
abline(reg1,col="red",lwd=2)

#Grafico de los errores
valores.ajustados<-reg1$fitted.values
residuos<-reg1$residuals
plot(valores.ajustados,residuos,pch=19,col="blue")
abline(h=0,col="red")


##### VARIABLES x,y2 ##### 
x=Anscombe$x
y2=Anscombe$y2
reg2=lm(y2~x)
reg2
summary(reg2)
summary(reg1)

#Grafico de dispersion de los datos
plot(x,y2,pch=19,main="Dispersion x-y2",cex.main=2., xlab="x",ylab = "y1",cex.lab=2.8)
abline(reg2,col="red",lwd=2)

#Grafico de los errores
valores.ajustados2<-reg2$fitted.values
residuos2<-reg2$residuals
plot(valores.ajustados2,residuos2,pch=19,col="blue")
abline(h=0,col="red")

##### VARIABLES x,y3 ##### 
x=Anscombe$x
y3=Anscombe$y3
reg3=lm(y3~x)
reg3
summary(reg3)
names(reg3)

#Grafico de dispersion de los datos
plot(x,y3,pch=19,main="Dispersion x-y3",cex.main=2., xlab="x",ylab = "y1",cex.lab=2.8)
abline(reg3,col="red",lwd=2)

#Grafico de los errores
valores.ajustados3<-reg3$fitted.values
residuos3<-reg3$residuals
plot(valores.ajustados3,residuos3,pch=19,col="blue")
abline(h=0,col="red")

##### VARIABLES x4,y4 ##### 
x4=Anscombe$x4
y4=Anscombe$y4
reg4=lm(y4~x4)
reg4
summary(reg4)

#Grafico de dispersion de los datos
plot(x4,y4,pch=19,main="Dispersion x4-y4",cex.main=2., xlab="x",ylab = "y1",cex.lab=2.8)
abline(reg4,col="red",lwd=2)

#Grafico de los errores
valores.ajustados4<-reg4$fitted.values
residuos4<-reg4$residuals
plot(valores.ajustados4,residuos4,pch=19,col="blue")
abline(h=0,col="red")

nuevos.datos1 <- data.frame(x=7)
nuevos.datos1

nuevos.datos2 <- data.frame(x4=7)
nuevos.datos2


predict(reg1, nuevos.datos1)
predict(reg2, nuevos.datos1)
predict(reg3, nuevos.datos1)
predict(reg4, nuevos.datos2)
