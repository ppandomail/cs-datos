# Fundamentos de Estadística

* Prof: Mg. Silvia Pérez
* [Email](sperez@uno.edu.ar)

## Evaluación

* TP individual: conjunto de datos + preguntas sobre esos datos. Entrega: sab 24/5
* TP grupal: integrador utilizando un conjunto de datos a elección (análisis exploratorio + informe)

## ¿Qué es la estadística?

* Es la rama de las matemáticas que se encarga de recopilar, organizar y analizar datos

## ¿Por qué necesitamos entender Estadística?

* Comprender el mundo que nos rodea
* Hipótesis se cumple o no
* Para explicar la realidad mediante: datos, tablas, gráficos
* Para inferir o predecir

## ¿Cómo obtenemos los datos?

* Recolección propia
* Información disponible
* Recoleccion de terceros
* Bases de organismos públicos
* Etc

## ¿Qué pretendemos de nuestros datos?

* Análisis exploratorio (muestro lo que veo y busco relaciones)
* Inferencia estadística (predigo algo que no veo)

## Etapas del proceso estadístico

1. Datos de una muestra representativa de una población
2. Mediante inferencia --> Modelar información: modelos probabilísticos para las variables
3. Relaciones entre variables: modelos estadísticos

## Población

* Es el conjunto de individuos sobre el que se va a estudiar una característica (se quiere saber algo)
* Todos ...

## Individuo

* O unidad estadística, es cada uno de los elementos que componen la población
* Cada uno de los ...

## Muestra

* Un conjunto representativo de la población
* Generalmente es el grupo de individuos a quienes se le "pregunta"
* La cantidad seleccionada es ...

## Dato

* Cada uno de los valores obtenidos ("respuestas")

## Variables observadas en los datos

* **Variables** en columnas: edad, título, residencia, ...
  * característica o propiedades del objeto de estudio
* **Casos** en filas: {45, médico, CABA}, {53, contador, CABA}, ...

  ```R
  datos <- read.table("BD.txt", header =  F, sep = ",")
  colnames(datos) <- c("Col1", "Col2", "Col3")
  head(datos)
  ```

## Tipos de variables

* **Cualitativas o Categóricas**: se refieren a características o cualidades que no pueden ser medidas en números
  * Nominales (sin orden): título, ciudad, color preferido, deporte favorito, etc.
  * Ordinales (con orden): cargo, notas de un examen (SS, B, R, M), medallas ganadas (oro, plata, bronce), primer apellido, etc.
* **Cuantitativas o Numéricas**: se expresa mediante un número, se pueden realizar operaciones con ellas
  * Discretas (entero, número finito de valores): cant de materias aprobadas, número de hermanos, etc.
  * Continuas (real, número infinito de valores): edad, tiempo de obtención de título, peso de un balón, etc.

  ```R
  str(datos)
  Col1: chr "M" "M" "F" ...
  Col2: num 0.45 0.35 0.67 ...
  Col3: int 15 7 19 ...
  ```

## Análisis exploratorio de datos: univariado

* gráficos: circulares, barras, histogramas, boxplot, etc
* tablas: frecuencias, etc.
* medidas resumen: media, mediana, moda, desvío, mínimo, percentiles, etc.

## Representación gráfica: cualitativas

* Barras: categóricas y discretas

  ```R
  barplot(datos)
  ```

* Circular o sectores: nominales u ordinales

  ```R
  pie(datos)
  ```

## Tablas de frecuencias para variables cualitativas

* **Frecuencia**: es el número de ocurrencias de un valor o categoría
* Se pueden construir tablas con distintos tipos de frecuencias
* Acumuladas (Fi y Hi): sólo tiene sentido si es una variable ordinal

  | Calificación | fi (frec absoluta) | hi (frec relativa) = fi/n | Porcentaje | Fi (fi acum)  | Hi (hi acum) |
  | --           | --                 | --                        | --         | --            | --           |
  | Excelente    | 74                 | 0.296                     | 29.6%      | 74            | 0.296        |
  | Bueno        | 58                 | 0.232                     | 23.2%      | 132           | 0.528        |
  | ...          | ...                | ...                       | ...        | ...           | ...          |

  ```R
  table(datos)

  100 200 250 600
    1   2   1   1   # fi

  prop.table(table(datos))
  100 200 250 600
  0.2 0.4 0.2 0.2   # hi
  ```

