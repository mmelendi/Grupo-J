#lang racket
(define (for-each proc items)
  (if (null? items)
      #t                              ; devuelve un valor arbitrario, como true
      (begin
        (proc (car items))             ; aplica la función al primer elemento
        (for-each proc (cdr items))))) ; continúa con el resto de la lista
(for-each 
  (lambda (x)
    (newline)
    (display x))
  (list 57 321 88))
