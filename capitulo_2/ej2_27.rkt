#lang racket
(define (deep-reverse xs)
  (cond [(null? xs) '()]                           ; caso base: lista vacía
        [(pair? (car xs))                          ; si el primer elemento es lista
         (append (deep-reverse (cdr xs))           ; invierte la cola
                 (list (deep-reverse (car xs))))]  ; invierte recursivamente la cabeza
        [else
         (append (deep-reverse (cdr xs))
                 (list (car xs)))]))               ; agrega el elemento normal
(define x (list (list 1 2) (list 3 4)))

(deep-reverse x)
;((4 3) (2 1))