## Representación gráfica: cuantitativas

* Histogramas:
  * se usan para variables con un amplio dominio (continuas)
  * permite ver esquemas de comportamientos que son dificiles de ver en una tabla numérica
  * se busca que el área total bajo el histograma sea igual a 1, porque puede servir para estimar algo de la variable aleatoria que hay atrás
  * se grafica fi/n/amplitud del intervalo Ci
  * intervalo = [a, b)
  * amplitud del intervalo Ci = b - a
  * density = hi / (b-a)

    | Clases | fi | hi  | hi / (b-a) |
    | --     | -- | --  | --         |
    | [a, b) | 3  | 3/6 | 3/6/(b-a)  |
    | [c, d) | 2  | 2/6 | 2/6/(d-c)  |
    | [e, f) | 1  | 1/6 | 1/6/(f-e)  |

    ```R
    hist(datos, breaks=100, col = "lightblue")
    ```

* Box-plots o diagramas de caja

## Medidas resumen

* **De posición o tendencia central**: media (cuantis), mediana (cuantis), moda (cualis, a veces para cuantis)
* **De dispersión o variabilidad** (cuantis): rango, varianza, desvio, coef de variación
* **De asociación**: correlación (entre 2 cuantis)

  | Datos |
  | --    |
  | 100   |
  | 200   |
  | 200   |
  | 250   |
  | 600   |

  ```R
  datos <- c(100, 200, 200, 250, 600)
  ```

### Media (muestral) o promedio

* Valor obtenido al sumar todos los datos y dividir el resultado entre el número total de datos
* Se deja influir por datos alejados o atípicos
* x̅ = (Σ Xi) / n
* x̄ = (x1 + x2 + ... xn) / n
* x̄ = (100 + 200 + 200 + 250 + 600) / 5 = 270

  ```R
  mean(datos) # 270
  ```

### Mediana (ME)

* Valor que separa la muestra ordenada en dos partes
* Número de datos es impar: ordenar y seleccionar el centro
* Número de datos es par: ordenar y sacar el promedio de los dos datos centrales
* 100, 200, **200**, 250, 600

  ```R
  median(datos) # 200
  ```

### Moda (MO)

* Valor que se repite con mayor frecuencia en los datos
* Si son dos valores que mas se repiten entonces es una distribución bimodal
* Si son mas de dos valores es una distribución multimodal
* **200**
  
  ```R
  as.numeric(names(which.max(table(x)))) # 200
  ```

### Varianza muestral (S^2)

* Calcula un promedio corregido de las distancias al cuadrado respecto del promedio
* S^2 = (1 / (n-1) ) / (x1 - x̄)^2 + (x2 - x̄)^2 + ... + (xn - x̄)^2
* S^2 = ((100 - 270)^2 + (200 - 270)^2 + (200 - 270)^2 + (250 - 270)^2 + (600 - 270)^2) / (5 - 1)
* S^2 = 37000
  
  ```R
  var(datos) # 37000
  ```

### Desvío estándar (S)

* S = sqrt(S^2)
* S = sqrt(37000) = 192.35
  
  ```R
  sd(datos) # 192.35
  ```

### Rango

* Cuan dispersos están los valores de esa variable
* valor max - valor min
* rango = 600 - 100 = 500
  
  ```R
  range(datos)            # 100 600 
  max(datos) - min(datos) # 500
  ```

### Coef de variación

* Coef de variación = desvio / media
* Coef de variación = (192.35 / 270) = 0.7124

  ```R
  sd(datos) / mean(datos) # 0.7124
  ```

### Otras medidas

* Cuartiles: separan a la muestra en 4 partes iguales
  * min---25%---Q1---25%---Q2=ME=D5---25%---Q3---25%---max
* Quintiles: separan a la muestra en 5 partes iguales
* Deciles: separan a la muestra en 10 partes iguales
* Percentiles: es el valor de la variable que deja k% de los datos por debajo de este.
  * min---K%---Pk--------------------------------------max

