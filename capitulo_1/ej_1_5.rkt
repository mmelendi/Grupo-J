#lang racket
(define (p) (p))           ; Bucle infinito
(define (test x y)         ; Prueba condicional
  (if (= x 0) 0 y))
(test 0 (p)) → (if (= 0 0) 0 (p))

;Con evaluación por orden aplicativo:
;El programa entra en un bucle infinito y nunca termina.

;Explicación: En el orden aplicativo se evalúan todos los argumentos antes de aplicar el procedimiento. Al evaluar (test 0 (p)), el intérprete debe evaluar primero 0 y luego (p). Como (p) se llama recursivamente a sí mismo sin condición de parada, el programa queda atrapado en un bucle infinito.

;Con evaluación por orden normal:
;El programa retorna 0.

;Explicación: En el orden normal no se evalúan los argumentos hasta que sus valores son necesarios. La expresión (test 0 (p)) se desarrolla asi:
;(if (= 0 0) 0 (p))
;Como (= 0 0) evalúa a #t, el if retorna 0 y nunca necesita evaluar (p), evitando así el bucle infinito.

;Diferencia clave: El orden aplicativo evalúa todos los argumentos inmediatamente, mientras que el orden normal solo evalúa lo que es necesario para completar la operación.
