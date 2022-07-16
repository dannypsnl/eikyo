#lang eikyo

(define x : number 3)
(+ x x)

(define a : (with-mark (+owned) number) 2)
(+ a a)