```R
summary(datos)

min(datos)
quantile(datos, 0.25) # Q1
quantile(datos, 0.50) # Q2 = ME
quantile(datos, 0.75) # Q3
max(datos)

quantile(datos, probs = c(0.25, 0.50, 0.75))
```

## Boxplot (diagrama caja-bigote)

* Relacionado con las medidas de resumen
* La caja permite mirar una dispersión central
* Es útil para detectar datos atípicos
* Se puede observar la asimetría de la distribución de una variable
* En el gráfico quedan determinadas medidas de posición
* RI (Rango intercuartílico) = Q3 - Q1

  ```R
  RI = quantile(datos, 0.75) - quantile(datos, 0.25) # Q1
  ```

| Datos muy atípicos | Datos atípicos o inusuales |            | Q1            | Q2 = Me | Q3 | Xmax     |
| --                 | --                         | --         | --            | --      | -- | --       |
|                    | 1.5 * RI                   | 1.5 * RI   |               |         |    | 1.5 * RI |

  ```R
  boxplot(datos)
  ```

## Como graficar/describir conjuntamente dos variables (cruzar variables)

* Si las dos son cualitativas:
  * tablas cruzadas
  * sectores separando por categorias / particiones
  * mosaicos
* Si las dos son cuantitativas (continuas):
  * Gráficos de dispersión
* Cuali-cuanti:
  * Histogramas separando por categorías / particiones (sobre todo para las continuas)
  * Box-plots separando por categorías / particiones

  ```R
  boxplot(Long ~ Genero, col = c("blue", "green", "red"))
  ```

## Medida de asociación entre dos cuantis: Coeficiente de correlación

* Mide el grado de asociación (lineal)

## Recordar: etapas del proceso estadístico

* Partimos de los datos: Muestra representativa de la población
* saber cosas acerca de una variable aleatoria (variable observada en la muestra):
  * la media
  * la distribución
* Inferir modelos probabilísticos (son las distribuciones...)
  
## Qué es un modelo probabilístico?

* Probabilidad (P): hay una experiencia de resultado aleatorio (no certero)
* Espacio muestral: conjunto de todos los resultados posibles
* Evento (H): subconjunto del espacio muestral
* Sobre los eventos se define una medida de probabilidad (números entre 0 y 1)
* Ejemplo:
  * Elegir una carta del mazo de truco
  * Espacio muestral = {1, 2, ..., 40}
  * H = {ancho espada}
  * P(H) = 1/40

## Probabilidad condicional

* Dado dos eventos, se define la probabilidad de A si se sabe que ocurrió B (A dado B o A si B)
  * P(A|B) = P(A∩B) / P(B)
* Ejemplo:
  * A = {sale el nro 1}
  * B = {sale carta de espadas}
  * P(A) = 4/40 = 1/10
  * P(B) = 10/40 = 1/4
  * P(A∩B) = 1/40
  * P(A|B) = P(A∩B) / P(B) = 1/10
* Cuando P(A|B) = P(A) se dice que A y B son independientes

## Fórmula de Bayes

* Dados dos eventos, se puede expresar la probabilidad de A condicional a B usando las condiciones en otro orden, lo que puede ser conveniente según la informacion disponible:
  * P(A|B) = P(B|A)P(A) / (P(B|A)P(A) + P(B|Ã)P(Ã))
* Ejemplos: tengo 4 bolitas amarillas y 6 bolitas rojas en una caja. Saco dos bolitas sin reponer
  * A1 = {sale amarilla la primera}
  * R2 = {sale roja la segunda}
  * P(A1|R2) = P(R2|A1)P(A1) / (P(R2|A1)P(A1) + P(R2|R1)P(R1)) = 24/54
  * P(A1) = 4/10
  * P(R1) = 6/10
  * P(A2|A1) = 3/9

## Variables aleatorias (VA)

