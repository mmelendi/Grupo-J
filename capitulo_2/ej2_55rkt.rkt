#lang racket
; Cuando escribimos ''abracadabra, estamos usando dos veces el operador de quote (comilla simple).
; Recordemos que:
;   - 'abracadabra es equivalente a (quote abracadabra)
; Por lo tanto:
;   - ''abracadabra es lo mismo que (quote (quote abracadabra))
;
; Si evaluamos ''abracadabra en la consola de Racket, veremos que su valor es una lista de dos elementos:
;   * El primero es el símbolo 'quote
;   * El segundo es el símbolo 'abracadabra
; O sea: (quote abracadabra)
;
; Por lo tanto, al hacer (car ''abracadabra), estamos pidiendo el primer elemento de la lista (quote abracadabra),
; que es el símbolo 'quote.
;
; El resultado es 'quote, porque eso es literalmente el primer elemento de la lista creada por el doble quote.

(car ''abracadabra) ; => 'quote
