#lang racket
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
;Funcion con operando a y operando b 
;En caso de que el operando b sea positivo devuelve la suma de a y b
;en caso contario realiza la resta de ambos 
;
; Definición del procedimiento
;(define (a-plus-abs-b a b)
;  ((if (> b 0) + -) a b))

; ---- Ejemplo 1: b positivo ----
;(a-plus-abs-b 5 3)
; (> 3 0) → #t, por tanto se elige el operador +
; Se evalúa (+ 5 3)
; Resultado → 8

; ---- Ejemplo 2: b negativo ----
;(a-plus-abs-b 5 -3)
; (> -3 0) → #f, por tanto se elige el operador -
; Se evalúa (- 5 -3) = 5 - (-3)
; Resultado → 8

; ---- Ejemplo 3: b = 0 ----
;(a-plus-abs-b 7 0)
; (> 0 0) → #f, se elige el operador -
; Se evalúa (- 7 0)
; Resultado → 7