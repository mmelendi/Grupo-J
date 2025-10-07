#lang racket
(define (make-rat n d)
  (let ((g (gcd n d)))
    (cond ((or (< n 0) (< d 0))
           (cons (- (abs n)) (abs d)))
          (else
           (cons (/ n g) (/ d g))))))
