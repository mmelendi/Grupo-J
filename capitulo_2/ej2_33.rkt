#lang racket
;Dentro de accumulate, cada paso debe construir un nuevo elemento p(x) al frente del resultado parcial y.
(define (map p sequence)
  (accumulate (lambda (x y)
                (cons (p x) y))
              nil sequence))
;Concatena los elementos de seq1 delante de seq2. Así que si queremos que el resultado final termine con seq2, el valor inicial debe ser seq2.
(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
;length solo cuenta los elementos. Cada paso ignora el contenido de x y suma 1 al acumulador y.
(define (length sequence)
  (accumulate (lambda (x y)
                (+ 1 y))
              0
              sequence))
