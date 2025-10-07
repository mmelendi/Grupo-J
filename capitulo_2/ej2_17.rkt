#lang racket
(provide last-pair)
(require rackunit)

(define (last-pair xs)
  (cond [(null? xs) (error 'last-pair "lista vacía")]
        [(null? (cdr xs)) xs]
        [else (last-pair (cdr xs))]))

(module+ test
  (check-equal? (last-pair (list 1 2 3)) (list 3)))
