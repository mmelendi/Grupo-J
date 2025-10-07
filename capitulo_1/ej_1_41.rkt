#lang racket

;; define "double": recibe una función f y devuelve
;; una nueva función que aplica f dos veces a su argumento x
(define (double f)
  (lambda (x) (f (f x))))

;; define "inc": una función que incrementa en 1 el valor dado
(define (inc x) (+ x 1))

;; (double double) = aplica la función double dos veces,
;; es decir, crea una función que duplica el "efecto de duplicar".
;; (double (double double)) = aplica doble "nivel de duplicación".
;; En resumen: estamos generando una función que aplica inc 16 veces.
;; Luego se aplica esa función al valor 5.
(define resultado-141
  (((double (double double)) inc) 5))

;; módulo principal: imprime el resultado en consola
(module+ main
  (displayln (list 'resultado-141 resultado-141)))
