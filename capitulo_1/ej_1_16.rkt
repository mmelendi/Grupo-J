#lang racket

(define (square x) (* x x))

(define (fast-expt b n)
  (define (iter b n a)
    (cond [(= n 0) a]
          [(even? n) (iter (square b) (/ n 2) a)]
          [else      (iter b (- n 1) (* a b))]))
  (iter b n 1))

(module+ main
  (displayln (list '2^10 (fast-expt 2 10))) ;debera salir 1024
  (displayln (list '3^7  (fast-expt 3 7)))  ;debera salir 2187
  (displayln (list '5^5  (fast-expt 5 5)))) ;debera salir 3125
