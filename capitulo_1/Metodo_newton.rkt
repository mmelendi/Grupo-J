#lang racket
(define (cuadrado x)
  (* x x)) ; * lo tomamos como operación primitiva.

(define (raiz-cuadrada aproximacion x)
  (if (esta-bien-aproximacion? aproximacion x)
      aproximacion ; si es suficientemente buena la aproximacion, devolvemos
      (raiz-cuadrada (mejorar-aproximacion aproximacion x) x)
      )
  )
(define (esta-bien-aproximacion? aproximacion x)
  (< (abs (- (cuadrado aproximacion) x)) 0.001)) ; si el cuadrado de la aproximacion menos x es menor 0.01

(define (mejorar-aproximacion aproximacion x)
  (media aproximacion (/ x aproximacion)) ; hacer la media entre aproximacion y x/aproximacion mejora la aproximacion
  )
(define (media a b)
  (/ (+ a b) 2))

(raiz-cuadrada 1.0 2)