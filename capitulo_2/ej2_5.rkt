#lang racket
(provide cons35 car35 cdr35)
(require rackunit)

(define (exp-count n p)
  (let loop ([n n] [c 0])
    (if (zero? (remainder n p))
        (loop (/ n p) (add1 c))
        (values c n))))

(define (cons35 a b)
  (* (expt 2 a) (expt 3 b)))

(define (car35 z)
  (define-values (c rest) (exp-count z 2))
  c)

(define (cdr35 z)
  (define-values (c rest) (exp-count z 3))
  c)

(module+ test
  (define z (cons35 4 5))
  (check-equal? (car35 z) 4)
  (check-equal? (cdr35 z) 5))

