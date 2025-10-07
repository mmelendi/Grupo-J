#lang racket

;; iterative-improve: función de orden superior que implementa un patrón
;; general para mejorar aproximaciones sucesivas hasta alcanzar
;; una condición de "suficientemente bueno".
;;
;; Recibe:
;;   - good-enough? : función que evalúa si la aproximación actual es válida.
;;   - improve      : función que produce una nueva aproximación a partir de la actual.
;;
;; Devuelve una función (loop) que, dado un valor inicial (guess),
;; va aplicando "improve" hasta cumplir la condición "good-enough?".
(define (iterative-improve good-enough? improve)
  (letrec ([loop (lambda (guess)
                   (if (good-enough? guess)
                       guess
                       (loop (improve guess))))])
    loop))

;; valor absoluto
(define (abs x) (if (< x 0) (- x) x))

;; sqrt(x): calcula la raíz cuadrada de x usando iterative-improve
;; Método de Newton: y_(n+1) = (y + x/y) / 2
(define (sqrt x)
  (define tolerance 1e-10) ;; margen de error aceptable
  (define (good-enough? y)
    (< (abs (- (* y y) x)) tolerance)) ;; y^2 ≈ x
  (define (improve y)
    (/ (+ y (/ x y)) 2.0)) ;; fórmula de Newton
  ((iterative-improve good-enough? improve) 1.0)) ;; comienza con guess = 1.0

;; fixed-point(g): busca un punto fijo de la función g,
;; es decir, un valor y tal que g(y) ≈ y
(define (fixed-point g)
  (define tolerance 1e-10)
  (define (good-enough? y)
    (< (abs (- (g y) y)) tolerance)) ;; condición: g(y) ≈ y
  (define (improve y)
    (g y)) ;; el "mejoramiento" es aplicar g directamente
  ((iterative-improve good-enough? improve) 1.0)) ;; arranca desde 1.0

;; ejemplos de uso:

;; sqrt(2) ≈ 1.41421356237
(define ejemplo-sqrt (sqrt 2.0))

;; punto fijo de cos(x): solución de cos(y) ≈ y
;; converge a ~0.739085...
(define ejemplo-fp
  (fixed-point cos))

;; módulo principal: imprime los resultados
(module+ main
  (displayln (list 'sqrt-2 ejemplo-sqrt))
  (displayln (list 'fp-cos ejemplo-fp)))
