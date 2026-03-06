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
    [else (cond
            [(not (char-numeric? (car list))) (error "Invalid expression")]
            ; Sum += first thing in list * 10^(length - 1)
            [else (charLH->num (cdr list) (+ sum (* (char->num (car list)) (expt 10 (- (length list) 1)))) negative)]
)]))

;(define (num->char num) (integer->char (+ num (char->integer #\0))))

(define (get-history list num)
  (cond
    [(> 0 num) (error "Seeing the future is outside the scope of this program")]
    [(> num (length list)) (error "Memory doesn't go back that far")]
    [else (num->list (list-ref (reverse list) (- num 1)))]
))
    

(define (create-stacks str hist) (create-stacksH str '() '() '() hist))

(define (create-stacksH str ops nums numMake hist)
;  (begin
 ;   (display "str: ")
  ;  (displayln str)
   ; (display "ops: ")
    ;(displayln ops)
    ;(display "nums: ")
    ;(displayln nums)
    ;(display "numMake: ")
    ;(displayln numMake)
    
  (cond
    ; If string (initial input), convert to list of chars
    [(string? str) (create-stacksH (string->list str) ops nums numMake hist)]
    ; If input is empty, stacks have been created, now evaluate them
    [(empty? str) (cond [(not (empty? numMake)) (cond
                       [(char=? #\$ (car (reverse numMake))) (create-stacksH str ops (cons (get-history hist (charL->num (cdr (reverse numMake)))) nums) '() hist)]
                       [else (create-stacksH str ops (cons (reverse numMake) nums) '() hist)])]
                       [else (evaluate-stacks
                              (filter (lambda (x) (not (empty? x))) ops) (filter (lambda (x) (not (empty? x))) nums) hist)]
    )]
    
    ; If next char is an operation, add it to ops
    ; Flushes numMake if empty; needs to check if the first character is a $ so it knows where to send it
    [(is-op (car str)) (cond [(not (empty? numMake)) (cond
                         [(char=? #\$ (car (reverse numMake))) (create-stacksH (cdr str) (cons (car str) ops) (cons (get-history hist (charL->num (cdr (reverse numMake)))) nums) '() hist)]
                         [else (create-stacksH (cdr str) (cons (car str) ops) (cons (reverse numMake) nums) '() hist)])]
                             [else (create-stacksH (cdr str) (cons (car str) ops) (cons (reverse numMake) nums) '() hist)]
                             )]
    
    ; Flushes numMake
    [(char-whitespace? (car str))
     (cond [(not (empty? numMake)) (cond
       [(char=? #\$ (car (reverse numMake))) (create-stacksH (cdr str) ops (cons (get-history hist (charL->num (cdr (reverse numMake)))) nums) '() hist)]
       [else (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '() hist)]
     )]
           [else (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '() hist)]
            )]

    ; Flushes numMake
    [(char=? #\- (car str))
     (cond [(not (empty? numMake)) (cond
       [(char=? #\$ (car (reverse numMake))) (create-stacksH (cdr str) ops (cons (get-history hist (charL->num (cdr (reverse numMake)))) nums) '(#\-) hist)]
       [else (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '(#\-) hist)]
    )]
           [else (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '(#\-) hist)]
           )]

    ; Flushes numMake
    [(char=? #\$ (car str))
     (cond [(not (empty? numMake)) (cond
       [(char=? #\$ (car (reverse numMake))) (create-stacksH (cdr str) ops (cons (get-history hist (charL->num (cdr (reverse numMake)))) nums) '(#\$) hist)]
       [else (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '(#\$) hist)]
       )]
           [else (create-stacksH (cdr str) ops (cons (reverse numMake) nums) '(#\$) hist)]
           )]

    [(char-numeric? (car str)) (create-stacksH (cdr str) ops nums (cons (car str) numMake) hist)]
    [else (error "Invalid input")]
))


(define (evaluate-stacks ops nums hist)
  ;(begin (display "\nNums:") (write nums) (display "\nOps") (write ops) (display "\n")
  (cond
    [(empty? ops) (cond
                    [(> 1 (length nums)) (error "Too many operands")]
                    [(= 1 (length nums)) (cons (charL->num (car nums)) hist)]
    )]
    
    [(> (length nums) 1) (cond
                           ;If the first thing in ops is +, pop two, add, push
                         [(char=? #\+ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (+ (charL->num (car nums)) (charL->num (car (cdr nums))))))) hist)]
                         ;[(char=? #\- (car ops)) (evaluate-stacks (cdr ops) (cons (cdr (cdr nums)) (list (num->list (- (charL->num (car (cdr nums))) (charL->num (car nums)))))) hist)]
                         [(char=? #\* (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (* (charL->num (car nums)) (charL->num (car (cdr nums))))))) hist)]
                         [(char=? #\/ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (/ (charL->num (car nums)) (charL->num (car (cdr nums))))))) hist)]
                         )]
    [(<= (length nums) 1) (error "Not enough operands")]
))

(define (main) (mainH "" '()))

(define (mainH str hist)
  (begin
    (cond [(not (empty? hist))
           (begin
             [display "$"]
             [display (length hist)]
             [display ": "]
             [displayln (car hist)]
        )])
    [display ">> "]
    [let ([x (read-line)])
       (cond
         [(string=? x "quit") (displayln "Exiting")]
         [else (mainH x (create-stacks x hist))])
            ]))