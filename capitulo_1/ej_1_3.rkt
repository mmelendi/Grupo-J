#lang racket
(define (sum-of-squares-of-two-larger a b c)
  (cond ((and (<= a b) (<= a c)) (+ (* b b) (* c c))) ; a es el más pequeño
        ((and (<= b a) (<= b c)) (+ (* a a) (* c c))) ; b es el más pequeño
        (else (+ (* a a) (* b b)))))                  ; c es el más pequeño
