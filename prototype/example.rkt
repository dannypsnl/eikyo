#lang eikyo

(define x : number 3)
(+ x x)

(define a : (with-mark (+owned test) number) 2)
; FIXME: type mismatch: expected number, given (with-mark (owned) number)
; this is because a has mark now
; next thing is let type relation ignore the mark when no require
; (+ a a)
