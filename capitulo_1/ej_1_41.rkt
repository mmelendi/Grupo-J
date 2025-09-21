#lang racket

(define (double f)
  (lambda (x) (f (f x))))

(define (inc x) (+ x 1))

(define resultado-141
  (((double (double double)) inc) 5))

(module+ main
  (displayln (list 'resultado-141 resultado-141)))
