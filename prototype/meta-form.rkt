#lang turnstile+/base
(provide #%app #%datum)
(require "types.rkt")

(define-typed-syntax (#%app e-fun e-args ...) ≫
  ; infer type of func, produces a arrow type
  [⊢ e-fun ≫ e-fun- ⇒ (~→ args-typ ... return-typ)]
  ; ensure exp and type length matched
  ; if fail, use `num-args-fail-msg` constructs error message
  #:fail-unless (stx-length=? #'[args-typ ...] #'[e-args ...])
  (num-args-fail-msg #'e-fun #'[args-typ ...] #'[e-args ...])
  ; check(⇐) arg*
  [⊢ e-args ≫ e-args- ⇐ args-typ] ...
  ---------
  ; synth(⇒) typ/return via application
  [⊢ (#%app- e-fun- e-args- ...) ⇒ return-typ])

;;; extension
(define-typed-syntax #%datum
  [(_ . n:number) ≫
   ---------
   [⊢ (#%datum- . n) ⇒ number]]
  [(_ . s:string) ≫
   ---------
   [⊢ (#%datum- . s) ⇒ string]]
  [(_ . x) ≫
   ---------
   [#:error (type-error #:src #'x #:msg "unknown: ~v" #'x)]])
