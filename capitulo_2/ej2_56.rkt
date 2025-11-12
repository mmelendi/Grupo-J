#lang racket

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list '+ a1 a2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0))
         0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2))
         (* m1 m2))
        (else (list '* m1 m2))))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '^)))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (make-exponentiation base exp)
  (cond ((=number? exp 0) 1)
        ((=number? exp 1) base)
        (else (list '^ base exp))))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
        ((exponentiation? exp)
         (make-product
          (make-product (exponent exp)
                        (make-exponentiation (base exp)
                                             (- (exponent exp) 1)))
          (deriv (base exp) var)))
        (else (error "expresión desconocida para DERIV" exp))))





; =======================================================
; --- PRUEBAS DE USO ---
; =======================================================
(newline)
(display "--- Pruebas para 'deriv' ---")
(newline)

; --- Pruebas del texto original ---

; d(x+3)/dx = 1
(display "d(x+3)/dx --> ")
(deriv '(+ x 3) 'x)

; d(x*y)/dx = y
(display "d(xy)/dx --> ")
(deriv '(* x y) 'x)

; d( (x*y)*(x+3) )/dx = (x*y) + y*(x+3)
(display "d((xy)(x+3))/dx --> ")
(deriv '(* (* x y) (+ x 3)) 'x)

; --- Pruebas para la nueva exponenciación (Ej. 2.56) ---

; Prueba 1: d(x^3) / dx
; Esperado: (* 3 (^ x 2))
(display "d(x^3)/dx --> ")
(deriv '(^ x 3) 'x)

; Prueba 2: d(y^5) / dx (derivada respecto a x)
; Esperado: 0
(display "d(y^5)/dx --> ")
(deriv '(^ y 5) 'x)

; Prueba 3: d((x + 3)^4) / dx
; Esperado: (* 4 (^ (+ x 3) 3))
(display "d((x+3)^4)/dx --> ")
(deriv '(^ (+ x 3) 4) 'x)

; Prueba 4: d( (x * y)^3 ) / dx
; Esperado: (* 3 (* (^ (* x y) 2) y))
(display "d((xy)^3)/dx --> ")
(deriv '(^ (* x y) 3) 'x)

; Prueba 5: Simplificación u^1
; d(x^2)/dx = 2 * x^1 * 1 = (* 2 x)
(display "d(x^2)/dx --> ")
(deriv '(^ x 2) 'x)

; Prueba 6: Simplificación u^0
; d(y^1)/dx = d(y)/dx = 0
(display "d(y^1)/dx --> ")
(deriv '(^ y 1) 'x)