#lang turnstile+/base
(provide (type-out →)
         number string)

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

(define-base-types number string)

(module+ test
  (require rackunit/turnstile)

  (check-type number :: #%type))
