#lang racket

; --- Código base del Ejercicio 2.B (Necesario) ---

(define (attach-tag tag contents) (cons tag contents))
(define (type-tag datum) (car datum))
(define (contents datum) (cdr datum))

; --- Implementación de Bob (con Etiquetas) ---
(define (bob-make-box x y w h)
  (attach-tag 'bob-box (cons (cons x y) (cons w h))))
(define (bob-box? b) (eq? (type-tag b) 'bob-box))
(define (bob-width box) (car (cdr (contents box))))
(define (bob-height box) (cdr (cdr (contents box))))
(define (bob-area box) (* (bob-width box) (bob-height box)))

; --- Implementación de Alice (con Etiquetas) ---
(define (alice-make-box x1 y1 x2 y2)
 (attach-tag 'alice-box (cons (cons x1 y1) (cons x2 y2))))
(define (alice-box? b) (eq? (type-tag b) 'alice-box))
(define (alice-width box)
  (abs (- (car (cdr (contents box))) (car (car (contents box))))))
(define (alice-height box)
  (abs (- (cdr (cdr (contents box))) (cdr (car (contents box))))))
(define (alice-area box) (* (alice-width box) (alice-height box)))

; =======================================================
; --- SOLUCIÓN: Ejercicio 2.C (Procedimientos Genéricos) ---
; =======================================================

; 1. Procedimiento genérico 'width'
(define (width b)
  (cond ((bob-box? b) (bob-width b))
        ((alice-box? b) (alice-width b))
        (else (error "Tipo de caja desconocido" b))))

; 2. Procedimiento genérico 'height'
(define (height b)
  (cond ((bob-box? b) (bob-height b))
        ((alice-box? b) (alice-height b))
        (else (error "Tipo de caja desconocido" b))))

; 3. Procedimiento genérico 'area'
;    (Definido en términos de los otros procedimientos genéricos)
(define (area b)
  (* (width b) (height b)))


; --- Pruebas del Ejercicio 2.C ---
(newline)
(display "--- Pruebas Ejercicio 2.C ---")
(newline)

; 1. Definir las cajas
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

(display "Caja a (Alice): ") a
(display "Caja b (Bob): ") b
(newline)

; 2. Verificar los procedimientos genéricos
; (Nota: Las salidas de 'width' en el texto del ejercicio
;  parecían estar intercambiadas. Estas son las correctas.)
(display "Ancho genérico de a (Alice): ")
(width a) ; Llama a alice-width(a) -> (abs (- 3 1)) -> 2

(display "Ancho genérico de b (Bob): ")
(width b) ; Llama a bob-width(b) -> 3
(newline)

(display "Alto genérico de a (Alice): ")
(height a) ; Llama a alice-height(a) -> (abs (- 4 2)) -> 2

(display "Alto genérico de b (Bob): ")
(height b) ; Llama a bob-height(b) -> 4
(newline)

(display "Área genérica de a (Alice): ")
(area a) ; Llama a (width a) * (height a) -> 2 * 2 -> 4

(display "Área genérica de b (Bob): ")
(area b) ; Llama a (width b) * (height b) -> 3 * 4 -> 12