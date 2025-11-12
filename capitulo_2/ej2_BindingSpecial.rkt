#lang racket
; Función para enlazar (bind) variables en un patrón con los valores correspondientes en los datos.
; Una variable de patrón se identifica por ser un símbolo que empieza por '?'.

; Ayudante para saber si un símbolo de patrón es variable
(define (pattern-var? sym) (and (symbol? sym) (equal? (substring (symbol->string sym) 0 1) "?")))

; Agrega un par (nombre valor) nuevo a una lista de bindings, reemplazando si existe
(define (add-binding name value bindings)
  (cons (list name value)
        (filter (lambda (entry) (not (equal? (car entry) name))) bindings)))

; Función principal de binding
(define (bind pattern data)
  (define (bind-helper pat dat bindings)
    (cond
      ; Si el patrón es variable, la enlazamos
      [(pattern-var? pat)
       (add-binding (string->symbol (substring (symbol->string pat) 1)) dat bindings)]
      ; Si ambos son listas, hacemos binding recursivo de sus elementos
      [(and (pair? pat) (pair? dat))
       (let ([bindings2 (bind-helper (car pat) (car dat) bindings)])
         (if bindings2
             (bind-helper (cdr pat) (cdr dat) bindings2)
             #f))]
      ; Si ambos son iguales y no variables, avanzamos (no agregamos binding)
      [(equal? pat dat) bindings]
      ; No coincide
      [else #f]))
  (let ([result (bind-helper pattern data '())])
    (if (null? result) #f result)))

; ---- Ejemplo de registro ----
(define record '(job (Hacker Alyssa P) (computer programmer)))

; Ejemplos:
(bind '(job ?name ?job) record)
; => '((name (Hacker Alyssa P)) (job (computer programmer)))

(bind '(?type ?name (?what programmer)) record)
; => '((type job) (name (Hacker Alyssa P)) (what computer))

(bind '(job ?what) record)
; => #f ; No coincide: el patrón espera solo dos elementos después de 'job
