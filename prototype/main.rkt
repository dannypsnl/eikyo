#lang racket
(require syntax/parse/define)

(begin-for-syntax
  (define $env (make-hash))

  (struct base ())
  (struct Int base ())
  (struct TyWith (ty mark*))
  (define <int> (Int))

  (struct mark:unit (name))
  (struct mark:+ (name))
  (struct mark:?+ (name))
  (struct mark:- (name))
  (struct mark:?- (name))

  (define (with-mark ty-stx mark*-stx)
    (TyWith (parse-ty ty-stx) (parse-mark mark*-stx)))
  (define (parse-ty ty-stx)
    (syntax-parse ty-stx
      #:datum-literals (int)
      [int <int>]
      [else (error 'skip)]))
  (define (parse-mark m-stx)
    (mark:unit 'd)))

(define-syntax (LET stx)
  (syntax-parse stx
    #:datum-literals (:)
    [(_ n:id : ty e:expr)
     (hash-set! $env (syntax->datum #'n) (parse-ty #'ty))
     (quasisyntax/loc stx
       (define n e))]
    [(_ n:id : ty mark ... e:expr)
     (hash-set! $env (syntax->datum #'n) (with-mark #'ty #'(mark ...)))
     (quasisyntax/loc stx
       (define n e))]))

(LET a : int 1)
a
