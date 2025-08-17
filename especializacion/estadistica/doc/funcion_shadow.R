shadow.dist <- function(dist='dnorm', param=list(mean=0, sd=1),
                        a=NULL, b=NULL, type='lower',
                        col.shadow='skyblue', col.line='black', lwd=3,
                        nbreaks=10000, ylab=NULL, x, ...) {
  
  type <- match.arg(arg=type, choices=c('lower', 'middle', 'upper', 'two'))
  
  if (is.null(a) & is.null(b)) stop('At least define the parameter a')
  
  if (type %in% c('middle', 'two') & length(c(a, b)) <=1)
    stop("When type is 'middle' or 'two' you must define a & b")
  
  if (length(c(a, b)) == 2) { # To ensure that a < b
    values <- c(a, b)
    a <- min(values)
    b <- max(values)
  }
  
  if (is.null(a) & !is.null(b)) a <- b
  
  if (type == 'lower') {
    b <- a
    a <- -999
  }
  
  if (type == 'upper') {
    b <- 999
  }
  
  # To include the ylab automatically if ylab was NULL
  if (is.null(ylab)) ylab <- 'Density'
  
  # To create the main polygon
  step <- (b - a) / nbreaks
  cord.x <- c(a, seq(from=a, to=b, by=step), b)
  y <- seq(from=a, to=b, by=step)
  cord.y <- c(0, do.call(dist, c(list(x=y), param)), 0)
  
  # To create a secondary polygon if type='two'
  edge <- 999
  cord.x2 <- c(-edge, seq(from=-edge, to=edge, length.out=1e6), edge)
  y <- seq(from=-edge, to=edge, length.out=1e6)
  cord.y2 <- c(0, do.call(dist, c(list(x=y), param)), 0)
  
  curve(do.call(dist, c(list(x), param)), ylab=ylab, ...) # First curve
  if (type == 'two') {
    polygon(cord.x2, cord.y2, col=col.shadow)
    col.shadow <- 'white'
  }
  polygon(cord.x, cord.y, col=col.shadow)                   # Main shadow
  curve(do.call(dist, c(list(x), param)), add=TRUE,
        lwd=lwd, col=col.line)                              # Second curve
}

shadow.dist(dist='dnorm', param=list(mean=3.1, sd=1.2),
            a=qnorm(p=0.15, mean=3.1, sd=1.2), type='lower', from=0, to=6,
            main='', las=1,
            col.shadow='springgreen3', xlab='X', ylab='Densidad')
text(x=1.3, y=0.05, "0.15", col="yellow1", cex=2)


shadow.dist(dist='dnorm', param=list(mean=0, sd=1),
            a=qnorm(p=0.9, mean=0, sd=1), type='lower', from=-4, to=4,
            main='', las=1,
            col.shadow='springgreen3', xlab='X', ylab='Densidad')
text(x=0, y=0.1, "0.9", col="black", cex=1)




# Veamos gráficamente dónde se encuentra la probabilidad que calculamos:
shadow.dist(dist='dnorm', param=list(mean=0, sd=1),
            a=qnorm(p=0.9, mean=0, sd=1), type='lower', from=-4, to=4,
            main='', las=1,
            col.shadow='springgreen3', xlab='X', ylab='Densidad')
text(x=1.3, y=0.05, "0.9", col="yellow1", cex=2)