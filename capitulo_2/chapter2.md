# Chapter 2 : Building Abstractions with Data

In real programs, you need to work with more complex abstractions
of data than just the simple types.  Programming languages provide
a mechanism to define records, lists, trees, and other kinds of
data structures.

This chapter discusses some important ideas about data abstraction and
ultimately develops some foundational concepts that underly work in
type systems and object oriented programming.

## [2.1 Introduction to Data Abstraction](http://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1)

Scheme provide a mechanism to make pairs.  Use `cons` like this:

```
(define p (cons 3 4))
```

This makes a small data cell that holds both values:

```
 -------
| 3 | 4 |
 -------
```

To access to the individual components, use `car` and `cdr`.

```
(car p)     ; -> 3
(cdr p)     ; -> 4
```

This structure is comparable to the idea of a Python 2-tuple. Essentially
it's just two values packed together. That's it.

Digression:  The names `car` and `cdr` are historical--coming from the earliest
days of Lisp programming on the IBM 704.  `CAR` and `CDR` were macros
for accessing different parts of an instruction encoding.  Read [this](https://en.wikipedia.org/wiki/CAR_and_CDR)
for more information.

`cons` is extremely flexible.  You can make a pair out of anything you want, including
other pairs.  For example:

```
(cons 3 4)    ; -> [ 3 | 4 ]

(cons (cons 1 2) (cons 3 4))   ;  [  •  |  •  ]
                               ;     |     | 
			       ;   [1|2] [3|4]

(cons 1 (cons 2 (cons 3 null))) ; [ 1 | •-]--> [2 | •-]--> [3 | / ]
```

`null` is used to represent nothing.  Note: The book sometimes writes
`nil` or `'()` to mean the same thing.  In Racket, you can use `null` or `'()`.

Pairs are kind of like a "machine language" of data structures.
You can build every other data structure from pairs.  However, you're also
not supposed to worry about the exact details.  This is accomplished
through abstraction.

To illustrate, if you wanted to represent a fraction, you could
use `cons` to store the numerator and denominator.  For example:

```
; 3/4
(define a (cons 3 4))

; 2/3
(define b (cons 2 3))
```

You could also write operations that directly work with that representation

```
; a + b
(define (add-frac a b)
    (cons (+ (* (car a) (cdr b)) (* (cdr a) (car b)))
          (* (cdr a) (cdr b))))

```

The problem is that reading code like that makes your head explode.  It's
much better to abstract details to helper procedures:

```
(define (make-frac numer denom) ...)
(define (numer frac) ...)
(define (denom frac) ...)
```

Using these functions, you'd rewrite the above expression as follows:

```
; a + b
(define (add-frac a b)
           (make-frac (+ (* (numer a) (denom b)) (* (denom a) (numer b)))
                      (* (denom a) (denom b))))


(define a (make-frac 3 4))      
(define b (make-frac 2 3))
(add_frac a b)
```		      

It's subtle, but writing the code in this way hides internal details.
Nothing about `add-frac` says anything about the use of pairs or `cons`.
It's using higher-level functions such as `make-frac`, `numer`, and `denom`
to access to the data.

**Digression: How to better understand SICP.** SICP is very much
written in a "top-down" style that emphasizes a certain style of
"wishful thinking."  Problems are often solved by first wishing
certain features into existence.  Later discussion eventually gets
around to implementing those features.  If you aren't aware of this,
it can be quite frustrating to read.  For example, you might read the
text and suddenly see that the code is using some procedure that's
never been defined.  You're left scratching your head wondering "what
is THAT?!!"  More often than not, the definition of that missing
procedure will appear several pages later.

### Exercises

**[Reading, Section 2.1.1](http://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e1)**
Enter the code for rational numbers and try the examples.

**Exercise 2.1:** Define a better version of
`make-rat` that handles both positive and negative arguments.
`Make-rat` should normalize the sign so that if the rational number is
positive, both the numerator and denominator are positive, and if the rational
number is negative, only the numerator is negative.

**[Reading, Section 2.1.2](http://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e2)**

**Exercise 2.2:** Consider the problem of
representing line segments in a plane.  Each segment is represented as a pair
of points: a starting point and an ending point.  Define a constructor
`make-segment` and selectors `start-segment` and `end-segment`
that define the representation of segments in terms of points.  Furthermore, a
point can be represented as a pair of numbers: the `x` coordinate and the
`y` coordinate.  Accordingly, specify a constructor `make-point` and
selectors `x-point` and `y-point` that define this representation.
Finally, using your selectors and constructors, define a procedure
`midpoint-segment` that takes a line segment as argument and returns its
midpoint (the point whose coordinates are the average of the coordinates of the
endpoints).  To try your procedures, you'll need a way to print points:

```
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))
```

**[Reading, Section 2.1.3](http://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e3)**.  Pay careful
attention to the implementation of `cons` involving a dispatch function.

These next few exercises are some of the most mind-bending in all of SICP.  As coders, we're often
taught the concept of "data" in very concrete terms. For example, integers, lists, and objects being
constructed from very specific sequences of bytes, memory pointers, and other elements.
These exercises take the opposite idea and explore data in terms of abstraction.  Hang on for the ride.

**Exercise 2.4:** Here is an alternative procedural
representation of pairs.  For this representation, verify that `(car (cons x y))`
yields `x` for any objects `x` and `y`.

```
(define (cons x y) 
  (lambda (m) (m x y)))

(define (car z) 
  (z (lambda (p q) p)))
```

What is the corresponding definition of `cdr`? (Hint: To verify that this
works, make use of the substitution model of section 1.1.5)

**Exercise 2.5:** Show that we can represent pairs of
nonnegative integers using only numbers and arithmetic operations if we
represent the pair `a` and `b` as the integer that is the product `2^a * 3^b`.
Give the corresponding definitions of the procedures `cons`,
`car`, and `cdr`.

**Exercise 2.6:**
In case representing pairs as
procedures wasn't mind-boggling enough, consider that, in a language that can
manipulate procedures, we can get by without numbers (at least insofar as
nonnegative integers are concerned) by implementing 0 and the operation of
adding 1 as

```
(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))
```

This representation is known as "Church numerals," after its inventor,
Alonzo Church, the logician who invented the λ-calculus.

Define `one` and `two` directly (not in terms of `zero` and
`add-1`).  (Hint: Use substitution to evaluate `(add-1 zero)`).  Give
a direct definition of the addition procedure `+` (not in terms of
repeated application of `add-1`).

**Special Exercise:** As if the last few exercises weren't brain bending
enough, it turns out that all of boolean-logic can be encoded
solely as procedures.  Define this:

```
(define (TRUE x y) x)
(define (FALSE x y) y)
```

Now, show how you could use those two functions (and only those
functions) to define the common boolean-logic operators:

```
(define (NOT) ...)
(define (AND x y) ...)
(define (OR x y) ...)

; Example
(NOT TRUE)         ;-> FALSE
(NOT FALSE)        ;-> TRUE
(AND TRUE TRUE)    ;-> TRUE
(AND TRUE FALSE)   ;-> FALSE
```

**Challenge Exercise:** In Exercise 2.6, the Church numerals were defined.
If `x` and `y` are Church numerals, can you define subtraction?

```
; Returns a procedure representing x - y
(define (sub x y) ...)
```

## [2.2 Hierarchical Data and the Closure Property](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2)

This section introduces a graphical notation known as
"box-and-pointer" representation for describing data structures.  See
[Figure 2.2 and Figure 2.3](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2)
for examples.

A major idea concerns the construction of more complex data data structures and
lists in particular.

In Scheme, a list is constructed as linked cons cells. For example, to express a list
1,2,3. You might write this:

```
(cons 1 (cons 2 (cons 3 null)))
```

Because it's very common to write lists, you can use `list` instead to write:

```
(list 1 2 3)    ; Same as (cons 1 (cons 2 (cons 3 null)))
```

The value `null` represents an empty list.  If you want to test for an empty
list, use the predicate `(null? s)`.

Accessing different elements of a list can be accomplished using different
combinations of `car` and `cdr`.  For example:

```
(define s (list 1 2 3))

(car s)              ; -> 1
(cdr s)              ; -> (list 2 3)
(car (cdr s))        ; -> 2
(car (cdr (cdr s)))  ;-> 3
```

Because these combinations are common, there are shortcuts.

```
(car s)            ; -> 1
(cadr s)           ; -> 2
(caddr s)          ; -> 3
(cddr s)           ; -> (3)
```

To traverse over list elements, there is a common recursive
pattern that you will see over-and-over again:

```
(define (do-something s)
    (if (null? s)
        base-case
	(<op> (do-something (cdr s)))))
```

For example, computing the length of a list:

```
(define (length s)
    (if (null? s)
        0
	(+ 1 (length (cdr s)))))
```

Or mapping a procedure to the items

```
(define (list-map proc s)
    (if (null? s)
        null
	(cons (proc (car s))
	      (list-map proc (cdr s)))))

(define squares (list-map (lambda (x) (* x x)) s))
```

### Exercises

This set of exercises explores various operations on lists and algorithms involving lists.
Lists are an essential aspect of problems to come and Scheme programming in general. Therefore
much of the goal is to gain more experience and to practice.  Expect much discussion and some
tricky challenges.

**[Reading, Section 2.2.1](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e1)**:  Read through the section, make sure you understand box-pointer
diagrams, and how lists are put together.  Try some of the examples involving common
list operations.


**Exercise 2.17:** Define a procedure
`last-pair` that returns the list that contains only the last element of a
given (nonempty) list:

```
(last-pair (list 23 72 149 34))
(34)
```

**Exercise 2.18:** Define a procedure `reverse`
that takes a list as argument and returns a list of the same elements in
reverse order:

```
(reverse (list 1 4 9 16 25))
(25 16 9 4 1)
```

Bonus: Can you design an algorithm that requires only n steps for a list containing
n items?

**Exercise 2.20:** The procedures `+`,
`*`, and `list` take arbitrary numbers of arguments. One way to
define such procedures is to use `define` with "dotted-tail notation".  
In a procedure definition, a parameter list that has a dot before
the last parameter name indicates that, when the procedure is called, the
initial parameters (if any) will have as values the initial arguments, as
usual, but the final parameter's value will be a `list` of any
remaining arguments.  For instance, given the definition

```
(define (f x y . z) ⟨body⟩)
```

the procedure `f` can be called with two or more arguments.  If we
evaluate

```
(f 1 2 3 4 5 6)
```

then in the body of `f`, `x` will be 1, `y` will be 2, and
`z` will be the list `(3 4 5 6)`.  Given the definition

```
(define (g . w) ⟨body⟩)
```

the procedure `g` can be called with zero or more arguments.  If we
evaluate

```
(g 1 2 3 4 5 6)
```

then in the body of `g`, `w` will be the list `(1 2 3 4 5 6)`.

Note: Dotted-tail notation is similar to the `*args` syntax in Python.  For example:

```
def f(x, y, *z):
    ...
```

Use this notation to write a procedure `same-parity` that takes one or
more integers and returns a list of all the arguments that have the same
even-odd parity as the first argument.  For example,

```
(same-parity 1 2 3 4 5 6 7)
(1 3 5 7)

(same-parity 2 3 4 5 6 7)
(2 4 6)
```

**[Reading: Section 2.2.1](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e1)**: Continue reading section 2.2.1 with
attention to the part on "Mapping over lists".

**Exercise 2.21**: The procedure `square-list`
takes a list of numbers as argument and returns a list of the squares of those
numbers.

```
(square-list (list 1 2 3 4))
(1 4 9 16)
```

Here are two different definitions of `square-list`.  Complete both of
them by filling in the missing expressions:

```
(define (square-list items)
  (if (null? items)
      nil
      (cons ⟨??⟩ ⟨??⟩)))

(define (square-list items)
  (map ⟨??⟩ ⟨??⟩))
```

**Exercise 2.22**: Louis Reasoner tries to rewrite
the first `square-list` procedure of Exercise 2.21 so that it
evolves an iterative process:

```
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))
```

Unfortunately, defining `square-list` this way produces the answer list in
the reverse order of the one desired.  Why?

Louis then tries to fix his bug by interchanging the arguments to `cons`:

```
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square 
                     (car things))))))
  (iter items nil))
```

This doesn't work either.  Explain.

**Exercise 2.23:** The procedure `for-each` is
similar to `map`.  It takes as arguments a procedure and a list of
elements.  However, rather than forming a list of the results, `for-each`
just applies the procedure to each of the elements in turn, from left to right.
The values returned by applying the procedure to the elements are not used at
all---`for-each` is used with procedures that perform an action, such as
printing.  For example,

```
(for-each 
 (lambda (x) (newline) (display x))
 (list 57 321 88))

57
321
88
```

The value returned by the call to `for-each` (not illustrated above) can
be something arbitrary, such as true.  Give an implementation of
`for-each`.

### [2.2.2 Hierarchical Structures](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e2)

The exploration of data structures continues in this section with a look at trees and
other non-list data structures.   It's important to emphasize the extreme flexibility
your get with a simple "pair" data structure.  Since each half of the pair can hold anything
at all (including pointers to other pairs), you can make very complex structures.  For example,
a small tree as show in [Figure 2.5](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e2).

Continue with these exercises:

### Exercises

**[Reading, Section 2.2.2]**: Read and try examples.

**Exercise 2.25:** Give combinations of `car`s
and `cdr`s that will pick 7 from each of the following lists:

```
(1 3 (5 7) 9)
((7))
(1 (2 (3 (4 (5 (6 7))))))
```

**Exercise 2.26:** Suppose we define `x` and `y` to be two lists:

```
(define x (list 1 2 3))
(define y (list 4 5 6))
```

What result is printed by the interpreter in response to evaluating each of the
following expressions:

```
(append x y)
(cons x y)
(list x y)
```

**Exercise 2.27:** Modify your `reverse`
procedure of Exercise 2.18 to produce a `deep-reverse` procedure
that takes a list as argument and returns as its value the list with its
elements reversed and with all sublists deep-reversed as well.  For example,

```
(define x 
  (list (list 1 2) (list 3 4)))

x
((1 2) (3 4))

(reverse x)
((3 4) (1 2))

(deep-reverse x)
((4 3) (2 1))
```

**Exercise 2.28:** Write a procedure `fringe`
that takes as argument a tree (represented as a list) and returns a list whose
elements are all the leaves of the tree arranged in left-to-right order.  For
example,

```
(define x 
  (list (list 1 2) (list 3 4)))

(fringe x)
(1 2 3 4)

(fringe (list x x))
(1 2 3 4 1 2 3 4)
```

## [2.2.3 Sequences as Conventional Interfaces](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e3)

Lists/sequences are a fundamental data structure in most programming languages.  Moreover, there are very standard
sorts of operations that one performs on a sequence.  Typical examples include enumeration, filtering, mapping,
and reductions.   In many cases, useful calculations can be performed using nothing more than these
higher-level operations.

Section 2.2.3 continues with exercises involving lists.

###

**[Reading, Section 2.2.3](http://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e3)**  Read and try examples with particular attention given to the `accumulate` procedure:


```
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))
```

**Exercise 2.33:** Fill in the missing expressions
to complete the following definitions of some basic list-manipulation
operations as accumulations:

```
(define (map p sequence)
  (accumulate (lambda (x y) ⟨??⟩) 
              nil sequence))

(define (append seq1 seq2)
  (accumulate cons ⟨??⟩ ⟨??⟩))

(define (length sequence)
  (accumulate ⟨??⟩ 0 sequence))
```


**Exercise 2.38:**  The procedure `accumulate` is also known as `fold-right`, because it combines the first element of
the sequence with the result of combining all the elements to the right.  There
is also a `fold-left`, which is similar to `fold-right`, except that
it combines elements working in the opposite direction:

```
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))
```

What are the values of

```
(fold-right / 1 (list 1 2 3))
(fold-left  / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left  list nil (list 1 2 3))
```

Give a property that `op` should satisfy to guarantee that
`fold-right` and `fold-left` will produce the same values for any
sequence.

**Exercise 2.39:** Complete the following
definitions of `reverse` (Exercise 2.18) in terms of
`fold-right` and `fold-left` from Exercise 2.38.

```
(define (reverse sequence)
  (fold-right 
   (lambda (x y) ⟨??⟩) nil sequence))

(define (reverse sequence)
  (fold-left 
   (lambda (x y) ⟨??⟩) nil sequence))
```

## [2.3 Symbolic Data](http://sarabander.github.io/sicp/html/2_002e3.xhtml#g_t2_002e3)

Up to this point, the only primitive kind of data you've worked with are numbers.  This
section introduces the concept of symbols and quoting.

The special form `(quote expr)` leaves the given expression **unevaluated**.  It's a little
strange, but here are some examples:

```
(quote 42)           ; -> 42
(quote a)            ; -> a        (A symbol)
(quote (a b c))      ; -> (list (quote a) (quote b) (quote c))
```

Sometimes quoting is written with a single leading quote:

```
'42
'a
'(a b c)
```

Important feature:  Quoting is NOT the same as a text-string.  Instead, it
leaves the expression that follows unevaluated. This is quite subtle, but
here is another example:

```
(define a 3)
(define b 4)

(define c (+ a b))       ; c = 7   (Immediately evaluated)
(define d '(+ a b))      ; d = (list '+ 'a 'b)

; Try these examples
(car d)     ; -> '+
(cadr d)    ; -> 'a
(caddr d)   ; -> 'b
```

All scheme expressions are lists.  Quoting gets you an unevaluated list where
the symbols are left intact as symbols.  This might be the most powerful
feature of quoting.  Quoting allows arbitrary scheme code to be captured.
Since the code itself is a list, you can manipulate it using standard list
operations.  Most languages don't allow you to manipulate code as data in
any kind of easy way--instead, you've have to write some kind of parser and
work with a complicated parse tree structure.

### Exercises

**[Reading, Section 2.3.1](http://sarabander.github.io/sicp/html/2_002e3.xhtml#g_t2_002e3_002e1)**.   Read about the basics of symbols.

**Exercise 2.53:** What would the interpreter print
in response to evaluating each of the following expressions?

```
(list 'a 'b 'c)
(list (list 'george))
(cdr '((x1 x2) (y1 y2)))
(cadr '((x1 x2) (y1 y2)))
(pair? (car '(a short list)))
(memq 'red '((red shoes) (blue socks)))
(memq 'red '(red shoes blue socks))
```

**Exercise 2.54:** Two lists are said to be
`equal?` if they contain equal elements arranged in the same order.  For
example,

```
(equal? '(this is a list) 
        '(this is a list))
```

is true, but

```
(equal? '(this is a list) 
        '(this (is a) list))
```

is false.  To be more precise, we can define `equal?`  recursively in
terms of the basic `eq?` equality of symbols by saying that `a` and
`b` are `equal?` if they are both symbols and the symbols are
`eq?`, or if they are both lists such that `(car a)` is `equal?`
to `(car b)` and `(cdr a)` is `equal?` to `(cdr b)`.  Using
this idea, implement `equal?` as a procedure. (Note: This implementation
is only concerned with lists of symbols).

Note: In practice,
programmers use `equal?` to compare lists that contain numbers as well as
symbols.  Numbers are not considered to be symbols.  The question of whether
two numerically equal numbers (as tested by `=`) are also `eq?` is
highly implementation-dependent.  A better definition of `equal?` (such as
the one that comes as a primitive in Scheme) would also stipulate that if
`a` and `b` are both numbers, then `a` and `b` are
`equal?` if they are numerically equal.  Can you modify `(equal?)` to also
work with numbers?

**Exercise 2.55:** Eva Lu Ator types to the
interpreter the expression

```
(car ''abracadabra)
```
To her surprise, the interpreter prints back `quote`.  Explain.

**Special Exercise (Records):** In many programming languages, it is common
to represent records as key-value pairs (sometimes known as a mapping).
For example, you might write:

```
(define record '((x 1) (y 2) (z 3)))
```

Write a procedure `(assoc key record)` that finds the entry with
a given key:

```
(assoc 'y record)      ; -> (y 2)
```

Write a procedure `(add-entry key value record)` that adds or replaces an entry (returning a new
record as a result).

```
(add-entry 'w 4 record)  ; -> ((x 1) (y 2) (z 3) (w 4))
(add-entry 'x 10 record) ; -> ((x 10) (y 2) (z 3))
```

Write a procedure `(del-entry key record)` that deletes an entry (returning a new record).

```
(del-entry `x record)   ; -> ((y 2) (z 3))
```

**Special Exercise (Patterns):** Sometimes it's useful to match patterns in data.
For example, consider this record:

```
(define record '(job (Hacker Alyssa P) (computer programmer)))
```

Write a procedure (match pattern data) that matches structure:

```
(match '(job ? ?) record)           ; --> true
(match '(job ? (? coder)) record)   ; --> false
(match '(? ? (computer ?)) record)  ; --> true
```

**Special Challenge Exercise (Binding):** Instead of matching, a more advanced
operation is binding.   Here is an example:

```
(bind '(job ?name ?job) record)
;  --> '((name (Hacker Alyssa P)) (job (computer programmer)))

(bind '(?type ?name (?what programmer)) record)
; -->  '((type job) (name (Hacker Alyssa P)) (what computer))

(bind '(job ?what) record)
; --> false (doesn't match)
```

Hints:  You can use `(symbol->string sym)` to convert a symbol to a string.
`(string->symbol s)` converts a string to a symbol.  `(substring s first last)` creates
a substring.


## [2.3.2 Example: Symbolic Differentiation](http://sarabander.github.io/sicp/html/2_002e3.xhtml#g_t2_002e3_002e2)

This section involves an example of code that manipulates symbolic math expressions.  Although it's
based on calculus, it's not really about calculus (nor do you really need to know calculus).  However,
it's an interesting precursor to writing an interpreter that comes later. In fact, many of the techniques
are similar.


### Exercises

**[Reading: Section 2.3.2](http://sarabander.github.io/sicp/html/2_002e3.xhtml#g_t2_002e3_002e2)**.  Read through the example, enter the code, and try it out.  Make sure
you understand how it works.

**Exercise 2.56:**  Try to expand the `deriv` procedure to support exponents.  Please read the
exercise description in the online text (not repeated here due to mathematical typesetting).

## [2.4 Multiple Representations for Abstract Data](http://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002e4)

If there's any mantra for programming, it might be "there's more than
one way to do it."  This section explores that idea in the context of
data.  In doing so, it describes the conceptual foundation for type
systems, objects, and other related matters.

Editorial note: this is a rather "maddening" section of SICP.  First, the
motivating example is complex numbers--which, in all honesty, is not
all that motivating.  Second, the discussion relies upon "features"
of Scheme that aren't even available as described and are not discussed further until
Chapter 3.  Because of this, it very hard to try most of the examples.

Because of this, I'm going to present the same core concepts, but with
a different, simplified, motivating example.  Also, we're going to
cheat a bit and use selected features of Racket to make it possible to
try things and experiment with concepts.

### Problem: The Box

Suppose that were going to make a data structure for representing a "box" as in
a geometrical box in the xy-plane (maybe it's part of a graphics program):

```
| y
|       +---------+
|       |         |
|       |         |
|       |         |
|       +---------+
|
|______________________________ x
```

Question: How do you represent it?

Bob's Approach: You use a corner coordinate and some lengths:

```
| y     <- width ->
|       +---------+   ^
|       |         |   |
|       |         | height
|       |         |   |
|       +---------+   v
|     (x,y)
|______________________________ x

(define (make-box x y w h)
  (cons (cons x y) (cons w h)))

(define (width box)
   (car (cdr box))

(define (height box)
   (cdr (cdr box))

(define (area box)
    (* (width box) (height box))
```

Alice's Approach:  Use the coordinates of opposite corners:


```
| y                (x2, y2)
|       +---------+   
|       |         |
|       |         |
|       |         |
|       +---------+
|    (x1,y1)
|______________________________ x


(define (make-box x1 y1 x2 y2)
 (cons (cons x1 y1) (cons x2 y2)))

(define (width box)
   (abs (- (car (cdr box))
           (car (car box)))))

(define (height box)
   (abs (- (cdr (cdr box))
           (cdr (car box)))))

(define (area box)
    (* (width box) (height box))
```

Neither approach is superior--they both describe the same box.

### Problem: Naming

As often happens in software, suppose that both representations of a box
must coexist in the same program.  Immediately, this coexistence
is going to present practical problems.

The first problem concerns naming.  Bob's box and Alice's box both involve
procedures with identical names.  If that code must exist in the same
program, the names must be made to be unique.  So, perhaps you
rename everything as shown here:

```
; Bob's box
(define (bob-make-box x y w h)
  (cons (cons x y) (cons w h)))

(define (bob-width box)
   (car (cdr box))

(define (bob-height box)
   (cdr (cdr box))

(define (bob-area box)
    (* (width box) (height box))

; Alice's box
(define (alice-make-box x1 y1 x2 y2)
 (cons (cons x1 y1) (cons x2 y2)))

(define (alice-width box)
   (abs (- (car (cdr box))
           (car (car box)))))

(define (alice-height box)
   (abs (- (cdr (cdr box))
           (cdr (car box)))))

(define (alice-area box)
    (* (width box) (height box))

```

**Exercise 2.A:** Enter the above code for Bob's and Alice's box.  Verify that it
works and look at the resulting data structures:

```
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))
(alice-area a)
4
(bob-area b)
12

; Look at the resulting data structures
a        -> '((1 . 2) 3 . 4)
b        -> '((1 . 2) 3 . 4)
```

### Problem: Type Identification (see [2.4.2 Tagged Data](http://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002e4_002e2))

In the exercise, `a` and `b` have exactly the same structure.
Thus, if you're looking at a value in isolation, how do you know
what it is?  Is it even a box?

Moreover, if you look at the code, there are all of these little
procedures:

```
(define (bob-width box) ...)
(define (alice-width box) ...)
```

You might ask if it's possible to just make a more generic procedure
`(width b)` that just works with any kind of box.

```
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

(width a)      ; -> 2   
(width b)      ; -> 3
```

Try as you might, you won't be able to do this unless you can identity the kind of
box you're working with--and you can't do that because the current representation of each
box is identical.

The solution to this problem is to introduce "types."  If you want to identify something,
you can attach a type-tag to it.  Introduce these procedures:

```
(define (attach-tag tag contents) (cons tag contents))
(define (type-tag datum) (car datum))
(define (contents datum) (cdr datum))
```

The idea is that you can tag any value you want with a type.   For example:

```
(define a (attach-tag 'int 23))    ; -> (int 23)
(type-tag a)                       ; -> 'int
(contents a)                       ; -> 23
```

You can modify the box code with type tags:

```
(define (bob-make-box x y w h)
    (attach-tag 'bob-box
         (cons (cons x y) (cons w h))))

; type-check procedure
(define (bob-box? b) (eq? (type-tag b) 'bob-box))

; Other methods (note: must extract the contents from the tagged value)
(define (bob-width b) (car (cdr (contents b))))
(define (bob-height b) (cdr (cdr (contents b))))
```

**Exercise 2.B:** Modify the "bob" and "alice" code to use tags.   Verify
that all of the old code still works.

```
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))

(alice-area a)
4
(bob-area b)
12
```

Look at the resulting data structures

```
a   ; -> '(bob-box (1 . 2) 3 . 4)
b   ; -> '(alice-box (1 . 2) 3 . 4)
```

### Generic Procedures

Type-tags can be used to write dispatching code based on types

```
; Generic procedure
(define (width b)
    (cond ((bob-box? b) (bob-width b))
          ((alice-box? b) (alice-width b)))
    )
)

; Example
(define a (alice-make-box 1 2 3 4))
(define b (bob-make-box 1 2 3 4))
(width a)
3
(width b)
2
```

**Exercise 2.C:** Write generic procedures for `width`, `height`, and
`area`.  Verify correct behavior.

### Data Directed Dispatch (see [2.4.3 Data-Directed Programming and Addivity](http://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002e4_002e3))

One problem with the generic procedures in the last section is that
the procedures are hard-coded to look for very specific tags.
If new objects are added, they won't be recognized unless the dispatch
code is also changed.   This makes the code brittle.   In the words
of SICP, it's not "additive" (meaning that you can't easily add new types).

To fix this problem, an alternative solution is to dispatch procedures
through some kind of table.  Conceptually, you could use something
similar to a Python dictionary:

```
# Pseudo-code. Not Scheme.
registry = {
    '(width bob-box)    -> bob_width
    '(width alice-box)  -> alice-width
    ...
}

(define (width box)
    (registry['width (type-tag box)] box))
```

Issue:  SICP has not talked about tables or any similar feature so far.
We can make use of a hash table in Racket although doing so feels
like cheating (although in the book, similar table manipulation procedures are introduced
out of thin-air with not much explanation). Here's a basic
tutorial:

```
(make-hash)              ; Create a mutable hash table
(hash-set! h key val)    ; Add an entry
(hash-ref h key)         ; Look up a value

; Example
(define h (make-hash))
(hash-set! h 'foo 42)
(hash-set! h 'bar 37)
(hash-ref h 'foo)        ; -> 42
(hash-ref h 'bar)        ; -> 37
```

Using a hash, you can make a registry and define generic procedures
so that they look up procedures in the registry:

```
(define registry (make-hash))

(define (register name tag proc)
   (hash-set! registry (list name tag) proc))

(define (lookup name object)
   (hash-ref registry (list name tag)))
```

Here's how a generic version of `width` would be defined:

```
; Register procedures (in advance)
(register 'width 'bob-box bob-width)
(register 'width 'alice-box alice-width)

; Generic procedure
(define (width box)
    ((lookup 'width (type-tag box)) box))
```

**Exercise 2.D:** A registry to your code.  Register various width/height procedures with
the registry.  Write generic width/height/area procedures.

### Problem: Namespaces

The use of a registry solves the problem of being able to add new types.
However, the code is now turns into a mess of procedure names.  For example:

```
width
height
bob-width
bob-height
alice-width
alice-height
```

All of these names live in a unified namespace.   As programs get large, managing
names becomes problematic. Other languages, such as Python, solve this through
the use of modules, packages, and similar constructs.  You can implement similar
functionality by defining inner procedures:

```
(define (import-bob-box)
   (define (width box)
       (car (cdr (contents box))))
   (define (height box)
       (cdr (cdr (contents box))))
   (register 'width 'bob-box width)
   (register 'height 'bob-box height)
)

; Explicit import (in code that wants to use it)
(import-bob-box)
```

**Exercise 2.E:** Put the generic "bob" and "alice" functions into their own
namespace as shown.   Point to ponder:  Can the procedures for creating a
bob-box and alice-box also be put into a namespace?

### Message Passing

One complaint with the code so far is that it feels very complicated.
There are various data constructors, type-tagging, import functions, a
procedure registry, etc.

A different approach is to create an outer function that receives
and responds to so-called "messages."   For example:

```
(define (make-bob-box x y width height)
  (define (dispatch message)
    (cond ((eq? message 'width) width)
          ((eq? message 'height) height)
          ((eq? message 'type) 'bob-box)
          )
    )
  dispatch
)

; Example usage:
(define a (make-bob-box 1 2 3 4))
(a 'width)     ; -> 3
(a 'height)    ; -> 4
(a 'type)      ; -> 'bob-box
```

You already did something like this in Exercise 2.4.  With this approach,
you now define generic procedures that issue the messages like this:

```
(define (width box)
    (box 'width))

(define (height box)
    (box 'height))
```

Aside:  This concept is the same as how Python works.  Consider a generic operation
such as `len(s)`.   You may know that it works on many different types:

```
>>> len("hello")
5
>>> len([1,2,3])
3
>>> len({'a':10, 'b':20})
2
>>>
```

How does `len()` work?  It issues a `__len__()` method on the supplied value.

```
>>> a = "hello"
>>> a.__len__()
5
>>>
```

Our dispatching idea is exactly the same concept.  The generic `width` procedure
issues a `'width` message and it either works or it doesn't.

Commentary: Objected-Oriented programming is largely based on "message passing." The
terminology is a bit unusual, but it's the foundation of the the dot (.) operation
in languages with objects:

```
obj.attr          # Sends "attr" message to "obj"
```

The purpose of a class is to provide a namespace for procedures.  Internal dispatching
is often table-driven.  For example, Python builds all of its objects on top of dicts.

**Exercise 2.F:** Reimplement the "alice" and "bob" code as message passing.

## [2.5 Systems with Generic Operations](http://sarabander.github.io/sicp/html/2_002e5.xhtml#g_t2_002e5)

The final part of chapter 2 discusses thorny issues that arise in
systems involving generic procedures.  The motivating example is based
on handling mixed-type arithmetic operations--again with complex
numbers.   We're going to discuss the basic problem, but in more simplified terms.

### Mixed-Type Arithmetic (see [2.5.1 Generic Arithmetic Operations](http://sarabander.github.io/sicp/html/2_002e5.xhtml#g_t2_002e5_002e1))

Mixed-type arithmetic is actually a REALLY complicated problem.
For the purposes of discussing that, let's switch to Python
for a moment. The same issues discussed in SICP apply.  However,
we can give it a more compact treatment that is more familiar.

In Python, there different kinds of numeric objects.  For example:

```
>>> a = 1       # int
>>> b = 2.5     # float
>>> c = 3 + 4j  # complex
>>> from fractions import Fraction
>>> d = Fraction(1, 4)
>>>
```

Moreover, the math operators are generic:

```
>>> 1 + 2
3
>>> 1.5 + 1.7
3.2
>>> Fraction(1, 4) + Fraction(2, 3)
Fraction(11, 12)
>>>
```

However, the math operators additionally work when you mix the operand types:

```
>>> 1 + 2.5
3.5
>>> Fraction(1,4) + 5
Fraction(21, 4)
>>> (3 + 4j) + 10
13 + 4j
>>>
```

How does this mixed-type arithmetic work exactly?   How would you
make it work if you had to implement it from scratch?

### Supporting Mixed-Type Operations (see [2.5.2 Combining Data of Different Types](http://sarabander.github.io/sicp/html/2_002e5.xhtml#g_t2_002e5_002e2))

In Python, each numeric type is its own independent entity. Internally, the types minimally know how to perform
arithmetic on themselves.   Thus, somewhere, there are functions such as this (don't worry about their implementation):

```
def add_int(a:int, b:int) -> int:
    ...

def add_float(a:float, b:float) -> float:
    ...

def add_complex(a:complex, b:complex) -> complex:
    ...
```

Thus, how to perform mixed-type arithmetic?  One approach would be to write a dedicated function
for all possible combinations of types:

```
def add_int_int(a:int, b:int) -> int:
    ...

def add_int_float(a:int, b:float) -> float:
    ...

def add_int_complex(a:int, b:complex) -> complex:
    ...

def add_float_int(a:float, b:int) -> float:
    ...

def add_float_float(a:float, b:float) -> float:
    ...

def add_float_complex(a:float, b:complex) -> complex:
    ...

def add_complex_int(a:complex, b:int) -> complex:
    ...

def add_complex_float(a:complex, b:float) -> complex:
    ...

def add_complex_complex(a:complex, b:complex) -> complex:
    ...

```

You can already see the problem with doing this--there would be an explosion of functions that
gets worse and worse as more types are added.  Python does NOT do this (nor do any
other programming languages).

Another approach would be to implement "type coercion" through special conversion functions:

```
def int_to_float(x: int) -> float:
    ...

def int_to_complex(x: int) -> complex:
    ...

def float_to_complex(x: float) -> complex:
    ...
```

The type-coercion could then be incorporated into to the implementation of the
math operators:

```
def add_int(x:int, y):
    if isinstance(y, int):
        return x + y
    elif isinstance(y, float):
        return add_float(int_to_float(x), y)
    elif isinstance(y, complex):
        return add_complex(int_to_complex(x), y)
    else:
        raise TypeError("Can't add")
```

Yes, it works, but it starts to get messy.  It also raises questions about the
responsibility of the conversion.

In Python, this is handled via special methods and a known chain of responsibility
with respect to conversions.  The following example illustrates:

```
>>> a = 2
>>> b = 2.5
>>> a.__add__(3)     # int + int 
5
>>> a.__add__(b)     # int + float
NotImplemented
>>> b.__radd__(a)    # int + float  (reversed operands)
4.5
>>> b.__add__(a)     # float + int
4.5
>>>
```

In this example, it is the responsibility of `float` to know how to handle
`int` conversion--not the other way around.  It's subtle, but if presented
with a `float`, the integer add operation fails.  Python then flips the
operation to a different method (`__radd__`) on the `float` value instead.

### Type hierarchies

Although approach would be to organize types into a natural hierarchy.
For example, an `int` can naturally convert to `float` and a `float` can naturally convert into
a `complex`.  So, maybe they form a kind of "tower."

```
complex
  ^
  |
float
  ^
  |
 int
```


Hierarchies suggest concepts such as subtyping and inheritance and indeed,
that's what's happening here.

Within such a hierarchy, one can implement the concept of "type
lifting" or "raising." Essentially, raising is the process of
converting a lower-type to a higher-type.

To implement mixed-type arithmetic, one could write procedures that lifted
incompatible arguments.  For example:

```
# Example of lifting (pseudocode)
def add_float(a:float, b) -> float:
    while type(b) != float:
        b = lift b           # Lift b in the hierarchy
    return a + b
```

Many subtle details have been ommitted, but if types are arranged into
a hierarchy, subtypes can be lifted to make mixed operations work.
Python doesn't really work in this way.  In fact, the numeric types are
NOT organized into a type hierarchy.  You can verify this yourself:

```
>>> isinstance(2, float)
False
>>> isinstance(2.5, float)
True
>>>
```

SICP concludes with a bit of discussion concerning type hierarchies, but doesn't dive into
much depth other than to say that it's "very difficult" and possibly intractable. See, for
instance, the discussion above Figure 2.26 and [footnote 118](http://sarabander.github.io/sicp/html/2_002e5.xhtml#FOOT118]). 

We will not discuss type hierarchies any further.  However, further
exercises will have you apply some of the techniques for making
objects that we covered.

Historical note: SICP was originally written in the late 80's and
90's. During this time period, there was a lot of work and confusion
related to implementation of type-hierarchies and inheritance,
especially for C++.  Even for Python itself, it took nearly 10 years
for Python developers to figure out how multiple inheritance should
work-- features as part of a reworking of the object system that
appeared in Python 2.3.  The current "state of the art" in this area
might be the development of the [C3 linearization algorithm](https://en.wikipedia.org/wiki/C3_linearization).
This is the algorithm for inheritance currently used by Python and several other
programming languages.







	      



































