#lang racket
; Ejercicio 2.53: ¿Qué imprimiría el intérprete en cada caso?

; 1. (list 'a 'b 'c)
; Crea una lista formada por los símbolos a, b y c.
(list 'a 'b 'c) ; => (a b c)

; 2. (list (list 'george))
; Crea una lista cuyo único elemento es otra lista que contiene el símbolo george.
(list (list 'george)) ; => ((george))

; 3. (cdr '((x1 x2) (y1 y2)))
; Devuelve la cola de la lista, omitiendo su primer elemento.
(cdr '((x1 x2) (y1 y2))) ; => ((y1 y2))

; 4. (cadr '((x1 x2) (y1 y2)))
; 'cadr' equivale a (car (cdr ...)), por lo que da el segundo elemento.
(cadr '((x1 x2) (y1 y2))) ; => (y1 y2)

; 5. (pair? (car '(a short list)))
; 'car' toma el primer elemento de la lista (el símbolo 'a'), preguntamos si es un par.
(pair? (car '(a short list))) ; => #f

; 6. (memq 'red '((red shoes) (blue socks)))
; Busca el símbolo 'red' en la lista de listas (no está directamente como elemento, sino en una sublista).
(memq 'red '((red shoes) (blue socks))) ; => #f

; 7. (memq 'red '(red shoes blue socks))
; Busca el símbolo 'red' en la lista, es el primer elemento, devuelve la sublista a partir de ahí.
(memq 'red '(red shoes blue socks)) ; => (red shoes blue socks)