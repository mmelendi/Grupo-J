#lang racket
;Recursivo
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))
;sum
(define (sum term a next b)
  (accumulate + 0 term a next b))
;product
(define (product term a next b)
  (accumulate * 1 term a next b))
;iterativo
(define (accumulate-iter combiner null-value term a next b)
  (define (iter x result)
    (if (> x b)
        result
        (iter (next x)
              (combiner (term x) result))))
  (iter a null-value))
