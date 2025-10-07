#lang racket
(provide same-parity)
(require rackunit)

(define (same-parity x . rest)
  (define p (even? x))
  (define (keep? y) (eq? p (even? y)))
  (let loop ([xs (cons x rest)] [acc '()])
    (cond [(null? xs) (reverse acc)]
          [(keep? (car xs)) (loop (cdr xs) (cons (car xs) acc))]
          [else (loop (cdr xs) acc)])))

(module+ test
  (check-equal? (same-parity 1 2 3 4 5 6) (list 1 3 5))
  (check-equal? (same-parity 2 3 4 5 6) (list 2 4 6)))
