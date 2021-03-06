(define-library (srfi-tests 54)
  (export run-tests)
  (import
   (scheme base)
   (scheme char)
   (scheme write)
   (srfi 54)
   (srfi 64)
   (srfi-tests aux))
  (begin

    (define-syntax value-and-output
      (syntax-rules ()
        ((_ expr)
         (let ((port (open-output-string)))
           (parameterize ((current-output-port port))
             (let ((value expr))
               (list value (get-output-string port))))))))

    (define (string-reverse string)
      (list->string (reverse (string->list string))))

    (define-tests run-tests "SRFI-54"
      (test-equal "130.00    " (cat 129.995 -10 2.))
      (test-equal "    130.00" (cat 129.995 10 2.))
      (test-equal "    129.98" (cat 129.985 10 2.))
      (test-equal "    129.99" (cat 129.985001 10 2.))
      (test-equal "#e130.00" (cat 129.995 2. 'exact))
      (test-equal "129.00" (cat 129 -2.))
      (test-equal "#e129.00" (cat 129 2.))
      (test-equal "#e+0129.00" (cat 129 10 2. #\0 'sign))
      (test-equal "*#e+129.00" (cat 129 10 2. #\* 'sign))
      (test-equal "1/3" (cat 1/3))
      (test-equal "    #e0.33" (cat 1/3 10 2.))
      (test-equal "      0.33" (cat 1/3 10 -2.))
      (test-equal " 1,29.99,5" (cat 129.995 10 '(#\, 2)))
      (test-equal "  +129,995" (cat 129995 10 '(#\,) 'sign))
      (test-equal "130" (cat (cat 129.995 0.) '(0 -1)))
      (cond-expand (chibi (test-expect-fail 2)) (else))
      (test-equal "#i#o+307/2" (cat 99.5 10 'sign 'octal))
      (test-equal "  #o+307/2" (cat 99.5 10 'sign 'octal 'exact))
      (test-equal "#o+443" (cat #x123 'octal 'sign))
      (test-equal "#e+291.00*" (cat #x123 -10 2. 'sign #\*))
      (test-equal "-1.234e+15+1.236e-15i" (cat -1.2345e+15+1.2355e-15i 3.))
      (test-equal "+1.234e+15" (cat 1.2345e+15 10 3. 'sign))
      (test-equal "string    " (cat "string" -10))
      (test-equal "    STRING" (cat "string" 10 (list string-upcase)))
      (test-equal "      RING" (cat "string" 10 (list string-upcase) '(-2)))
      (test-equal "     STING" (cat "string" 10 `(,string-upcase) '(2 3)))
      (test-equal "GNIRTS" (cat "string" `(,string-reverse ,string-upcase)))
      (test-equal "         a" (cat #\a 10))
      (test-equal "    symbol" (cat 'symbol 10))
      (test-equal "#(#\\a \"str\" s)" (cat '#(#\a "str" s)))
      (test-equal "(#\\a \"str\" s)" (cat '(#\a "str" s)))
      (test-equal '("(#\\a \"str\" s)" "(#\\a \"str\" s)")
          (value-and-output (cat '(#\a "str" s) #t)))
      (test-equal '("(#\\a \"str\" s)" "(#\\a \"str\" s)")
          (value-and-output (cat '(#\a "str" s) (current-output-port))))
      (test-equal "3s \"str\"" (cat 3 (cat 's) " " (cat "str" write)))
      (test-equal '("3s \"str\"" "3s \"str\"")
          (value-and-output (cat 3 #t (cat 's) " " (cat "str" write))))
      (test-equal '("3s \"str\"" "s3s \"str\"")
          (value-and-output (cat 3 #t (cat 's #t) " " (cat "str" write)))))

    ))
