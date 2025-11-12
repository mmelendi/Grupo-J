#lang racket

; --- Código base del Ejercicio 2.D (Necesario) ---
(define (attach-tag tag contents) (cons tag contents))
(define (type-tag datum) (car datum))
(define (contents datum) (cdr datum))

(define registry (make-hash))
(define (register name tag proc)
  (hash-set! registry (list name tag) proc))
(define (lookup name tag)
  (hash-ref registry (list name tag)))

; --- Constructores (Interfaz Pública) ---
; Estos permanecen en el espacio global
; para que el usuario pueda crear cajas.
(define (bob-make-box x y w h)
  (attach-tag 'bob-box (cons (cons x y) (cons w h))))

(define (alice-make-box x1 y1 x2 y2)
 (attach-tag 'alice-box (cons (cons x1 y1) (cons x2 y2))))


; =======================================================
; --- SOLUCIÓN: Ejercicio 2.E (Espacios de Nombres) ---
; =======================================================

; 1. Paquete de importación para Bob
(define (import-bob-box)
  ; --- Procedimientos internos (solo visibles aquí) ---
  (define (width box)
    (car (cdr (contents box))))
  (define (height box)
    (cdr (cdr (contents box))))
  ; --- Registro ---
  (register 'width 'bob-box width)
  (register 'height 'bob-box height)
  'done) ; Devuelve algo para indicar que ha terminado

; 2. Paquete de importación para Alice
(define (import-alice-box)
  ; --- Procedimientos internos (solo visibles aquí) ---
  (define (width box)
    (abs (- (car (cdr (contents box))) (car (car (contents box))))))
  (define (height box)
    (abs (- (cdr (cdr (contents box))) (cdr (car (contents box))))))
  ; --- Registro ---
  (register 'width 'alice-box width)
  (register 'height 'alice-box height)
  'done)

; --- Instalar los paquetes en el sistema ---
(import-bob-box)
(import-alice-box)

; --- Procedimientos Genéricos (de 2.D) ---
; Estos no cambian, pero ahora son la única forma
; de acceder a width/height.
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

(define (area box)
  (* (width box) (height box)))


; --- Pruebas del Ejercicio 2.E ---
(newline)
(display "--- Pruebas Ejercicio 2.E ---")
(newline)

; 1. Definir las cajas (usando los constructores públicos)
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

(display "Caja a (Alice): ") a
(display "Caja b (Bob): ") b
(newline)

; 2. Verificar los procedimientos genéricos
(display "Ancho genérico de a (Alice): ")
(width a) ; Funciona -> 2

(display "Ancho genérico de b (Bob): ")
(width b) ; Funciona -> 3
(newline)

; 3. Verificar que los nombres están ocultos
; (Si descomentas la línea de abajo, Racket dará un error:
;  "bob-width: unbound identifier")
;(bob-width b)