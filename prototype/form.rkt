#lang turnstile+/base
(provide λ
         define)
(require "types.rkt")

(define-syntax define
  (syntax-parser
    [(_ x:id : ty e)
     #'(define-typed-variable x e ⇐ ty)]))

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
