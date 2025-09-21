#lang racket

;;f∘g
(define (compose f g)
  (lambda (x) (f (g x))))

(define (square x) (* x x))
(define (inc x) (+ x 1))

(define ejemplo-142
  ((compose square inc) 6)) ; debera salir 49

(module+ main
  (displayln (list 'ejemplo-142 ejemplo-142)))
