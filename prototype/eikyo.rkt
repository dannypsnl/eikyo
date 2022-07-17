#lang turnstile+/base
(provide (for-syntax eikyo))
(require (for-syntax syntax/identifier
                     syntax/stx
                     racket/base
                     racket/string
                     racket/set)
         "types.rkt")

(define-for-syntax (attach-mark? mark)
  (string-prefix? mark "+"))

(define-for-syntax (eikyo t1 t2)
  ; need this because recursive calls made with unexpanded types
  (define τ1 ((current-type-eval) t1))
  (define τ2 ((current-type-eval) t2))
  ; τ1 is to actual type
  ; τ2 is expected type
  (syntax-parse (list τ1 τ2)
    [((~with-mark (marks ...) τ1-) τ2)
     (unless (type=? #'τ1- #'τ2)
       (raise-syntax-error 'type
                           "mismatching"
                           t1 t2))
     (define new-marks (mutable-set))
     (for ([mark (stx-map identifier->string #'(marks ...))]
           [loc (syntax->list #'(marks ...))])
       (cond
         [(attach-mark? mark)
          (set-add!
           new-marks
           (string->identifier (string-trim mark "+" #:right? #f) loc))]
         [else
          ; TODO: require mark
          (void)]))
     (if (set-empty? new-marks)
         #'τ2
         #`(with-mark (#,@(set->list new-marks)) τ2))]
    [_ τ2]))
