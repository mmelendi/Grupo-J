#lang racket
(define (f g)
  (g 2))

;probamos con square
(define (square x) (* x x))
(f square)

;probamos con lambda
(f (lambda (z) (* z (+ z 1))))

;probamos con (f f)
(f f)
;no funciona porque al evaluarse acaba intentando aplicar el número 2 como si fuera un procedimiento, lo que produce un error.