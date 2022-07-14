#lang turnstile+/base
(provide #%module-begin #%top-interaction #%app #%datum
         require
         λ
         define
         ; bulitin types
         (type-out →)
         number string)

(module reader syntax/module-reader eikyo)

; (→ typ/param* ... typ/return)
(define-type-constructor →
  #:arity >= 1
  #:arg-variances
  (λ (stx)
    (syntax-parse stx
      [(_ typ/param* ... typ/return)
       (append
        (stx-map (λ _ contravariant) #'[typ/param* ...])
        (list covariant))])))

(define-typed-syntax define
  #:datum-literals (:)
  [(_ x:id : ty:type e)
   ≫
   [⊢ e ≫ e- ⇐ ty]
   ---------------
   [≻ (define- x e-)]])

(define-typed-syntax λ
  #:datum-literals (:)
  ;;; typed form: (λ ([x : Nat]) x)
  [(λ ([x:id : params-typ:type] ...) e) ≫
                                        [[x ≫ x- : params-typ] ... ⊢ e ≫ e- ⇒ return-typ]
                                        ---------
                                        [⊢ (λ- (x- ...) e-) ⇒ (→ params-typ ... return-typ)]]
  ;;; inferred form: (λ (x) x)
  [(λ (x:id ...) e) ⇐ (~→ params-typ ... return-typ) ≫
                    [[x ≫ x- : params-typ] ... ⊢ e ≫ e- ⇐ return-typ]
                    ---------
                    [⊢ (λ- (x- ...) e-)]])

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
(define-base-types number string)

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
