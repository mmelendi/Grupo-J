#lang racket

(define (inc x) (+ x 1))
(define (dec x) (- x 1))

;;version A: usa inc afuera (proceso recursivo)
(define (plus-rec a b)
  (if (= a 0)
      b
      (inc (plus-rec (dec a) b))))

;;version B: mueve el trabajo al estado (proceso iterativo)
(define (plus-iter a b)
  (if (= a 0)
      b
      (plus-iter (dec a) (inc b))))

(module+ main
  (displayln (list 'plus-rec-4-5 (plus-rec 4 5))) ;debera salir 9
  (displayln (list 'plus-iter-4-5 (plus-iter 4 5)))) ;debera salir 9
