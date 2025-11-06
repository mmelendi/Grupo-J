#lang racket
;Usando fold-right, si hacemos lo habitual (cons x y) construiría la lista en orden original, porque fold-right ya recorre de izquierda a derecha.
;Entonces, para invertir, necesitamos añadir el elemento al final de la lista acumulada y
(define (reverse sequence)
  (fold-right 
    (lambda (x y) (append y (list x))) nil sequence))

;fold-left procesa desde la izquierda, y en cada paso tenemos el acumulador parcial y (el resultado hasta ahora).
Para invertir, debemos cons-truir el elemento actual al frente del acumulador.
(define (reverse sequence)
  (fold-left 
    (lambda (x y) (cons y x)) nil sequence))
