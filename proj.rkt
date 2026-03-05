#lang racket

(define (is-op char)
  (cond
    [(char=? #\+ char) #t]
    [(char=? #\* char) #t]
    [(char=? #\/ char) #t]
    [else #f]
    ))

(define (num->list n) (string->list (number->string n)))
(define (char->num char) (- (char->integer char) (char->integer #\0)))

; Given a list of character numbers, return the int they represent. Ex: '(#\1 #\2 #\3) returns 123
(define (charL->num list) (charLH->num list 0 #f))
(define (charLH->num list sum negative)
  (cond
    [(empty? list) (cond
                     [negative (* sum -1)]
                     [else sum])]
    [(char=? #\- (car list)) (charLH->num (cdr list) sum #t)]  
     ; Sum += first thing in list * 10^(length - 1)
    [else (charLH->num (cdr list) (+ sum (* (char->num (car list)) (expt 10 (- (length list) 1)))) negative)]
))

;(define (num->char num) (integer->char (+ num (char->integer #\0))))

(define (create-stacks str) (create-stacksH str '() '() '()))

(define (create-stacksH str ops nums numMake)
  (cond
    ; If string (initial input), convert to list of chars
    [(string? str) (create-stacksH (string->list str) ops nums numMake)]
    ; If input is empty, stacks have been created, now evaluate them
    ;[(empty? str)(evaluate-stacks ops nums)]
    [(empty? str) (cond
                    [(not (empty? numMake)) (create-stacksH str ops (cons (reverse numMake) nums) '())]
                    [else (evaluate-stacks ops (filter (lambda (x) (not (empty? x))) nums))]
                    )]
    
    ; If next char is an operation, add it to ops
    [(is-op (car str)) (create-stacksH (cdr str) (cons (car str) ops) (cons (reverse numMake) nums) '())]
    [(char-whitespace? (car str)) (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '())]
    [(char=? #\- (car str)) (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '(#\-))]
    [(char-numeric? (car str)) (create-stacksH (cdr str) ops nums (cons (car str) numMake))]
    [else (error "Invalid input")]
    ))


(define (evaluate-stacks ops nums)
  ;(begin (display "\nNums:") (write nums) (display "\nOps") (write ops) (display "\n")
  (cond
    [(empty? ops) (cond
                    [(> 1 (length nums)) (error "Too many operands")]
                    [(= 1 (length nums)) (charL->num (car nums))]
                    )]
    
    [(> (length nums) 1) (cond
                           ;If the first thing in ops is +, pop two, add, push
                         [(char=? #\+ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (+ (charL->num (car nums)) (charL->num (car (cdr nums))))))))]
                         ;[(char=? #\- (car ops)) (evaluate-stacks (cdr ops) (cons (cdr (cdr nums)) (list (num->list (- (charL->num (car (cdr nums))) (charL->num (car nums)))))))]
                         [(char=? #\* (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (* (charL->num (car nums)) (charL->num (car (cdr nums))))))))]
                         [(char=? #\/ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (/ (charL->num (car nums)) (charL->num (car (cdr nums))))))))]
                         )]
    [(<= (length nums) 1) (error "Not enough operands")]
    ))
;)

(define (main) (mainH ""))

(define (mainH str)
  (cond
    [(string=? "quit" str) (display "Exiting")]
    [else (begin
            [cond ((not (string=? str "")) (display (create-stacks str)))]
            [display "\n> "]
            [mainH (read-line)]
            )]))
            