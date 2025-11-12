#lang racket

; --- Implementación de Bob ---
; Representa una caja con (x, y), ancho (w) y alto (h)
(define (bob-make-box x y w h)
  (cons (cons x y) (cons w h)))

(define (bob-width box)
  (car (cdr box)))

(define (bob-height box)
  (cdr (cdr box)))

; (Nota: Corregido del texto para llamar a bob-width y bob-height)
(define (bob-area box)
  (* (bob-width box) (bob-height box)))


; --- Implementación de Alice ---
; Representa una caja con las esquinas (x1, y1) y (x2, y2)
(define (alice-make-box x1 y1 x2 y2)
 (cons (cons x1 y1) (cons x2 y2)))

(define (alice-width box)
  (abs (- (car (cdr box))   ; x2
          (car (car box))))) ; x1

(define (alice-height box)
  (abs (- (cdr (cdr box))   ; y2
          (cdr (car box))))) ; y1

; (Nota: Corregido del texto para llamar a alice-width y alice-height)
(define (alice-area box)
  (* (alice-width box) (alice-height box)))


; --- Pruebas del Ejercicio 2.A ---
(newline)
(display "--- Pruebas Ejercicio 2.A ---")
(newline)

; 1. Definir las cajas
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

; 2. Verificar que funcionan
(display "Cálculo de área de Alice: ")
(alice-area a) ; Devuelve 4

(display "Cálculo de área de Bob: ")
(bob-area b)   ; Devuelve 12

; 3. Mirar las estructuras de datos resultantes
(display "Estructura de datos de a: ")
a

(display "Estructura de datos de b: ")
b