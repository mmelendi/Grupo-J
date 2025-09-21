#lang racket
; El nuevo if evalúa ambas ramas (tanto el then como el else)
; Porque evalúa los argumentos antes que el cuerpo de la procedure
; Lo que hace que al evaluar la rama falsa entre en una recursión infinita