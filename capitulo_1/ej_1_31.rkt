#lang racket

;;versión recursiva
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

;;versión iterativa
(define (product-iter term a next b)
  (define (iter x acc)
    (if (> x b)
        acc
        (iter (next x) (* acc (term x)))))
  (iter a 1))

;;utilidades
(define (identity x) x)
(define (inc x) (+ x 1))

;;factorial usando product
(define (factorial n)
  (product identity 1 inc n))

(define (factorial-iter n)
  (product-iter identity 1 inc n))

;;producto de Wallis:
(define (pi-wallis N)
  (define (term n)
    (* (/ (* 2.0 n) (- (* 2.0 n) 1.0))
       (/ (* 2.0 n) (+ (* 2.0 n) 1.0))))
  (* 2.0 (product term 1 inc N)))

(define (pi-wallis-iter N)
  (define (term n)
    (* (/ (* 2.0 n) (- (* 2.0 n) 1.0))
       (/ (* 2.0 n) (+ (* 2.0 n) 1.0))))
  (* 2.0 (product-iter term 1 inc N)))

;;ejemplos
(module+ main
  (displayln (list 'factorial-6 (factorial 6)))         ; 720
  (displayln (list 'factorial-iter-6 (factorial-iter 6))) ; 720
  (displayln (list 'pi-wallis-1e5 (pi-wallis 100000)))  ; ~3.1415
  (displayln (list 'pi-wallis-iter-1e5 (pi-wallis-iter 100000))))
