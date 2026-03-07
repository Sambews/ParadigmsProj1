#lang racket
;; Provided program to do stuff etc
(define interactive?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))

;; Checks to see if a character is +, *, or /
(define (is-op char)
  (cond
    [(char=? #\+ char) #t]
    [(char=? #\* char) #t]
    [(char=? #\/ char) #t]
    [else #f]
))
;; Converts an int to a character list
(define (num->list n) (string->list (number->string n)))

;; Helper function for below
(define (char->num char) (- (char->integer char) (char->integer #\0)))
; Given a list of character numbers, return the int they represent. Ex: '(#\1 #\2 #\3) returns 123
(define (charL->num list) (charLH->num list 0 #f))
(define (charLH->num list sum negative)
  (cond
    ;; Base case is list is empty
    [(empty? list) (cond
                     ;; Return -sum if negative, sum otherwise
                     [negative (* sum -1)]
                     [else sum])]
    ;;If a - is encountered, remove it and set the negative parameter to true
    [(char=? #\- (car list)) (charLH->num (cdr list) sum #t)]       
    [else (cond
            ; If a non - number is encountered, raise an error
            [(not (char-numeric? (car list))) (error "Error: Invalid expression")]
            ; Sum += first thing in list * 10^(length - 1)
            [else (charLH->num (cdr list) (+ sum (* (char->num (car list)) (expt 10 (- (length list) 1)))) negative)]
)]))

;(define (num->char num) (integer->char (+ num (char->integer #\0))))

(define (get-history list num)
  (cond
    [(> 0 num) (error "Error: Seeing the future is outside the scope of this program")]
    [(> num (length list)) (error "Error: Memory doesn't go back that far")]
    [else (num->list (list-ref (reverse list) (- num 1)))]
))
    

(define (create-stacks str hist) (create-stacksH str '() '() '() hist))

(define (create-stacksH str ops nums numMake hist)
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
    ;; numMake is used to ensure 23 is processed as twenty three, not two and three
    ;; When a number or $ is encountered, it's put into numMake
    ;; When a non-number is encountered, numMake is flushed.
    ;; This could create empty strings in the nums list, so nums is filtered
    ;; The number could be for a history call, so if numMake isn't empty, check to see if the first char is $. If it is, put the output of get-history into nums
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
    ;; If a number, put into numMake
    [(char-numeric? (car str)) (create-stacksH (cdr str) ops nums (cons (car str) numMake) hist)]
    [else (error "Error: Invalid input")]
))


(define (evaluate-stacks ops nums hist)
  (cond
    ;; Base case is no more operators and one operand. Raise an error if multiple operands
    [(empty? ops) (cond
                    [(> 1 (length nums)) (error "Error: Too many operands")]
                    [(= 1 (length nums)) (cons (charL->num (car nums)) hist)]
    )]
    
    [(> (length nums) 1) (cond
                           ;If the first thing in ops is +, pop two, add, push. Same for * or /
                         [(char=? #\+ (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (+ (charL->num (car nums)) (charL->num (car (cdr nums))))))) hist)]
                         [(char=? #\* (car ops)) (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (* (charL->num (car nums)) (charL->num (car (cdr nums))))))) hist)]
                         [(char=? #\/ (car ops)) (cond
                                                   ;; Check for dividing by zero
                                                   [(= 0 (charL->num (car nums))) (error "Error: Cannot divide by 0")]
                                                   [else (evaluate-stacks (cdr ops) (append (cdr (cdr nums)) (list (num->list (quotient (charL->num (car (cdr nums))) (charL->num (car nums)))))) hist)])]
                         )]
    [(<= (length nums) 1) (error "Error: Not enough operands")]
))

(define (main) (mainH "" '()))

(define (mainH str hist)
  (begin
    [cond [(not (empty? hist))
           ;;Display UI if interactive
           (cond [interactive?
                  (begin
                    [display "$"]
                    [display (length hist)]
                    [display ": "]
                    [displayln (real->double-flonum (car hist))]
                    )]
           ;; Otherwise (batch) only display output
           [else (displayln (real->double-flonum (car hist)))])]]
    ;; Only display prompt if in interactive mode
    (cond (interactive? [display ">> "]))
    ;; Get input. If input is quit, quit, otherwise process it
    [let ([input (read-line)])
       (cond
         [(string=? input "quit") (displayln "Exiting")]
         [else (mainH input (create-stacks input hist))])
            ]))