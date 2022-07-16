#lang turnstile+/base
(provide λ
         define)
(require "types.rkt"
         "eikyo.rkt")

(define-typed-syntax define
  #:datum-literals (:)
  [(_ x:id : ty:type e) ≫ [⊢ e ≫ e- ⇒ τ]
   -------------------------------------
   [≻ (define-typed-variable x e- ⇒
        #,(eikyo #'ty #'τ))]]
  [(_ x:id e) ≫ [⊢ e ≫ e- ⇒ τ]
   -------------------------------------
   [≻ (define-typed-variable x e- ⇒ τ)]])

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
