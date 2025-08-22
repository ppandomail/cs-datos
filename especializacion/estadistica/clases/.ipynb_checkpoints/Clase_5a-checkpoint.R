## Clase 5 de Fundamentos de Estadística 2025
## SP
## Tema: ANOVA y tablas de contingencia

library(readxl)
library(ggplot2)

# Se tiene una muestra de 146 estudiantes de escuelas medias sobre los que se relevó
# información. Se considera que esta muestra representa a los estudiantes de una población.

#repasemos cómo leer bases de distinto tipo:
estudiantes<- read_xlsx("estudiantes_completa.xlsx")
str(estudiantes)

library(readr)
estudiantes2<- read.table("estudiantes_completa.txt", header = T) 
str(estudiantes2)
estudiantes2<- read.table("estudiantes_completa.txt", header = T, dec=",") 
str(estudiantes2)
estudiantes3<- read.csv("estudiantes_completa.csv", header = T, sep=";", dec=",") 
str(estudiantes3)

## Seguimos... revisar cuales hay que convertir a factor:
summary(estudiantes)
str(estudiantes)
estudiantes<-estudiantes[,-1]
estudiantes$sexo<-as.factor(estudiantes$sexo)
estudiantes$fuma<-as.factor(estudiantes$fuma)
estudiantes$colegio<-as.factor(estudiantes$colegio)
estudiantes$clases<-as.factor(estudiantes$clases)
estudiantes$interes<-as.factor(estudiantes$interes)
summary(estudiantes)

##############################################################
## ANOVA: COMPARACION DE MAS DE 2 MEDIAS EN POBLACIONES INDEP
##############################################################

# Hay que verificar normalidad y homogeneidad de varianzas:

# quiero comparar la media de (cuanti=) nota  según (cuali=) área de interés. 

####  PRUEBAS DE NORMALIDAD ####
#graficamente: QQplots
par(mfrow = c(2,2))
qqnorm(estudiantes[estudiantes$interes == "Lengua",]$nota, main = "Lengua")
qqline(estudiantes[estudiantes$interes == "Lengua",]$nota)
qqnorm(estudiantes[estudiantes$interes == "Matematica",]$nota, main = "Matematica")
qqline(estudiantes[estudiantes$interes == "Matematica",]$nota)
qqnorm(estudiantes[estudiantes$interes == "Naturales",]$nota, main = "Naturales")
qqline(estudiantes[estudiantes$interes == "Naturales",]$nota)
qqnorm(estudiantes[estudiantes$interes == "Sociales",]$nota, main = "Sociales")
qqline(estudiantes[estudiantes$interes == "Sociales",]$nota)
par(mfrow = c(1,1))

library("nortest")
## lillie.test(x = estudiantes$nota) #OJO!! esto mira la normalidad en general, necesitamos verificar por grupo

by(data = estudiantes,INDICES = estudiantes$interes,FUN = function(x){ lillie.test(x$nota)})
# H0: la distribucion es Normal   H1: no lo es
#se cumple la normalidad en cada grupo!

####  PRUEBA DE IGUALDAD DE VARIANZAS ####
## H0: las varianzas son iguales para todos los grupos H1: no son iguales
bartlett.test(nota ~ interes,data=estudiantes)
library(car)
leveneTest(nota~interes,data=estudiantes)
# no hay evidencia para rechazar homogeneidad (igualdad) de varianzas

####### ANOVA ######
anova1<-aov(nota~interes,data=estudiantes ) # aov(cuanti~ cuali, data= )
summary(anova1)
# pvalor<2e-16 ***  muy chico! 
#entonces hay evidencia para decir que las medias son distintas (algunas al menos..)


# COMPARACIONES a posteriori
intervalos<-TukeyHSD(anova1) #hace todas las comparaciones de a pares. 
plot(intervalos) #los IC son de nivel 0,95. Si contienen a 0 no se puede rechazar que las medias son =
# qué medias se puede decir que sean distintas??
# Matematica-Lengua    -2.4583333 -3.0290522 -1.8876144 pvalor= 0.0000000 entonces
# (hay evidencia para decir que) nota media Mate es distinta de nota media Lengua

