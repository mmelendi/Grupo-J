#lang racket

; --- Código base del Ejercicio 2.B (Necesario) ---

(define (attach-tag tag contents) (cons tag contents))
(define (type-tag datum) (car datum))
(define (contents datum) (cdr datum))

; --- Implementación de Bob (con Etiquetas) ---
(define (bob-make-box x y w h)
  (attach-tag 'bob-box (cons (cons x y) (cons w h))))
(define (bob-width box) (car (cdr (contents box))))
(define (bob-height box) (cdr (cdr (contents box))))
; (Ya no necesitamos bob-box? ni bob-area)

; --- Implementación de Alice (con Etiquetas) ---
(define (alice-make-box x1 y1 x2 y2)
 (attach-tag 'alice-box (cons (cons x1 y1) (cons x2 y2))))
(define (alice-width box)
  (abs (- (car (cdr (contents box))) (car (car (contents box))))))
(define (alice-height box)
  (abs (- (cdr (cdr (contents box))) (cdr (car (contents box))))))
; (Ya no necesitamos alice-box? ni alice-area)


; =======================================================
; --- SOLUCIÓN: Ejercicio 2.D (Registro y Despacho) ---
; =======================================================

; 1. El Registro (Tabla Hash Global)
(define registry (make-hash))

; 2. Procedimiento para AÑADIR al registro
(define (register name tag proc)
  (hash-set! registry (list name tag) proc))

; 3. Procedimiento para BUSCAR en el registro
(define (lookup name tag)
  (hash-ref registry (list name tag)))

; --- Registrar los procedimientos específicos ---
; (Esto "instala" los tipos en el sistema genérico)
(register 'width 'bob-box bob-width)
(register 'height 'bob-box bob-height)

(register 'width 'alice-box alice-width)
(register 'height 'alice-box alice-height)

; --- Procedimientos Genéricos (Basados en Registro) ---

(define (width box)
  (define tag (type-tag box))
  (define proc (lookup 'width tag))
  (if proc
      (proc box)
      (error "Procedimiento 'width' no encontrado para" tag)))

(define (height box)
  (define tag (type-tag box))
  (define proc (lookup 'height tag))
  (if proc
      (proc box)
      (error "Procedimiento 'height' no encontrado para" tag)))

; 'area' se construye sobre las abstracciones genéricas 'width' y 'height'.
(define (area box)
  (* (width box) (height box)))


; --- Pruebas del Ejercicio 2.D ---
(newline)
(display "--- Pruebas Ejercicio 2.D ---")
(newline)

; 1. Definir las cajas
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

(display "Caja a (Alice): ") a
(display "Caja b (Bob): ") b
(newline)

; 2. Verificar los procedimientos genéricos
(display "Ancho genérico de a (Alice): ")
(width a) ; Llama a lookup('width, 'alice-box) -> 2

(display "Ancho genérico de b (Bob): ")
(width b) ; Llama a lookup('width, 'bob-box) -> 3
(newline)

(display "Alto genérico de a (Alice): ")
(height a) ; Llama a lookup('height, 'alice-box) -> 2

(display "Alto genérico de b (Bob): ")
(height b) ; Llama a lookup('height, 'bob-box) -> 4
(newline)

(display "Área genérica de a (Alice): ")
(area a) ; Llama a (width a) * (height a) -> 2 * 2 -> 4

(display "Área genérica de b (Bob): ")
(area b) ; Llama a (width b) * (height b) -> 3 * 4 -> 12