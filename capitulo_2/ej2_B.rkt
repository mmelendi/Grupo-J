#lang racket

; --- Procedimientos de Etiquetado (de la Sección 2.4.2) ---
(define (attach-tag tag contents)
  (cons tag contents))

(define (type-tag datum)
  (car datum))

(define (contents datum)
  (cdr datum))


; --- Implementación de Bob (Modificada con Etiquetas) ---

; 1. El constructor AHORA AÑADE LA ETIQUETA
(define (bob-make-box x y w h)
  (attach-tag 'bob-box
              (cons (cons x y) (cons w h))))

; 2. Nuevo procedimiento para comprobar el tipo
(define (bob-box? b)
  (eq? (type-tag b) 'bob-box))

; 3. Los selectores AHORA USAN 'contents' para desenvolver los datos
(define (bob-width box)
  (car (cdr (contents box))))

(define (bob-height box)
  (cdr (cdr (contents box))))

(define (bob-area box)
  (* (bob-width box) (bob-height box)))


; --- Implementación de Alice (Modificada con Etiquetas) ---

; 1. El constructor AHORA AÑADE LA ETIQUETA
(define (alice-make-box x1 y1 x2 y2)
 (attach-tag 'alice-box
             (cons (cons x1 y1) (cons x2 y2))))

; 2. Nuevo procedimiento para comprobar el tipo
(define (alice-box? b)
  (eq? (type-tag b) 'alice-box))

; 3. Los selectores AHORA USAN 'contents' para desenvolver los datos
(define (alice-width box)
  (abs (- (car (cdr (contents box)))
          (car (car (contents box))))))

(define (alice-height box)
  (abs (- (cdr (cdr (contents box)))
          (cdr (car (contents box))))))

(define (alice-area box)
  (* (alice-width box) (alice-height box)))


; --- Pruebas del Ejercicio 2.B ---
(newline)
(display "--- Pruebas Ejercicio 2.B ---")
(newline)

; 1. Definir las cajas
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

; 2. Verificar que los cálculos siguen funcionando
(display "Cálculo de área de Alice: ")
(alice-area a) ; Devuelve 4

(display "Cálculo de área de Bob: ")
(bob-area b)   ; Devuelve 12

; 3. Mirar las estructuras de datos (¡ahora son diferentes!)
(display "Estructura de datos de a: ")
a ; Devuelve '(alice-box (1 . 2) 3 . 4)

(display "Estructura de datos de b: ")
b ; Devuelve '(bob-box (1 . 2) 3 . 4)