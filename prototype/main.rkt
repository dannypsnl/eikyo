#lang racket
(require syntax/parse/define
         (for-syntax syntax/stx))

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

  (define-syntax-class mark
    #:datum-literals (+ - ?+ ?-)
    (pattern (+ name:id))
    (pattern (- name:id))
    (pattern (?+ name:id))
    (pattern (?- name:id))
    (pattern name:id))

  (define-syntax-class fun-type
    #:datum-literals (-> : fun)
    (pattern (fun [name:id : ty:type] ... -> ret:type)))

  (define-syntax-class type
    #:datum-literals (~ -> fun)
    (pattern (~ ty:type m*:mark ...))
    (pattern ty:fun-type)
    (pattern name:id))

  (define (fun? ty-stx)
    (syntax-parse ty-stx
      [ty:fun-type #t]
      [else #f]))
  )

(define-syntax (LET stx)
  (syntax-parse stx
    #:datum-literals (: =)
    [(_ name:id : ty:type = e:expr)
     (hash-set! $env (syntax->datum #'name) #'ty)
     (quasisyntax/loc stx
       (define name e))]))

(define-syntax (FUN stx)
  (syntax-parse stx
    #:datum-literals (:)
    [(_ (name:id [params:id : param-tys:type] ...) : ret:type
        body:expr ...)
     (hash-set! $env (syntax->datum #'name) #'(fun [params : param-tys] ... -> ret))
     (quasisyntax/loc stx
       (define (name params ...)
         body ...))]))

(define-syntax (APP stx)
  (syntax-parse stx
    [(_ fun:expr args:expr ...)
     (unless (fun? (hash-ref $env (syntax->datum #'fun)))
       (raise-syntax-error 'non-fun
                           "call on non function"
                           #'fun))
     (println (stx-map (λ (a) (hash-ref $env (syntax->datum a))) #'(args ...)))
     (quasisyntax/loc stx
       (fun args ...))]))

(LET a : int = 1)
a
(LET b : (~ int (+ owned)) = 2)
b

(FUN (use [n : (~ int (- owned))]) : void
     (println use)
     (void))
(APP use b)
