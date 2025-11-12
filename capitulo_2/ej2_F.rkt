#lang racket

; =======================================================
; --- SOLUCIÓN: Ejercicio 2.F (Paso de Mensajes) ---
; =======================================================

; --- Implementación de Bob ---
(define (bob-make-box x y width height)
  ; Esta es la función interna que se convertirá en el "objeto"
  (define (dispatch message)
    (cond ((eq? message 'width) width)
          ((eq? message 'height) height)
          ((eq? message 'type) 'bob-box)
          (else (error "Mensaje desconocido para bob-box" message))))
  ; El constructor devuelve el procedimiento de despacho
  dispatch)

; --- Implementación de Alice ---
(define (alice-make-box x1 y1 x2 y2)
  ; El despacho de Alice calcula los valores en lugar de almacenarlos
  (define (dispatch message)
    (cond ((eq? message 'width) (abs (- x2 x1)))
          ((eq? message 'height) (abs (- y2 y1)))
          ((eq? message 'type) 'alice-box)
          (else (error "Mensaje desconocido para alice-box" message))))
  dispatch)

; --- Procedimientos Genéricos (Simples remitentes de mensajes) ---

(define (width box)
  (box 'width))

(define (height box)
  (box 'height))

(define (type-tag box)
  (box 'type))

; 'area' se construye sobre las abstracciones genéricas
(define (area box)
  (* (width box) (height box)))


; --- Pruebas del Ejercicio 2.F ---
(newline)
(display "--- Pruebas Ejercicio 2.F ---")
(newline)

; 1. Definir las "cajas" (que ahora son procedimientos)
(define a (alice-make-box 1 2 3 4)) ; 
(define b (bob-make-box 1 2 3 4))   ;

; 2. Probar los procedimientos genéricos
(display "Tipo de a (Alice): ")
(type-tag a) ; Llama a (a 'type) -> 'alice-box

(display "Tipo de b (Bob): ")
(type-tag b) ; Llama a (b 'type) -> 'bob-box
(newline)

(display "Ancho genérico de a (Alice): ")
(width a) ; Llama a (a 'width) -> 2

(display "Ancho genérico de b (Bob): ")
(width b) ; Llama a (b 'width) -> 3
(newline)

(display "Alto genérico de a (Alice): ")
(height a) ; Llama a (a 'height) -> 2

(display "Alto genérico de b (Bob): ")
(height b) ; Llama a (b 'height) -> 4
(newline)

(display "Área genérica de a (Alice): ")
(area a) ; Llama a (width a) * (height a) -> 4

(display "Área genérica de b (Bob): ")
(area b) ; Llama a (width b) * (height b) -> 12
(newline)

; 3. Prueba de llamada directa (como en el ejemplo del texto)
(display "Llamada directa a (b 'width): ")
(b 'width) ; -> 3