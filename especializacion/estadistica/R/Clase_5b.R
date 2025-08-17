## Clase 5 de Fundamentos de Estadística 2025
## SP
## Tema: Ejemplo Cardio

library(readxl)
library(ggplot2)

cardio<- read_excel("Cardio_UCI.xlsx")
str(cardio)
cardio<-cardio[,-1]
cardio$sexo<-as.factor(cardio$sexo)
cardio$cp<-as.factor(cardio$cp)
cardio$restecg<-as.factor(cardio$restecg)
cardio$diag<-as.factor(cardio$diag)
## cuales otras???
summary(cardio)

## ANALISIS DESCRIPTIVO ###
## lo siguiente puede dar info de a pares... solo para vistazo general!
# mejor después dar los gráficos particulares
library(GGally)
ggpairs(cardio)+theme_bw()

## GRAFICOS VARIOS ###
# hacer varios para explorar!!
# ej: una variable cuanti
ggplot(data = cardio, aes(x = presrep )) +
  geom_boxplot() +
  theme_bw()
#ej: dos variables:
ggplot(data = cardio, aes(x = cp, y =presrep )) +
  geom_boxplot() +
  theme_bw()

#ej: dos variables: cuantis vs cuali=Genero
ggplot(data = cardio, aes(x = cp, y =presrep , color=cp)) +
  geom_boxplot() +
  theme_bw()
# tres variables: dos cualis y una cuanti
ggplot(data = cardio, aes(x = cp, y = presrep, color = sexo)) +
  geom_boxplot() +
  theme_bw()

# ej: para dibujar varios juntos
ggplot(data = cardio, mapping = aes(x = presrep, colour = sexo)) +
  geom_histogram() +
  theme_bw() +
  facet_grid(. ~ cp) +
  theme(legend.position = "none")

#### ACOMPAÑAR CON MEDIDAS RESUMEN!
# lo simple sale con 
summary(cardio)
# para sacarlas por grupo:
library(dplyr)
cardio |> group_by(cp) |> 
  summarise(media_presion = mean(presrep),
            varianza_presion = var(presrep),
            desvi_presion = sd(presrep),
            Q1 = quantile(presrep, probs=0.25),
            D4 = quantile(presrep, probs=0.40),
            P90 = quantile(presrep, probs=0.90),
            n = n())

attach(cardio)
### ANALISIS DE NORMALIDAD
qqnorm(presrep)
qqline(presrep)
lillie.test(x = presrep)

##### TEST para una MEDIA ####
# Qué hipótesis de interés pueden plantear para UNA variable cuanti??
#ejemplo
mean(cardio[cp=="3",]$presrep)
# H0: media= 130   H1: media > 130 
t.test(cardio[cp=="3",]$presrep, alternative= "greater", mu=130)
# p-value = 0.4508 no hay evidencia para decir que media >130

##### TEST DE COMPARACION de MEDIAS ####
# Qué hipótesis de interés se puede plantear??
#ejemplo
# H0: media presion en diag1= media presion en diag0   H1: !=
#primero mirar normalidad:

# homogeneidad

#ahora si el test:
t.test(presrep ~ diag,alternative = "two.sided",mu = 0, var.equal = F)

##### ANOVA ######
str(cardio) 
## NINGUNA DE LAS CUANTIS DA NORMAL!!
# de todos modos, la normalidad no es condición estricta si la #casos es grande
library("nortest")
lillie.test(x = presrep)
## HOMOGENEIDAD DE VARIANZAS: 
bartlett.test(presrep ~ cp,data=cardio) #ok
library(car)
leveneTest(presrep ~ cp,data=cardio) #ok

## ANOVA: comparacion de mas de 2 medias
anova1<-aov(presrep ~ cp,data=cardio )
summary(anova1)

intervalos<-TukeyHSD(anova1) #hace todas las comparaciones de a pares. Se ve que son signif 3-1 y 4-3
plot(intervalos) #los IC son de nivel 0,95. Si contienen a 0 no se puede rechazar que las medias son =

# otra forma de comparar de a pares: Bonferroni
pairwise.t.test(x = cardio$presrep, g = cardio$cp, p.adjust.method = "bonferroni",
                pool.sd = TRUE, paired = FALSE, alternative = "two.sided")

# otra forma de comparar de a pares: HOLM
pairwise.t.test(x = cardio$presrep, g = cardio$cp, p.adjust.method = "holm",
                pool.sd = TRUE, paired = FALSE, alternative = "two.sided")

### Tamaño de efecto
# mide cuanto afecta la variable independiente (factor) a la variable dependiente.
library(lsr)
etaSquared(anova1) # <0.01 es chico; en medio mediano; >0.14 es grande
# da 0.022 o sea mediano efecto de cp sobre trestbps

########################################
####### TABLAS DE CONTINGENCIA #########
# analizar relacion entre 2 cualis
#ejemplo: 
tabla<- table(cardio$restecg,cardio$cardio)
tabla
margin.table(tabla, 1) #para frecuencias fila  
margin.table(tabla, 2) #para frecuencias columna
prop.table(tabla) #proporciones del total
chisq.test(tabla, correct = F) # la correccion se usa para tablas 2x2, en otro caso da igual

#para calcular varias medidas de asociacion:
library(vcd)
assocstats(tabla)
