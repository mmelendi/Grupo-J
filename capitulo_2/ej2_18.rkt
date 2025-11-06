#lang racket
(define (reverse1 xs)
  (let loop ([xs xs] [acc '()])
    (if (null? xs) acc
        (loop (cdr xs) (cons (car xs) acc)))))
(define x (list (list 1 2) (list 3 4)))
(reverse1 x)