* Se definen según el interes. Ej: cartas a 1, 2, 3, 4
* Transforma (codifica) los resultados del experimento aleatorio a número reales
* Miran de modo numérico resultados del experimento aleatorio
* Tengo un experimento aleatorio, a partir del experimento, miro un espacio muestral (espacio de todos los resultados posibles) y a partir del espacio muestral defino VA de interés. Ejemplo:
  * Experimento aleatorio: elijo un crustáceo al azar en la población y registro su género (F, M, I)
  * Aqui modelo con probabilidades. P(Gen=F) = pf
  * Defino una variable de interés X = 1 si F, 2 si M, 3 si I
  * A partir del modelo de probabilidades se genera una función de probabilidades para X
* Para cada resultado del espacio muestral hace corresponder un número
* Ejemplos:
  * X: cant de bolitas amarillas en dos extracciones. Valores discretos
  * Y: tiempo hasta el primer gol. Valores continuos (rango de valores)
  * Z: monto en caja de ahorro al día 30. Valores continuos
  * W: cant tiros hasta el primer acierto. Valores discretos

## Tipos de variables aleatorias

|           |          | Ejemplos                 |
| --        | --       | --                       |
| Discretas | **VAD**  | número de anillos        |
| Continuas | **VAC**  | longitud, diámetro, peso |

## Variable aleatoria discreta (VAD)

* Toma valores en un conjunto discreto de número reales
* Se describen mediante una función de probabilidad P(X=x)
* P(X=x) debe cumplir:
  * P(X=x) >= 0
  * ∑i=0 P(X=xi) =  1

### Parámetros básicos de una VAD

* **Media o esperanza o valor esperado**: indica "alrededor" de que valor se encuentran distribuidos los valores de la variable aleatoria. Se mide en la misma unidad que la variable
  * E(X) = m = μ = ∑i=1 xi P(X=xi)
  * E(x) es el punto de equilibrio o centro de masa de las probabilidades
* **Varianza**: es una medida de dispersión (concentración). Indica cuán alejados están los valores de la variable en relación con la media proporcionados según la probabilidad. Se mide la unidad que la variable al cuadrado
  * V(X) = σ^2x =  ∑i=1 (xi - μ)^2 P(X=xi)
* **Desvio**
  * Desvio = sqrt(V(X))

### Distribuciones discretas más conocidas

|                     |                                                                | Ejemplos                                                          |
| --                  | --                                                             | --                                                                |
| **Binomial**        | # éxitos en n repeticiones de experiencias dicotómicas indep   | obs 20 personas en la guardia la cant de personas con gripe       |
| **Geométrica**      | # experiencias hasta el primer éxito                           | cuento # personas que llegan a guardia hasta el primero con gripe |
| **Hipergeométrica** | # éxitos en n extracciones sin reposición                      |                                                                   |
| **Poisson**         | # éxitos ocurridos en un intervalo fijo de tiempo (o longitud) | obs # de personas que ingresa a guardia entre las 8 y las 9 hs    |

### Funciones disponibles en R

```R
dxxx(x, ...)  # Función de masa de probabilidad, f(x)
pxxx(q, ...)  # Función de distribución acumulada hasta q, F(q) = P(X<=q)
qxxx(p, ...)  # Cuantil para el cual P(X <= q) = p
rxxx(n, ...)  # Generador de números aleatorios.

# xxx puede ser: binom, geom, hyper, pois | unif, exp, norm, t, chisq 
```

## Ejemplos de distribuciones discretas

| Ejemplos binomial                                                                    | R                                                    |
| --                                                                                   | --                                                   |
| Calcular la prob de que hayan 3 con gripe en los 20. Se sabe que prob = 0.1 : P(X=3) | dbinom(x=3, size=20, prob=0.1)                       |
| Calcular la prob de que haya a lo sumo 3 con gripe: P(X<=3) = F(3)                   | pbinom(q=3, size=20, prob=0.1)                       |
| Simular la muestra de tamaño 100                                                     | rbinom(n=100, size=20, prob=0.1)                     |
| Graficar función de probabilidades con x <- 0:20                                     | plot(x=x, y=dbinom(x=x, size=2, prob=0.1), type='h') |

