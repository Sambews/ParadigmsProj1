#lang racket

(define (is-op char)
  (cond
    [(char=? #\+ char) #t]
    [(char=? #\- char) #t]
    [(char=? #\* char) #t]
    [(char=? #\/ char) #t]
    [else #f]
    ))

(define (char->num char) (- (char->integer char) (char->integer #\0)))
(define (num->char num) (integer->char (+ num (char->integer #\0))))

     
(define (create-stacks str) (create-stacksH str '() '()))

(define (create-stacksH str ops nums)
  (cond
    [(string? str) (create-stacksH (string->list str) ops nums)]
    [(empty? str) (evaluate-stacks ops nums)]
    [(is-op (car str)) (create-stacksH (cdr str) (cons (car str) ops) nums)]
    [(char-numeric? (car str)) (create-stacksH (cdr str) ops (cons (car str) nums))]
    ))

(define (evaluate-stacks ops nums)
  (cond
    [(empty? ops) (cond
                    [(= 1 (length nums)) (char->num (car nums))])]
    [(> (length nums) 1) (cond
                           ;If the first thing in ops is +, pop two, add, push
                         [(char=? #\+ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->char (+ (char->num (car nums)) (char->num (car (cdr nums))))))))]
                         [(char=? #\- (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->char (- (char->num (car (cdr nums))) (char->num (car nums)))))))]
                         [(char=? #\* (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->char (* (char->num (car nums)) (char->num (car (cdr nums))))))))]
                         [(char=? #\/ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->char (/ (char->num (car nums)) (char->num (car (cdr nums))))))))]
                         )]
    ))