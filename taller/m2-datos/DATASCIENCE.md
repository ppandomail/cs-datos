## Aprendizaje Automáticos (ML) vs Ciencia de Datos (DS)

* ML: conjunto de herramientas de estadísticas y matemáticas para explorar y analizar los datos y de esa forma aportar valor mediante modelos:
* **Aprendizaje supervisado** (existen variables de interés: respuesta conocida para clasificar o predecir)
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
* **Aprendizaje no supervisado** (no hay variable de interés. respuestas desconocida, se crean categorias)
  * *Análisis cluster*:
    * Cluster aglomerativo
    * Cluster divisivo
    * K-means
  * *Reducción de dimensionalidad**:
    * ACP
    * Análisis factorial
    * PLS
  * **deep learning**: busca clasificar/predecir mediante redes neuronales
    * artificial (datos numéricos)
    * convolucional (imágenes)
    * recurrente (series de tiempo)

* Proceso de ML:
    1. Identificar (plantear el problema y los datos)
    2. Explorar (justificar el uso de ML)
    3. Hacer modelos (definir la idea general)
    4. Interpretar (dar conclusiones del problema)
    5. Validar (que todo está bien)

* DS: conjunto de conocimientos de estadisticas, programación, negocio y comunicación para crear valor

* **ML es parte de DS**

## Inteligencia Artificial (AI) vs Aprendizaje Automático (ML) vs Aprendizaje Profundo (DL)

* AI: máquinas piensan como humano
    * ML (deep learning, supervisado, no supervisado)
    * NPL
    * Sistemas Expertos
    * Visión
    * Speech
    * Planning
    * Robotics

* ML: herramientas estadísticas y matemáticas
* DL: algoritmos específicos con redes neuronales

* **DL ⊂ ML ⊂ AI**

## Big Data vs Data Science

* Big Data: grandes volumenes de información. Tipos: estructurados (tablas) y no estructurados (json). Aportar valor con datos
  * Volumen: cantidad
  * Variedad: tipos de datos
  * Velocidad: rapidez como obtenemos los datos
  * Veracidad: si el dato es confiable
  * Valor: dinero, que tan útil es para la toma de decisiones
  * Variabilidad: datos estables o que den saltos muy grandes

* Ambas buscan aportar valor con datos
* Big Data lo hace desde las BD (gestiona datos)
* DS lo hace desde la estadística/matemáticas para aportar valor con los modelos de ML (análisis de datos)


## Tipos de proyectos para data science

* EDA: Análisis Exploratorio de Datos
    * Traer un dataset
    * Limpiar los datos
    * Análisis de datos respondiendo preguntas de interés 
* ML: Machine Learning
    * Clasificar
    * Regresionar
    * Clustering 
* Avanzado
    * Redes neuronales
    * NLP
    * Computer vision

## Cómo aprender?

* Aprender haciendo: pasar a la acción, no excederse en la teoria
    *  Buscar el set de datos
    *  Hacer EDA
    *  Pasarlo a GitHub
    *  Generar modelos de ML
* Aprender enseñando
    * Escribir blog de ciencia de datos, por ejemplo, en [Medium](https://medium.com/)
* Aprender compartiendo (muy valioso el networking)
    * Por ejemplo, en LinkedIn
    * Asistir a eventos, conferencias

## Ruta de aprendizaje para ser data scientist

### Básico

1. Aprender programación: Python y librerías: NumPy, pandas y matplotlib
2. Aprender estadística descriptiva:
    * media, mediana, correlación, varianza, tabla de frecuencias, etc.
    * Distribuciones de probabilidad: normal, exponencial, ...
    * Test de hipótesis y p-valores
3. Visualización: gráficas

### Intermedio

4. Aprender EDA
    * Buscar el dataset, por ejemplo en kaggle
    * Preguntar a los datos y responder con código de python
5. Aprender algoritmos de ML
    * Algebra: vectores, matrices y tensores. Cálculo de derivadas
    * Estadistica inferencial: probabilidad, esperanza
    * Algoritmos: regresión, clasificación, clustering
    * Python: scikit-learn (biblioteca de ML) y stats-models
6. Aprender BD
    * Modelos de datos (relacionales, NoSQL, ...)
    * SQL
 
### Avanzado

7. Data scraping: extraer de la web información
8. Especializarse en algoritmos de ML: NLP, Text Mining
9. Deep Learning: redes neuronales
10. Herramientas Cloud: servicios remotos
11. Big Data
12. ETL
13. Git / GitHub


## Diferencias entre R y Python

* Ambas son herramientas para aportar valor con datos
* R: es un software para análisis estadístico y gráficas
* Python: es un lenguaje de programación de propósito general

* Dificultad de aprendizaje
* Objetivos del uso
    * R es bueno para análisis estadísticos, gráficas y reportes
    * Python es bueno para productos de datos e integración con otros programas
* Personas que lo utilizan
    * R para investigación (académicos) y analistas de negocio
    * Python: ingenieros de software y de datos

## ¿Vale la pena data science?

* [Google Trends](https://trends.google.es/trends/)
* La IA no va a reemplazar a los data scientist
* El mercado no está saturado [Ranks de stackoverflow](https://survey.stackoverflow.co/2024/)

## ¿Por qué escribir en data science?

* Expresarse y comunicarse correctamente
* Se aprende dos veces
* Visibilidad (darse a conocer)

1. Inicio, el problema
2. Desarrollo
3. Final, resultado del modelo


## Machine Learning

* Ejemplo clasificar mi correo en anuncios o spam y no spam
* Es una rama de la IA que tiene como objetivo dotar a las computadoras de la capacidad de aprendizaje sin ser programadas explicitamente para ello, con el uso de datos y algoritmos
* Usar datos para responder preguntas (problemática)
* Tipos: supervisado, no supervisado y por refuerzo

## Aplicaciones de ML

* coches que se manejan solos
* reconocimiento de voz humana (siri, alexa)
* computer vision (analiza imágenes y detecta patrones)
* realidad aumentada

* saber la probabilidad con que un cliente va a regresar un crédito bancario que se le presta
* análisis de sentimientos: saber que está pensando una persona respecto a una conversación
* modelos de scoring: saber la probabilidad de una persona se convierta en un cliente 
* saber que productos se va a vender mas en cuales tiendas

## Aprendizaje supervisado

* Inputs: entradas
* Outputs: salidas

* in -> out
* x -> y
* var indep -> var dep

* Ejemplos:
    * input: correo  output: spam/no
    * input: imagen  output: perro/gato
    * input: casa    output: precio

* Regresión (predecir numeros): casa -> $
* A mayor tamaño mayor precio
* Ajustar la recta a la distribución (mirar los datos)

* Clasificación (predecir categorías): sobre -> spam (1)/ no spam (0)
* Se busca un x umbral