| Ejemplos poisson                                                                     | R                                                    |
| --                                                                                   | --                                                   |
| Calcular la prob de que lleguen 17. Tasa de arribos por hora = 15                    | dpois(17, 15)                                        |
| Calcular la prob de que lleguen como max 17                                          | ppois(17, 15)                                        |
| Graficar función de probabilidades con k <- 0:35                                     | plot(x=k, y=dpois(k, 15), type='h')                  |

## Variable aleatoria continua (VAC)

* Se describen mediante una función de densidad f(x)
* f(x) debe cumplir:
  * f(x) >= 0
  * integral f(x)dx = 1  (el area total bajo la curva sea igual a 1)
* Tiene un rango o soporte en un intervalo (o unión de intervalos)

### Parámetros básicos de una VAC

* **Media o esperanza o valor esperado**: es una medida de tendencia central. Indicar "alrededor" de que valor se encuentran distribuido los valores de la variable aleatoria. Se mide en la misma unidad que la variable
  * E(X) = m / μ = integral x f(x)dx
* **Varianza**: es una medida de dispersión. Indica cuán alejado están los valores de la variable en relación con la media. Se mide la unidad que la variable al cuadrado
  * V(X) = σ^2x = integral (x-m)^2 f(x)dx
* **Desvio**
  * Desvio = sqrt(V(X))

## Distribuciones continuas más conocidas

|                  | Ejemplos                                                                 | Densidad                       | Func Distribución | E(X)      | V(X)            |
| --               | --                                                                       | --                             | --                | --        | --              |
| **Uniforme**     | se elige un punto al azar en el intervalo (0, 1)                         | 1 si 0 < x < 1; 0 otro caso    | F(x) = P(X <= x)  | (a+b)/2   | (b-a)^2 / 12    |
| **Exponencial**  | se toma el tiempo (años) hasta que falle un artefacto. λ: tasa de fallos | f(t) = λe^(-λt)                | F(t) = P(T <= t)  | 1/λ       | 1/λ^2           |
| **Normal/Gauss** | Z ~ N(μ, σ^2), donde N(0,1) por ser estandar                             | f(x) = (1 / sqrt(2π))e^-0.5x^2 | F(Z) = P(Z <= z)  | 0         | 0               |
| **T de Student** | T ~ t(v). Asociada a una Normal y una Chi-cuadrado cociente. Acampanada  |                                |                   |           |                 |
| **Chi-cuadrado** | X ~ χ^2(v). No es simétrico                                              |                                |                   |           |                 |

## Como afecta el desvío a la Distribución Normal

* El mayor desvío (mas dispersión, mas desparramo)
* El menor desvío (mas concentración) ---> uno busca esto, ya que estaría en presencia de una variable mas precisa (valores con mas probabilidad mas cerca de la media)

## Ejemplos de distribuciones continuas

| Ejemplos uniforme                                                                    | R                                                    |
| --                                                                                   | --                                                   |
| Calcular la densidad en un punto                                                     | dunif(0.5, 0, 1)                                     |
| Calcular la prob de que el nro elegido sea menor o igual a 0.3: P(X<=0.3)            | punif(0.3, 0, 1)                                     |
| Calcular la prob de que el nro esté entre 0.3 y 0.5: P(0.3<X<0.5)                    | punif(0.5, 0, 1) - punif(0.3, 0, 1)                  |
| Simular la muestra de tamaño 100                                                     | runif(100, 0, 1)                                     |
| Graficar la densidad                                                                 | curve(dunif(0.5, 0, 1))                              |

| Ejemplos exponencial                                                                 | R                                                    |
| --                                                                                   | --                                                   |
| Calcular la densidad en un punto. Tiempo de vida en años 0.2                         | dexp(4, rate=0.2)                                    |
| Calcular la prob. P(T<=4)                                                            | pexp(4, 0.2, lower.tail = FALSE)                     |
| Graficar la densidad con x <- 0:20                                                   | curve(dexp(x, rate=0.2))                             |

