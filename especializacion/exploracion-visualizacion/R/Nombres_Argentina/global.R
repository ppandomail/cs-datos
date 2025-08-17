library(shiny)
library(tidyverse)
library(ggwordcloud)
library(plotly)

nomres_arg <- read.csv("historico-nombres_ok.csv", encoding = "latin1") %>%
  select(-X) %>% 
  complete(nombre, anio) %>%
  fill(cantidad,.direction = "downup")

nombres <- unique(nomres_arg$nombre)
