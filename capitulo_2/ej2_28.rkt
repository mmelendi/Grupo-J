#lang racket
(define (fringe tree)
  (cond ((null? tree) '())                           ; árbol vacío
        ((pair? (car tree))                          ; sublista → recorrer recursivamente
         (append (fringe (car tree)) (fringe (cdr tree))))
        (else                                        ; hoja → agregar al resultado
         (cons (car tree) (fringe (cdr tree))))))
(define x (list (list 1 2) (list 3 4)))
(fringe x)
;'(1 2 3 4)
(fringe (list x x))
;'(1 2 3 4 1 2 3 4)