#Sociales-Naturales   -0.2813793 -0.9373981  0.3746395 pvalor= 0.6808700 entonces
# no se puede decir que nota media Soc sea distinta de nota media Nat

# otra forma de comparar de a pares: Bonferroni
pairwise.t.test(x = estudiantes$nota, g = estudiantes$interes, p.adjust.method = "bonferroni",
                pool.sd = TRUE, paired = FALSE, alternative = "two.sided")

# otra forma de comparar de a pares: HOLM
pairwise.t.test(x = estudiantes$nota, g = estudiantes$interes, p.adjust.method = "holm",
                pool.sd = TRUE, paired = FALSE, alternative = "two.sided")

### Tamaño de efecto
# mide cuanto afecta la variable independiente (factor) a la variable dependiente.
library(lsr)
etaSquared(anova1) # <0.01 es chico; en medio mediano; >0.14 es grande
# da 0.49 así que decimos que la incidencia es grande!

### SI NO HAY HOMOGENEIDAD DE VARIANZAS ##

#ver que la variable "parcial" no cumple condicion de normalidad ni de homogeneidad, 
#entonces pueden hacerse estos test similares al anova:
# igual que en comparacion de medias, se usa la aproximacion de Welch:
oneway.test(parcial~interes,data=estudiantes)

## También se puede hacer pruebas no paramétricas, que no suponen distribución
kruskal.test(parcial~interes,data=estudiantes)
pairwise.t.test(x = estudiantes$parcial, g = estudiantes$interes, p.adjust.method = "bonferroni",
                pool.sd = TRUE, paired = FALSE, alternative = "two.sided")

########################################
####### TABLAS DE CONTINGENCIA #########
########################################

# En principio, se trata de algo descriptivo para dos cualis.
contingencia<- table(estudiantes$sexo, estudiantes$interes)

margin.table(contingencia, 1) #para frecuencias fila  
margin.table(contingencia, 2) #para frecuencias columna

prop.table(contingencia) #proporciones del total
sum(prop.table(contingencia)) #se verifica que la suma sea 1!

#se puede probar la hipotesis H0: las variables son indep H1: las variables están relacionadas (no indep)
#para hacer la prueba de independencia:
chisq.test(contingencia, correct = F) # la correccion se usa para tablas 2x2, en otro caso da igual
# p-value = 0.7447 no hay evidencia para decir que hay asociación o que son dep

#para calcular varias medidas de asociacion:
library(vcd)
assocstats(contingencia)
#Pearson          1.2349  3  0.74465 #da la prueba chi cuadrad, lo último es el pvalor
## Phi-Coefficient   : NA    # para tablas 2x2
## Contingency Coeff.: 0.092  #toma valores entre 0 y 1 (o menos), o sea este es muy bajo!
## Cramer's V        : 0.092 

# dan igual?? pongamos las formulas..
chi <- chisq.test(contingencia)
Coef_contingencia=sqrt(chi$statistic / (chi$statistic + sum(contingencia)))
V_Cramer=sqrt(chi$statistic / (sum(contingencia)))

#Conclusion: ambas medidas dan muy baja asociacion, lo que es coherente con la independencia

####################################################
# Veamos otro ejemplo:
contingencia2<- table(estudiantes$colegio, estudiantes$clases)

margin.table(contingencia2, 1) #para frecuencias fila  
margin.table(contingencia2, 2) #para frecuencias columna

prop.table(contingencia2) #proporciones del total
sum(prop.table(contingencia2)) #se verifica que la suma sea 1!

#se puede probar la hipotesis H0: las variables son indep H1: las variables están relacionadas (no indep)
#para hacer la prueba de independencia:
chisq.test(contingencia2, correct = T) # la correccion se usa para tablas 2x2, en otro caso da igual

#para calcular varias medidas de asociacion:
library(vcd)
assocstats(contingencia2)

