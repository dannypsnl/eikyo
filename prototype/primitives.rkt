#lang turnstile+/base
(provide +)
(require "types.rkt")

(define-primop + : (→ number number number))
