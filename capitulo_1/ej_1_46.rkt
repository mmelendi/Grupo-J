#lang racket

(define (iterative-improve good-enough? improve)
  (letrec ([loop (lambda (guess)
                   (if (good-enough? guess)
                       guess
                       (loop (improve guess))))])
    loop))

;;valor absoluto
(define (abs x) (if (< x 0) (- x) x))

;;sqrt(x) ≈ buscar y tal que y^2 = x
(define (sqrt x)
  (define tolerance 1e-10)
  (define (good-enough? y)
    (< (abs (- (* y y) x)) tolerance))
  (define (improve y)
    (/ (+ y (/ x y)) 2.0)) ; promedio de y y x/y (metodo de Newton)
  ((iterative-improve good-enough? improve) 1.0))

;;encuentra y tal que g(y) ≈ y
(define (fixed-point g)
  (define tolerance 1e-10)
  (define (good-enough? y)
    (< (abs (- (g y) y)) tolerance))
  (define (improve y)
    (g y))
  ((iterative-improve good-enough? improve) 1.0))

;;ejemplos:
;;sqrt(2) ~ 1.41421356237
(define ejemplo-sqrt (sqrt 2.0))

(define ejemplo-fp
  (fixed-point cos))

(module+ main
  (displayln (list 'sqrt-2 ejemplo-sqrt))
  (displayln (list 'fp-cos ejemplo-fp)))
