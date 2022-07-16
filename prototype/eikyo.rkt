#lang turnstile+/base
(provide (for-syntax eikyo))
(require "types.rkt")

(define-for-syntax (eikyo t1 t2)
  ; need this because recursive calls made with unexpanded types
  (define τ1 ((current-type-eval) t1))
  (define τ2 ((current-type-eval) t2))
  ; τ1 is to actual type
  ; τ2 is expected type
  (syntax-parse (list τ1 τ2)
    [((~with-mark (marks) τ1-) τ2)
     (println #'marks)
     #'τ2
     ]
    [_ τ2]))
