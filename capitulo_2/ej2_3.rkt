#lang racket
(provide make-rect perim area)
(require rackunit)

;; Dos representaciones: por diagonal (p1,p2) o por punto+anchura+altura
(define (make-rect p1 p2)
  (cons p1 p2))
(define (x p) (car p))
(define (y p) (cdr p))

(define (width r)
  (abs (- (x (car r)) (x (cdr r)))))
(define (height r)
  (abs (- (y (car r)) (y (cdr r)))))

(define (perim r)
  (* 2 (+ (width r) (height r))))

(define (area r)
  (* (width r) (height r)))

(module+ test
  (define r (make-rect (cons 1 1) (cons 6 4)))
  (check-equal? (perim r) 16)
  (check-equal? (area r) 15))
