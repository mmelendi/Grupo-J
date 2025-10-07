#lang racket
(provide zero add-1 add church+ church* church-expt to-int)
(require rackunit)

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))

(define (church+ m n)
  (lambda (f)
    (lambda (x)
      ((m f) ((n f) x)))))

(define (church* m n)
  (lambda (f) (m (n f))))

(define (church-expt b e)
  (e b))

(define (add n m)
  (if (zero? m) n (add (add1 n) (sub1 m))))

(define (to-int n)
  ((n (lambda (x) (add1 x))) 0))

(module+ test
  (define one (add-1 zero))
  (define two (add-1 one))
  (check-equal? (to-int (church+ two two)) 4)
  (check-equal? (to-int (church* two two)) 4)
  (check-equal? (to-int (church-expt two two)) 4))
