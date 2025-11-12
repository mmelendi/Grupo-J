#lang racket
; Implementación recursiva de equal? para listas de símbolos (versión simple)
(define (my-equal? a b)
  (cond
    ; Ambos son símbolos, compara con eq?
    ((and (symbol? a) (symbol? b)) (eq? a b))
    ; Ambos son listas, compara sus partes
    ((and (pair? a) (pair? b))
     (and (my-equal? (car a) (car b))
          (my-equal? (cdr a) (cdr b))))
    ; Ambas listas vacías
    ((and (null? a) (null? b)) #t)
    ; En cualquier otro caso, no son iguales
    (else #f)))

; Ejemplo TRUE:
(my-equal? '(this is a list) '(this is a list)) ; => #t
; Ejemplo FALSE:
(my-equal? '(this is a list) '(this (is a) list)) ; => #f

; -------- Opcional: versión que acepta números ---------
(define (my-equal-num? a b)
  (cond
    ((and (symbol? a) (symbol? b)) (eq? a b))
    ((and (number? a) (number? b)) (= a b)) ; si ambos son números, usa =
    ((and (pair? a) (pair? b))
     (and (my-equal-num? (car a) (car b))
          (my-equal-num? (cdr a) (cdr b))))
    ((and (null? a) (null? b)) #t)
    (else #f)))

; Ejemplos:
(my-equal-num? '(1 a 2) '(1 a 2)) ; => #t
(my-equal-num? '(1 a 2) '(1 a 3)) ; => #f
