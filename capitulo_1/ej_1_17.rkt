#lang racket

;; duplica un número
(define (double x) (+ x x))

;; divide a la mitad
(define (halve x) (/ x 2))

;; fast-mul: multiplicación rápida (por duplicación y halving)
;;  - si b = 0 → 0
;;  - si b par → (a * b) = (2a) * (b/2)
;;  - si b impar → (a * b) = a + a * (b-1)
(define (fast-mul a b)
  (cond [(= b 0) 0]
        [(even? b) (fast-mul (double a) (halve b))]
        [else (+ a (fast-mul a (- b 1)))]))
