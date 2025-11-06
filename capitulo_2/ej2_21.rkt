#lang racket
;definimos lista vacia
(define nil '())
;Usamos cons para construir una nueva lista donde:
;El primer elemento es el cuadrado del primer elemento de la lista(* (car items) (car items)).
;El resto de la lista es la llamada recursiva con (cdr items).
(define (square-list items)
  (if (null? items)
      nil
      (cons (* (car items) (car items))
            (square-list (cdr items)))))

;map aplica una función a cada elemento de la lista.
;(lambda (x) (* x x)) es una función anónima que calcula el cuadrado de x.
;items es la lista de entrada.
(define (square-list items)
  (map (lambda (x) (* x x)) items)) 