#lang racket

;; compose: devuelve una nueva función que representa la composición f∘g
;; Es decir, aplica primero g a x, luego f al resultado.
;; ((compose f g) x) = f(g(x))
(define (compose f g)
  (lambda (x) (f (g x))))

;; square: eleva al cuadrado su argumento
(define (square x) (* x x))

;; inc: incrementa en 1 su argumento
(define (inc x) (+ x 1))

;; ejemplo-142:
;; (compose square inc) devuelve una función que primero aplica inc y luego square.
;; Paso 1: inc(6) = 7
;; Paso 2: square(7) = 49
;; Resultado final: 49
(define ejemplo-142
  ((compose square inc) 6)) ; debería salir 49

;; módulo principal: muestra el resultado en consola
(module+ main
  (displayln (list 'ejemplo-142 ejemplo-142)))
