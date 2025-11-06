#lang racket
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))
;Esto devuelve el orden inverso del resultado final esperado debido a que inserta en la lista de resultados cada nuevo cuadrado al frente de la lista acumuladora answer

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square 
                     (car things))))))
  (iter items nil))
;Está llamando cons con answer (una lista) como primer argumento y un número como segundo. cons construye una pareja cuyo car = answer y cdr = número.
;Eso NO produce una lista de números. Produce una estructura con forma inválida para recorrer como lista. Por eso “no funciona”.