| Ejemplos normal estandar                                                             | R                                                    |
| --                                                                                   | --                                                   |
| Calcular la prob. P(Z < 1)                                                           | pnorm(1, 0, 1)                                       |
| quantil 0.9 es el valor de z que deja a la izq una prob de 0.9                       | qnorm(0.9, 0, 1)    pnom(1.281552, 0, 1)             |
| Simular muestra aleatoria                                                            | rnorm(100, 0, 1)                                     |
| Graficar la densidad con x <- 0:20                                                   | curve(dnorm(x, 0, 1))                                |
| Graficar la distribución con x <- 0:20                                               | curve(pnorm(x, 0, 1))                                |

| Ejemplos t de STUDENT                                                                | R                                                    |
| --                                                                                   | --                                                   |
| quantil 0.975 con grado de libertad 4                                                | qt(0.975, 4)                                         |
| Graficar la densidad con x <- 0:20                                                   | curve(dt(x, 4))                                      |

| Ejemplos CHI-cuadrado                                                                | R                                                    |
| --                                                                                   | --                                                   |
| Calcular el valor de b / P(X > b) = 0.05. 0.95 porque miro hacia izq                 | qchisq(0.95, 4)                                      |
| Graficar la densidad con x <- 0:20                                                   | curve(dchisq(x, 4))                                  |

## Inferencia estadística

* Población N --> muestra representativa ---> Muestra n
* N           <--------INFERENCIA------------ n

## Tipos de Inferencias estadísticas

* Estimación Puntual: dar un número
* Intervalos de confianza
* Pruebas de hipótesis: permiten poner a prueba afirmaciones. Será que el ... es mas que .... ?

### Estimador puntual

* Dada una variable X cuya distribución depende de un parámetro Θ, y dada una muestra aleatoria X1, X2, ..., Xn, un **estimador de Θ** es una variable aleatoria que sea función de la muestra y que tome valores en el conjunto de valores posibles de Θ
* Por ejemplo, si queremos estimar la media μ de una población, utilizamos la media de una muestra: x̄
* Si queremos estimar la proporción de voto a un candidato, usamos p = #casos de intención de votos / total de muestra
* Para inferir sobre la media de una población, se utiliza el estimador x̄ = (x1 + x2 + ... + xn) / n
* Si la muestra es pequeña, x̄ ~ N(μ, σ/sqrt(n))

```R
muestra_z100 <- rnorm(100, 0, 1) # elijo al azar 100 datos de una normal 
mean(muestra_z100) # -0.009; el promedio de 100 valores esta cerca de 0 = media poblacional. Por eso se puede usar el promedio como estimador

summary(estudiantes)
mean(estudiantes$notas) # media estimada de nota = 6.516
sd(estudiantes$notas)   # 1.28  
var(estudiantes$nota)   # 1.64

```

* Otros estimadores:
  * para inferir sobre la varianza, se utiliza el estimador S^2
  * para inferor sobre una proporción, se utiliza la proporción muestral,  p = # éxitos en la muestra / n

### Estimación por intervalo de confianza (IC)

* Se busca que una estimación puntual esté acompañada de alguna medida del posible error de esa estimación
* Esto puede hacerse indicando el error estandar del estimador o dando un intervalo que incluya al verdadero valor del parámetro con un cierto nivel de confianza
* [LI, LS] / si el parámetro a estimar es Θ, entonces  P(LI <= Θ <= LS) = 1-α
* 1-α se denomina **coeficiente de confianza**
* el intervalo numérico observado se dice que tiene una confianza (1-α) de contener el verdadero valor del parámetro Θ

### Ejemplo

* n = 500
* X: altura de persona de 30 años  X ~ N(μ, σ)
* x̄ = 1.7074 m
* S = 0.29138  (desvio muestral)
* t es el quantil que deja en el centro 0.95  --> en R: qt(0.975, 499)  # 1.964729
* y así se determina un IC para la verdadera altura media con una confianza del 95%
* IC para μ : [1.6859; 1.7257]
* Interpretación: se tiene la confianza del 95% de que el IC contiene a la altura media de los hab. de 30 años de edad de esta población

  ```R
  ic <- t.test(x = estudiantes$nota, conf.level = 0.95)
  ic$conf.int
  ic$estimate
  ```

## QQPLOT

