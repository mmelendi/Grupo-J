#lang racket
; Ejercicio de patrones: comprobar si el patrón coincide con la estructura de datos.
; Un patrón puede contener el símbolo '? para aceptar cualquier elemento en esa posición.

(define (match pattern data)
  (cond
    ; Si patrón y data son exactamente iguales, ¡coinciden!
    [(equal? pattern data) #t]
    ; Si el patrón es '?  acepta cualquier elemento en esa posición
    [(eq? pattern '?) #t]
    ; Si ambos son listas, compara elemento a elemento
    [(and (pair? pattern) (pair? data))
     (and (match (car pattern) (car data))
          (match (cdr pattern) (cdr data)))]
    ; Si uno es lista y otro no, no pueden coincidir
    [(or (pair? pattern) (pair? data)) #f]
    ; En todos los demás casos, compara estrictamente
    [else (equal? pattern data)]))

; ----- Ejemplo de registro -----
(define record '(job (Hacker Alyssa P) (computer programmer)))

; Primer patrón: 'job seguido de dos elementos cualesquiera
(match '(job ? ?) record)           ; => #t

; Segundo patrón: 'job, luego cualquier elemento, luego una lista que empieza por 'coder
(match '(job ? (? coder)) record)   ; => #f

; Tercer patrón: cualquier elemento, cualquier elemento, lista que empieza por 'computer y cualquier cosa
(match '(? ? (computer ?)) record)  ; => #t
