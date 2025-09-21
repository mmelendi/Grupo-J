#lang racket

;;recursiva
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))

;;iterativa
(define (accumulate-iter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner result (term a)))))
  (iter a null-value))

;;sum y product como casos particulares
(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (sum-iter term a next b)
  (accumulate-iter + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

(define (product-iter term a next b)
  (accumulate-iter * 1 term a next b))

;;utilidades y pruebas
(define (identity x) x)
(define (inc x) (+ x 1))
(define (cube x) (* x x x))

(define ejemplo-sum (sum identity 1 inc 10))     ;debera salir 55
(define ejemplo-sum-cubes (sum cube 1 inc 3))    ;debera salir 36
(define ejemplo-prod (product identity 1 inc 5)) ;debera salir 120

(module+ main
  (displayln (list 'sum-1-10 ejemplo-sum))
  (displayln (list 'sum-cubes-1-3 ejemplo-sum-cubes))
  (displayln (list 'product-1-5 ejemplo-prod)))
