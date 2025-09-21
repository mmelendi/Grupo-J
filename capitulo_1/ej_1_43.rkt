#lang racket

;;itera f n veces
(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (cond
    [(zero? n) (lambda (x) x)]
    [else (compose f (repeated f (sub1 n)))]))

(define (square x) (* x x))

(define ejemplo-143
  ((repeated square 2) 5)) ; debera mostrar 625

(module+ main
  (displayln (list 'ejemplo-143 ejemplo-143)))
