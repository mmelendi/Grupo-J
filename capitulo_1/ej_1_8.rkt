#lang racket

;Use this formula to implement a cube-root procedure analogous to the square-root procedure:

(define (raiz-cubica x)
  (define (mejor-aproximacion y)                                ;Implementamos la formula de Newton
    (/ (+ (/ x (* y y)) (* 2 y)) 3))
  
  (define (cerca? a b)                                          ;Verifica si la nueva aprox es suficientemente cercana a la anterior
    (< (abs (- a b)) 1.0e-12))
  
  (define (raiz-cubica-iteracion y)                             
    (let ((nueva (mejor-aproximacion y)))
      (if (cerca? y nueva)
          nueva
          (raiz-cubica-iteracion nueva))))
  
  ;; Adivinanza inicial: x si |x|<1, x/3 si |x|>=1
  (raiz-cubica-iteracion (if (< (abs x) 1) x (/ x 3.0))))      ;Se hace la iteracion recursiva hasta converger

;Ejemplos funcionamiento:
(raiz-cubica 27)
(raiz-cubica -8)    
(raiz-cubica 1)    
(raiz-cubica 0.001) 