* Método gráfico para analizar la normalidad
* Gráfico quantil quantil, compara quantiles de los datos observados vs quantiles de una distribución normal teórica
* Si los puntos están alrededor de la bisectriz, podria asumirse la normalidad
  
  ```R
  # se puede asumir que los datos provienen de una distribución normal
  hist(estudiantes$nota)

  qqnorm(estudiantes$nota)
  qqline(estudiantes$nota)
  ggplot(estudiantes, aes(sample = nota)) + geom_qq() + geom_qq_line()
  # vemos que podemos asumir normalidad para las notas
  ```

## Tests o pruebas de hipótesis

* Es pensar en afirmaciones acerca de la población sobre las cuales nosotros querramos decidir
* Es uno de los pasos/formas de hacer inferencia
* Para un parámetro (media, varianza, proporción etc.)
* Tenemos una variable X y no conocemos uno de sus parámetros, podemos hacer inferencia:
  * Estimando un valor
  * Encontrando un intervalo de confianza
  * Decidiciendo si este valor cumple alguna condición

### Ejemplo de juguete

* Queremos decidir cómo es la media de una población
* Se tiene interés en el tiempo medio para embalar un producto
* El objetivo es que este sea de 10 minutos, por lo que el encargado de planta debe controlarlo
* Como hace ese control? Como decide?
* Tiempo medio es rápido?
* Tiempo medio es lento?
* Testear el valor medio (alrededor de qué esta el tiempo de embalaje)
* Esto se hace mirando datos (tomando muestras en diferentes horarios, diferentes operarios, etc. )
* Cuestión: que mirar de los datos...

### Organizando el problema

* Defino la variable de interés =>  X: tiempo de embalado (en min)
* Qué sabemos de X? nos informan que es una V.A. Normal pero no sabemos su media
* Se sabe su desvío es 3 minutos
* Estamos interesados en saber si μ = 10 ó μ != 10 SON LAS HIPOTESIS
* Cómo decidimos? CON DATOS!
* Tomamos una muestra aleatoria de tamaño n y consideramos la variable promedio (porque sabemos que estima la media, ya que la media de la muestra = promedio)

### Análisis

* x̄ / (σ / sqrt(n)) ~ N(0,1)
  * Si el promedio estandarizado está cerca de 0 (menos de aprox 0.10) entonces el promedio esta cerca de 10
  * Si el promedio estandarizado está lejos de 0 entonces digo que μ != 10

### Test o pruebas de hipótesis

* Se quiere decidir acerca de dos afirmaciones:
  * **Ho** (hipótesis nula) vs **H1** (hipótesis alternativa o de interés a controlar)
  * Ho: μ = 10
  * H1: μ != 10
* Hay pruebas de distinto tipo:
  * Acerca de un parámetro (media, varianza, proporción, etc.)
  * Acerca de una distribución (normal, binomial, etc.)
  * Acerca de comparación en dos o más poblaciones
  * Etc.
* Se requiere construir una regla de decisión a partir de observar la muestra y luego tomaremos una decisión en base a la muestra observada
* El planteo será siempre: ¿Hay suficiente evidencia para **rechazar Ho**?

### Riesgos o errores en un ensayo de hipótesis

| Realidad        | NO rechazo Ho | Rechazar Ho  |
| --              | --            | --           |
| Ho es verdadera | OK            | Error tipo 1 |
| Ho es falsa     | Error tipo 2  | OK           |

* Error tipo 1: riesgo a controlar es P(error tipo 1)
* Nivel de significación del test = max P(rechazar Ho / Ho es V) = max P(error tipo 1)
  * Decir que mu es 10 cuando no era 10

### P-valor: otra forma de decidir

* Zobs = (x̄obs - mu) / (σ / sqrt(n))
* pvalor = 2*P(Z > Zobs)  alto!!! Refuerza la idea de NO rechazar Ho
  * pvalor tendiendo a 0 (por debajo de 0.10) da evidencia a rechazar Ho => para ir por H1 (que es lo que queremos)
  * pvalor tendiendo a 1 no hay evidencia a rechazar Ho

### Estadístico de prueba

* Varianza conocida (será la ~ N)
* Varianza desconocida (será la ~ t)

### Pasos

