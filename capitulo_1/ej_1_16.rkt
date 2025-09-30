#lang racket

;; eleva al cuadrado
(define (square x) (* x x))

;; fast-expt: exponenciación rápida (por cuadrados sucesivos)
;; usa acumulador:
;;  - n = 0 → devuelve a
;;  - n par → b^n = (b^2)^(n/2)
;;  - n impar → b^n = b * b^(n-1)
(define (fast-expt b n)
  (define (iter b n a)
    (cond [(= n 0) a]
          [(even? n) (iter (square b) (/ n 2) a)]
          [else      (iter b (- n 1) (* a b))]))
  (iter b n 1))

(module+ main
  (displayln (list '2^10 (fast-expt 2 10))) ; 1024
  (displayln (list '3^7  (fast-expt 3 7)))  ; 2187
  (displayln (list '5^5  (fast-expt 5 5)))) ; 3125
