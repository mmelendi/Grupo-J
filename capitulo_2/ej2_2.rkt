#lang racket
(provide make-point x-point y-point make-segment start-segment end-segment midpoint-segment)
(require rackunit)

(define (make-point x y) (cons x y))
(define x-point car)
(define y-point cdr)

(define (make-segment p q) (cons p q))
(define start-segment car)
(define end-segment cdr)

(define (midpoint-segment s)
  (let* ([p (start-segment s)]
         [q (end-segment s)]
         [mx (/ (+ (x-point p) (x-point q)) 2)]
         [my (/ (+ (y-point p) (y-point q)) 2)])
    (make-point mx my)))

(module+ test
  (define p (make-point 0 0))
  (define q (make-point 4 2))
  (check-equal? (midpoint-segment (make-segment p q))
                (make-point 2 1)))
