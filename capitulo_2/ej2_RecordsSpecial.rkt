#lang racket
; Ejercicio especial: registros como lista de pares clave-valor
;
; Representamos un registro como:
(define record '((x 1) (y 2) (z 3)))

; --- 1. Procedimiento assoc ---
; Busca la entrada cuyo primer elemento es igual a la clave dada.
(define (assoc key record)
  (cond
    [(null? record) #f]                   ; Si la lista está vacía, no se encontró la clave
    [(eq? (caar record) key) (car record)] ; Si la clave coincide, retorna el par
    [else (assoc key (cdr record))]))      ; Si no, busca en el resto de la lista

; Ejemplo:
(assoc 'y record) ; => (y 2)

; --- 2. Procedimiento add-entry ---
; Agrega una nueva entrada (clave valor) al final o la reemplaza si ya existe la clave,
; devolviendo un nuevo registro.
(define (add-entry key value record)
  (if (assoc key record)
      (cons (list key value)
            (filter (lambda (entry) (not (eq? (car entry) key))) record)) ; Reemplaza si existe
      (append record (list (list key value))))) ; Añade al final si no existe

; Ejemplos:
(add-entry 'w 4 record)  ; => ((x 1) (y 2) (z 3) (w 4))
(add-entry 'x 10 record) ; => ((x 10) (y 2) (z 3))

; --- 3. Procedimiento del-entry ---
; Elimina la entrada con la clave dada y devuelve el nuevo registro sin esa entrada.
(define (del-entry key record)
  (filter (lambda (entry) (not (eq? (car entry) key))) record))

; Ejemplo:
(del-entry 'x record) ; => ((y 2) (z 3))