#lang racket

;; sum: función de orden superior que generaliza la idea de sumar términos.
;; Recibe:
;;  - term: función que define el "término" a sumar (por ejemplo, square, inc, etc.).
;;  - next: función que define cómo pasar de un valor al siguiente (ej: inc).
;;  - a: valor inicial.
;;  - b: valor final.
;;
;; Recorre los valores desde a hasta b aplicando `term` y sumando los resultados.
;; El resultado final es la suma de todos esos términos.

(define (sum term next a b)
  ;; iter: función interna recursiva que acumula el resultado
  (define (iter a result)
    (if (> a b)                       ;; condición de parada: si a > b, se termina
        result                        ;; se devuelve el acumulado
        (iter (next a)                ;; paso recursivo: avanzar con next(a)
              (+ result (term a)))))  ;; acumular sumando term(a)
  (iter a 0))                         ;; inicializa con a y acumulador en 0