1. Plantear la hipótesis nula y alternativa (Ho y H1)
2. Revisar si la variable puede considerarse con distribución Normal
3. n?
4. Estadistico de prueba
5. Establecer nivel de significación del test y la regla de decisión (regiones de rechazo y no rechazo)
6. Calcular el valor del estadístico observado y el pvalor
7. Analizar el p-valor
8. Decidir expresando "bien" las conclusiones: "Tengo evidencia para decir..." / "No tengo evidencia para decir..."

## Prueba de comparación de medias

* Es un método estadístico que se usa para determinar si hay un diferencia significativa entre las medias de 2 ó + grupos
* Busca responder a la pregunta: ¿las diferencias observadas entre los grupos son reales o simplemente producto del azar?
* Tipos de pruebas:
  * t de student: comparar medias de 2 grupos cuando los datos siguen una ~ N() y tienen varianzas similares
  * Wilcoxon: datos no siguen una distribución N()
  * ANOVA: cuando hay más de 2 grupos y se quiere saber si al menos uno de ellos tiene una media diferente
  * Kruskal-Wallis: ideal cuando los datos no son normales

* Suponiendo que tengo 2 grupos de mediciones, cada una con su respectiva media: x e y
* Desconozco el valor verdadero
* Recurrimos al cálculo de la t experimental (texp) vs t tabulada (ttab)
  * texp = ((x - y) / S) \* sqrt(n\*m / (n+m))
  * n: población de muestras para obtener la media
  * m: población de muestras para obtener la media
  * grados de libertad = (m-1) + (n-1)
  * S: desviación estándar combinada
    * S = sqrt( Σ(xi - x)^2 + Σ(yi - y)^2 / grados de libertad)
  
* Ejemplo: se llevan a cabo 2 determinaciones de cloruro a dos botellas diferentes
* MuestraX: {50.50, 50.71, 50.11, 50.48}; x=50.45; n=4
* MuestraY: {49.86, 49.85, 49.86}; y=49.86; m=3
* Indique si para un nivel de 97.5% hay diferencias significativas entre las medias de ambas botellas
* Se calcula S; S=0.1932
* Se calcula texp; texp=3.998
* Con grados de libertad = 5 y con nivel de confianza 97.5% se busca en tabla y la celda tiene valor la ttab=2.571
* SI texp > ttab "hay diferencias significativas" SINO "no hay diferencias significativas"
* 3.998 > 2.571 entonces hay diferencias significativas entre las medias de ambas botellas

## Ciencia de datos

* CIENCIA DE DATOS: en el medio de ...
  * Conocimiento del negocio (dominio)
  * Informática y Programación (interpretar código)
  * Matemáticas y Estadísticas

## Ciclo de vida de los datos (proceso iterativo)

1. Conocer negocio o dominio
2. Conocer los datos (recolección): exactitud, completitud, oportunidad, relevancia, detalle, consistencia. SINO volver a 1
3. Preparar los datos (limpieza, transformación)
4. Modelado/Algoritmos (predicción, clasificación, agrupamiento, identificando patrones y tendencias). SINO volver a 3
5. Validación/Evaluación del modelo (análisis de datos, comparando modelo obtenido vs objetivos propuestos). SINO volver a 1
6. Despliegue (presentación de resultados)

## Técnicas basadas de Minería de Datos

* **Aprendizaje supervisado** (existen variables de interés)
  * *Clasificación*
    * Árboles de decisión
    * Análisis discriminante
    * Redes Bayesianas
    * Redes Neuronales
    * SVM (Support Vector Machine)
  * *Regresión*:
    * Regresión simple
    * Regresión múltiple
    * Regresión Poisson
    * Ridge-Lasso
* Aprendizaje no supervisado (no hay variable de interés)
  * *Análisis cluster*:
    * Cluster aglomerativo
    * Cluster divisivo
    * K-means
  * *Reducción de dimensionalidad**:
    * ACP
    * Análisis factorial
    * PLS

## Inteligencia Artificial

* ML (deep learning, supervisado, no supervisado)
* NPL
* Sistemas Expertos
* Visión
* Speech
* Planning
* Robotics
