#lang turnstile+/base
(module reader syntax/module-reader eikyo)
(provide #%module-begin #%top-interaction
         require
         (all-from-out
          "meta-form.rkt"
          ; form
          "form.rkt"
          ; bulitin types
          "types.rkt"
          ; primitives
          "primitives.rkt"))
(require
  "meta-form.rkt"
  "form.rkt"
  "types.rkt"
  "primitives.rkt")
