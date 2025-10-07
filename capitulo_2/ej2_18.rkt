#lang racket
(provide reverse1)
(require rackunit)

(define (reverse1 xs)
  (let loop ([xs xs] [acc '()])
    (if (null? xs) acc
        (loop (cdr xs) (cons (car xs) acc)))))

(module+ test
  (check-equal? (reverse1 (list 1 2 3)) (list 3 2 1)))
