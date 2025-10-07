#lang racket
(provide cons2 car2 cdr2)
(require rackunit)

(define (cons2 x y)
  (lambda (m) (m x y)))
(define (car2 z)
  (z (lambda (p q) p)))
(define (cdr2 z)
  (z (lambda (p q) q)))

(module+ test
  (define p (cons2 3 4))
  (check-equal? (car2 p) 3)
  (check-equal? (cdr2 p) 4))
