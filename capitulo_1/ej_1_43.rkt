#lang racket

;; compose: devuelve una nueva función que aplica g a x
;; y luego f al resultado (f ∘ g).
;; Por ejemplo: ((compose square inc) 5) = square(inc(5)) = 36
(define (compose f g)
  (lambda (x) (f (g x))))

;; repeated: construye una función que aplica f n veces a su argumento
;; - Si n = 0, devuelve la función identidad (lambda (x) x).
;; - Si n > 0, compone f con la función "repeated f (n-1)".
;;   Así se construye la iteración de f n veces.
(define (repeated f n)
  (cond
    [(zero? n) (lambda (x) x)]               ;; caso base: identidad
    [else (compose f (repeated f (sub1 n)))] ;; paso recursivo
  ))

;; square: función que eleva al cuadrado su argumento
(define (square x) (* x x))

;; ejemplo-143:
;; (repeated square 2) genera una función que aplica square dos veces.
;;   Paso 1: (square 5) = 25
;;   Paso 2: (square 25) = 625
;; Resultado: 625
(define ejemplo-143
  ((repeated square 2) 5)) ; debería mostrar 625

;; módulo principal: imprime el resultado
(module+ main
  (displayln (list 'ejemplo-143 ejemplo-143)))

