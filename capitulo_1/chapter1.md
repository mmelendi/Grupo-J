# Chapter 1 : Computation and Procedures

The overall theme of this chapter is to introduce some ideas
concerning the nature of computation and the elements of programming.

Some basic features of Scheme programming are introduced, but it's not
meant to be a "Scheme Tutorial" in the traditional sense of a programming
language tutorial.   Instead, view this chapter as a tutorial on
"computation."

Also, my notes here are only meant to provide a VERY compressed high-level
summary of various SICP material. You'll need to read each section for more
detail and nuance.  Links to reading will be given.

## 0. Introduction

Programming languages are built upon a minimal foundation of
primitives.  For example, there are numbers:

```
42
3.7
```

There are math operators that are used to form expressions:

```
42 + 13
3.7 * 6.1
```

Finally, you can name things:

```
radius = 5
pi = 3.14159
area = pi * radius * radius
```

### Evaluation Rules

There are rules that dictate the order in which operators
evaluate.  For example, consider:

```
(2 + 4 * 6) * (3 + 5 + 7)
```

In 4th grade math class, you probably learned about "order of
operations" and "showing your work."  Here's how you might evaluate
the above--shown in single steps:

```
(2 + 4 * 6) * (3 + 5 + 7)

(2 + 24) * (3 + 5 + 7)

26 * (3 + 5 + 7)

26 * (8 + 7)

26 * 15

390
```

The idea of doing things in single steps is important because
that's how computers work.

### Functions

Programming languages have functions.   For example, in math class,
you might describe a function like this:

```
f(x) = 3*x*x + 2*x + 1
```

Functions are "applied" to values.  For example:

```
f(2) -> 17
f(10) -> 321
```

* Question:  How does a function evaluate?

* Question:  How do you explain it to a 4th grader?

### Substitution

Functions evaluate by symbolic substitution. That is, you literally
replace the "x" symbol with the value in parentheses.

```
f(x) = 3*x*x + 2*x + 1

f(2) = 3*2*2 + 2*2 + 1
     = 6*2 + 2*2 + 1
     = 12 + 2*2 + 1
     = 12 + 4 + 1
     = 16 + 1
     = 17
```

But here's a subtle question--how do you evaluate this?

```
f(1+1) = ????
```

One approach.  You evaluate the `1+1` first, then you apply the function.  This
is known as "applicative order" and is the approach taken by most programming languages:

```
f(1+1) = f(2) = 3*2*2 + 2*2 + 1
              = 6*2 + 2*2 + 1
	      = 12 + 2*2 + 1
	      = 12 + 4 + 1
	      = 16 + 1
              = 17
```

However, you could also literally put the `1+1` in for the `x` like this:

```
f(1+1) = 3*(1+1)*(1+1) + (1+1)*(1+1) + 1
       = 3*2*(1+1) + (1+1)*(1+1) + 1
       = 3*2*2 + (1+1)*(1+1) + 1
       = 6*2 + (1+1)*(1+1) + 1
       = 12 + (1+1)*(1+1) + 1
       = 12 + 2*(1+1) + 1
       = 12 + 2*2 + 1
       = 12 + 4 + 1
       = 16 + 1
       = 17
```

This involves more busy work later, but you end up with the same answer.
This is known as "normal order" or sometimes "lazy evaluation."

Observe: There is more than one way to do it. Is it always the case that
you'll arrive at the same answer?

### Deep Idea (and the big SICP picture)

All of computation can be described by the evaluation of expressions
and the application of functions.

The devil is in the details--mostly concerning the "when" of 
these various evaluation steps.

This idea is a major theme running throughout SICP.  Major parts of
the book are devoted to setting up competing approaches to computation.
Consequences and tradeoffs of these decisions are then explored.
Often, the differences are subtle, but insightful.

With that, let's begin.  The section numbers, titles, and exercise numbers
used here match SICP.  Links are provided to corresponding book sections.

## [1.1 Elements of Programming](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1)

All programs in SICP are written in Scheme.  This first section introduces
some of the core ideas.

First, there are "primitives."  These are the most basic elements.

```
42
3.7
```

Next, there are combinations. These are used to build expressions.

```
(+ 42 37)          ; -> 79
(- 1000 334)       ; -> 666
(* 5 99)           ; -> 495
(+ 2 3 4 5)        ; -> 14
```

Finally, there are names:

```
(define size 2)
```

To access names, use the name:

```
size                ; -> 2
(+ size 10)         ; -> 12
```

The process of naming something is also known as "abstraction."

### [1.1.1 Expressions](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e1)

An expression represents a value.  It could be a primitive

```
390
```

It could also be a combination of operators:

```
(* (+ 2 (* 4 6)) (+ 3 5 7))
```

The use of prefix notation (where the operator appears first) takes
some getting used to.  However, it explicitly describes the precedence
and order of operations.  Contrast to a more typical programming language
where such rules are implicit.


```
2 + 4 * 6       # vs. (+ 2 (* 4 6))
2 * 4 + 6       # vs. (+ (* 2 4) 6)
```

Yes, you will have to get used to the funny syntax and
the parentheses.

### [1.1.2 Naming and the Environment](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e2)

You use `define` to introduce a name that you can later reference

```
(define size 2)
```

Scheme allows a richer set of symbols in names. For example, you can include
dashes, question marks, and even throw in a few symbols.

```
(define really? 42)
(define <-> 13)
(+ <-> really?)       ; -> 55
```

Most things can be named, including basic operators

```
(define op +)
(op 2 2)              ; -> 4
```

### [1.1.3 Evaluating Combinations](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e3)

Scheme evaluates expressions from the inside-out.   That is,
subexpressions are evaluated first.   For example:

```
(* (+ 2 (* 4 6)) (+ 3 5 7))

(* (+ 2 24) (+ 3 5 7))

(* 26 (+ 3 5 7))

(* 26 15)

390
```

The process is naturally recursive.  See [Figure 1.1](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e3) for instance.

### [1.1.4 Compound Procedures](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e4)

Define a procedure as follows:

```
(define (square x) (* x x))
```

Alternative syntax, involving `lambda`

```
(define square (lambda (x) (* x x)))
```

Note: The `lambda` syntax is similar to Python lambda:

```
# python
square = lambda x: x*x
```

### [1.1.5 Substitution Model for Procedure Application](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e5)

Procedures evaluate according to the substitution model. You
substitute names with values:

```
; Defining a procedure
(define (square x) (* x x))

; Applying a procedure
(square 10)     ; -> (* 10 10) -> 100
```

Digression: The idea of "substitution" is best thought of as an
introductory mental model for how a procedure works.  The first two
chapters of SICP can be described entirely via substitution.  However,
it all breaks down in Chapter 3 (and the actual Scheme interpreter doesn't
quite work like this).  However, we'll get to that later.

Scheme use applicative order, which means it evaluates arguments
first.  This is how most programming languages work.

```
(square (+ 2 3)) ; ->  (square 5) -> (* 5 5) -> 25
```

However, there is an alternative approach known as "normal order."
Normal order is what you get if you delay the evaluation of the `(+ 2 3)`
to later (when you need it):

```
(square (+ 2 3)) ; -> (* (+ 2 3) (+ 2 3)) -> (* 5 5) -> 25
```

Deep thought: Does it actually matter what order you do it?  You
seem to get the same answer either way.

Note: SICP spends a lot of time thinking about the order in which
operations occur.  Part of the motivation for doing so is to
understand subtle facets of how a programming language
works--something that's required if you're going to implement your own
language.

### Digression: Special Forms

Scheme has extremely minimal syntax.  There are only two syntactic forms
for everything:

```
42       ; A primitive
(x y z)  ; A list (procedure application)
```

There is no other syntax except this.  Questions:

```
(+ 2 3)       ; Is "+" a procedure?
(square 10)   ; Is "square" a procedure?
(define x 42) ; Is "define" a procedure?
```

Something is different about the `(define x 42)` form.
Try the following experiment in a fresh interpreter:

```
(+ x 42)         ; See what happens

(define x 42)    ; See what happens
```

Something is clearly different about the `define`.  You don't get
an error.  Why?

Not everything in Scheme is a procedure.  `define` is one such
example.  It does NOT evaluate the first argument (the name).
Instead, it leaves the name alone and uses it to store a value
somewhere.

Special forms are constructs that don't follow the usual rules of
evaluation.   Every programming language has them--even Python.
Consider this little Python experiment:

```
>>> 2 + 1/0
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ZeroDivisionError: division by zero
>>> 2 or 1/0
2
>>>
```

Something is "different" about the `or` operator.  It clearly did NOT evaluate
the `1/0` on the right hand side (if it did, an error would have
happened).   The fact that `or` behaves differently makes it special--it's
not following the usual rules of evaluation.

### [1.1.6 Conditional Expressions and Predicates](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e6)

The following special form is used for a conditional:

```
; (if predicate consequent alternative)

; Example:
(define (abs x) 
    (if (< x 0) (- x) x))
```

If you have more than one case, use `cond`:

```
; (cond (pred1 expr1)
;       (pred2 expr2)
;       ...
;      (predn exprn))

; Example
(define (abs x)
    (cond ((< x 0) (- x))
          ((= x 0) 0)
          ((> x 0) x)))
```

Both `if` and `cond` are special forms.  Question: Why?

Answer: Only one of the branches evaluates.

Example:

```
(define x 0)

(if (= x 0) (+ 1 x) (/ 1 x))
;   ^^^^^^^ ^^^^^^^
;  only these evaluate.
```

In addition, Scheme has `and`, `or`, and `not` operations.

```
(and e1 e2 e3 ... en)
(or e1 e2 e3 ... en)
(not e1)
```

Both `and` and `or` are special forms that implement short-circuit
behavior.  `and` evaluates `e1`, `e2`, etc, left-to-right, but stops as
soon as any expression evaluates to false. The final value is the result
of the last expression.  `or` works the same way, but stops as soon as any
expression evaluates to true. The final value is the first non-false value.

Note: In Scheme, special forms map to "keywords" in other
languages.  For example, `if`, `while`, etc.   Basically,
these names are special cases. Not variables, not procedures.

*A Caution*: SICP has many exercises that involve "strange" or
"tricky" problems related to evaluation and special forms.
A lot of this thinking is setup for later work in which you
make your own programming language.  To make a programming language,
you need to think about how things work--what evaluates and when.

### Exercises

Briefly read [section 1.1 - 1.1.6](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1) and then work these exercises.

**Exercise 1.1:** Below is a sequence of expressions.
What is the result printed by the interpreter in response to each expression?
Assume that the sequence is to be evaluated in the order in which it is
presented.

```
10

(+ 5 3 4)

(- 9 1)

(/ 6 2)

(+ (* 2 4) (- 4 6))

(define a 3)

(define b (+ a 1))

(+ a b (* a b))

(= a b)

(if (and (> b a) (< b (* a b)))
    b
    a)
    
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
      
(+ 2 (if (> b a) b a))

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
```   

**Exercise 1.2:** Translate the following expression into prefix form:

```
5 + 4 + (2 - (3 - (6 + 4/5)))
-----------------------------
       3(6 - 2)(2 - 7)
```

**Exercise 1.3:** Define a procedure that takes three numbers as
arguments and returns the sum of the squares of the two larger
numbers.

**Exercise 1.4:** Observe that our model of evaluation allows for
combinations whose operators are compound expressions.  Use this
observation to describe the behavior of the following procedure:

```
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
```

**Exercise 1.5:** Ben Bitdiddle has invented a test to determine whether
the interpreter he is faced with is using applicative-order evaluation
or normal-order evaluation.  He defines the following two procedures:

```
(define (p) (p))

(define (test x y) 
  (if (= x 0) 
      0 
      y))
```

Then he evaluates the expression

```
(test 0 (p))
```

What behavior will Ben observe with an interpreter that uses applicative-order
evaluation?  What behavior will he observe with an interpreter that uses
normal-order evaluation?  Explain your answer.  (Assume that the evaluation
rule for the special form `if` is the same whether the interpreter is
using normal or applicative order: The predicate expression is evaluated first,
and the result determines whether to evaluate the consequent or the alternative
expression.)


## [1.1.7 Example: Square Roots by Newton's Method](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e7)

This section presents a method for computing square roots.
The overall algorithm for computing `sqrt(x)` is this:

* Step 1:  Make a guess:  y=1
* Step 2:  Make a new guess.  y = average(y, x/y)
* Step 3:  Repeat step 2 until the guesses "converge"

Example: Compute `sqrt(2)`

```
y = 1
y = average(1, 2/1) = 1.5
y = average(1.5, 2/1.5) = 1.4167
y = average(1.4167 + 2/1.4167) = 1.4142
y = average(1.4142 + 2/1.4142) = 1.4142
```

Why THIS example?  A fundamental theme throughout SICP is the nature
of computation and the idea of a computational process.  From math class,
you were taught the concept of a square-root, but probably never asked to actually compute
one by hand (you used a calculator).  This example
illustrates the idea of computation as a step-by-step procedure.

Also, there is a subtle distinction between a mathematical
relationship such as `y = sqrt(x)` and a computational process.  This
is one reason why SICP uses the word "procedure"--it indicates a
process for doing something.  A "function" is more of a mathematical
relationship which is more abstract concept.

I think there may be a deeper motive for choosing this example.  If
you think about procedure application, it is described as a
"substitution process."  That is, to evaluate a procedure, you merely
substitute the "x", evaluate, and you're done.

```
(define (square x) (* x x))

(square 10)  ;->  (* 10 10) -> 100
```

However, computing `sqrt(x)` feels very different.  There is no simple
"formula" (or so-called "closed-form solution") for a square
root. Instead, the only way to get an answer is through a series of
approximations that get closer to the actual answer. So, in that
sense, it's a different kind of concept.  You have computation via
simple substitution and now you have computation via successive approximation.

Preview: This example on square roots is setting up a sub-plot concerning
program design and the power of generalization.  Later sections expand
upon this example, making it more general purpose.  This is a common
facet of programming--taking a specific case, recognizing recurring
patterns, and generalizing code upon those patterns.

### Exercises

**Read [Section 1.1.7](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e7)**, 
enter the code for computing square roots, and try the examples yourself.

**Exercise 1.6**: Alyssa P. Hacker doesn't see why
`if` needs to be provided as a special form.  "Why can't I just define it
as an ordinary procedure in terms of `cond`" she asks.  Alyssa's friend
Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:

```
(define (new-if predicate 
                then-clause 
                else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
```

Eva demonstrates the program for Alyssa:

```
(new-if (= 2 3) 0 5)
5
(new-if (= 1 1) 0 5)
0
```

Delighted, Alyssa uses `new-if` to rewrite the square-root program:

```
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))
```

What happens when Alyssa attempts to use this to compute square roots?
Explain.

**Exercise 1.8**: Newton's method for cube roots is
based on the fact that if `y` is an approximation to the cube root of `x`,
then a better approximation is given by the value

```
x/y^2 + 2y
----------
    3
```

Use this formula to implement a cube-root procedure analogous to the
square-root procedure.  In section 1.3.4 we will see how to implement
Newton's method in general as an abstraction of these square-root and cube-root
procedures.)


## [1.1.8 Procedures as Black-Box Abstractions](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e8)

The whole idea of a procedure is that an input goes in and a result pops out.
For example:

```
(sqrt 3)      ; -> 1.7320508075688772
```

The problem is that the actual implementation might involve multiple procedures
working together. For example:

```
(define (sqrt x) ... )
(define (sqrt-iter guess x) ... )
(define (good-enough? guess x) ...)
(define (improve guess x) ...)
```

This is a common problem in programming.  How do you hide internal implementation
details?  If you were using classes, you might try to make private methods.
However, in Scheme, you can solve this problem by defining inner procedures:

```
(define (sqrt x)
     ; Inner procedures
     (define (sqrt-iter guess) ...)
     (define (good-enough? guess) ...)
     (define (improve guess) ...)

     ; Initiate the calculation
     (sqrt-iter 1.0))
```

If you do this, there is a nesting of name-visibility called
"lexical scoping."   That is, the interior of the `sqrt` procedure
defines a kind of enclosing environment.  All of the interior
procedures can see each other.  However, none of these procedures
are visible from code that is outside the `sqrt` procedure.

The nesting of names is something that will become more important later.
Consider this code:

```
(define a 42)

(define (outer x)
     (define (inner y)
          (+ a x y))
     (inner 10))

(outer 37)
```

In this code, the `inner` procedure can see all names in surrounding
scopes.  This includes the global name `a`, the name `x` in the
`outer` procedure and the name `y`.

A bit of terminology: A variable is called "bound" if it is attached
to a procedure argument.  A variable is called "free" if it defined
outside of a procedure.  When using these descriptions it is important
to know the context.  For example, in the above example, `x` is free
in the `inner` procedure, but bound in the `outer` procedure.

The difference between free and bound variables is subtle. However,
one rule of thumb concerns renaming.  A bound variable can be easily
renamed without breaking anything.  For example, you could change the
name `y` to `z` in the `inner` procedure like this:

```
(define a 42)

(define (outer x)
     (define (inner z)
          (+ a x z))
     (inner 10))

(outer 37)
```

Making this change doesn't change the meaning of the code or break anything.
On the other hand, if you renamed the variable `x` in the `inner` procedure,
the code would break.

### Exercises

**Reading [Section 1.1.8](http://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e8)**.
Rewrite the `sqrt` procedure to use internal procedures as described.

## [1.2 Procedures and the Processes They Generate](http://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2)

The fundamental nature of computation is that it involves a sequence of
steps. For example, to compute `5!` (factorial), you know
that it's a series of multiplications:

```
5! = 5 * 4 * 3 * 2 * 1
   = 20 * 3 * 2 * 1
   = 60 * 2 * 1
   = 120 * 1
   = 120
```

You can express this as a recursive procedure:

```
(define (fact n)
     (if (= n 1)
         n
	 (* n (fact (- n 1)))))
```

A challenge in writing recursive procedures is figuring out how to think about it.
As a general rule, a recursive process is always going to work
"backwards" by breaking down a larger problem into a smaller problem.  For example, if
asked to compute 5 factorial, perhaps you can decompose it into a 
computation involving 4 factorial.  You also need to think about the base
case that makes it stop.  What is most simple thing?  For factorials, you're
done when you reach 1.

You can see how the procedure works by applying the subtitution model.
Remember, that's the ONLY thing you know so far.  Procedures work by
substitution.

```
(fact 5)

(* 5 (fact 4))
(* 5 (* 4 (fact 3)))
(* 5 (* 4 (* 3 (fact 2))))
(* 5 (* 4 (* 3 (* 2 (fact 1)))))
(* 5 (* 4 (* 3 (* 2 1))))
(* 5 (* 4 (* 3 2)))
(* 5 (* 4 6))
(* 5 24))
120
```

Deep thought:  How deep does the nesting of substitutions grow?  Notice
how the chain of "pending operations" keeps growing and growing until
you hit the base case of the recursion.  Then it starts to collapse.

Thought: Is there away to avoid all of that nesting?

Answer: yes.  You can restructure the inner workings of the procedure
to work in a slightly different way:

```
(define (fact n)
    (define (fact-iter n result)
        (if (= n 1)
	    result
	    (fact-iter (- n 1) (* n result))))
    (fact-iter n 1)
)
```

Here's the general idea:  The final result is now carried forward on each
procedure call.  Nothing is left behind.   If you watch what happens
with substitution, you get this:

```
(fact 5)
(fact-iter 5 1)
(fact-iter 4 5)
(fact-iter 3 20)
(fact-iter 2 60)
(fact-iter 1 120)
120
```

Notice that each step is basically exactly the same as the previous
step--only the procedure arguments are different.  No part of
the computation is "left behind" to be carried out later.

This latter approach is a computational processs known as "linear
iteration."  It has efficiency that's similar to using a `for-loop` in
other languages. It just looks weird because it is still written using
a procedure involving recursion.  As an aside, this efficiency is only
possible due to an implementation detail of Scheme known as
"tail-recursion."  Most conventional programming languages do NOT
implement tail-recursion.

The first example is a recursive computational process--specifically a
process involving "linear recursion."  A recursive process always
leaves some part of the computation behind--to be completed later.

Note: SICP makes a BIG deal out of "recursion" versus "iteration".
You will be asked to write code using either style---you will also be
asked to convert from one style to the other.

How to remember?  A recursive process will always leave some part of
the calculation behind for later.  An iterative process always carries
everything needed forward to the next procedure call.

A deeper thought: in the above examples, the order of the actual math
operations is different.  For example, a recursive process actually
computes the value from right-to-left as follows:

```
5 * 4 * 3 * 2 * 1
5 * 4 * 3 * 2
5 * 4 * 6
5 * 24
120
```

The iterative process computes the value from left-to-right as follows:

```
5 * 4 * 3 * 2 * 1
20 * 3 * 2 * 1
60 * 2 * 1
120 * 1
120
```

Ponder: Is this "directional aspect" (left vs right) an inherent quality of
iteration versus recursion?

Also, not all recursion is linear.  There are pathological cases that might
exhibit exponential growth in the number of computation steps
involved.  For example, consider this implementation of fibonacci numbers:

```
(define (fib n)
    (cond ((= n 0) 0)
          ((= n 1) 1)
	  (else (+ (fib (- n 1))
	           (fib (- n 2))))))
```

This creates a tree-like expansion:

```
(fib 5)
(+ (fib 4) (fib 3))
(+ (+ (fib 3) (fib 2)) (fib 3))
(+ (+ (+ (fib 2) (fib 1)) (fib 2)) (fib 3))
(+ (+ (+ (+ (fib 1) (fib 0)) (fib 1)) (fib 2)) (fib 3))
...
```

### Exercises

**[Reading: Section 1.2-1.2.1](http://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2)**

**Exercise 1.9**: Each of the following two procedures defines a
method for adding two positive integers in terms of the procedures
`inc`, which increments its argument by 1, and `dec`, which decrements
its argument by 1.

```
(define (inc x) (+ x 1))
(define (dec x) (- x 1))

(define (plus a b)
  (if (= a 0) 
      b 
      (inc (plus (dec a) b))))

(define (plus a b)
  (if (= a 0) 
      b 
      (plus (dec a) (inc b))))
```

Using the substitution model, illustrate the process generated by each
procedure in evaluating `(plus 4 5)`.  Are these processes iterative or
recursive?

**[Reading: Section 1.2.4](http://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2_002e4).**
One challenge of SICP is wrapping your brain around recursive problem
solving.  This section describes some thinking about how to break down
a problem into steps and how algorithmic choice can greatly affect the
number of steps required.  Read through the code examples and try the
implementation of `fast-expt`.

**Exercise 1.16:** Design an iterative version of the `fast-expt`
procedure given in the text.  Hint: to do this, it might help to use a
subtle trick of algorithm design.  Normally when implementing an
algorithm, you're thinking about how to break a problem down into
smaller and smaller steps (e.g., subdividing the problem into parts).  However,
sometimes it might make sense to change the problem into a different, but
equivalent problem.  For example, suppose you were computing
`2^16`. You could rewrite this problem by doubling the base and halving the exponent.
Thus, it's really the same as computing `4^8`.  Perhaps this trick could be used
in your solution.

**Exercise 1.17:** The exponentiation algorithms in
this section are based on performing exponentiation by means of repeated
multiplication.  In a similar way, one can perform integer multiplication by
means of repeated addition.  The following multiplication procedure (in which
it is assumed that our language can only add, not multiply) is analogous to the
`expt` procedure:

```
(define (mul a b)
  (if (= b 0)
      0
      (+ a (mul a (- b 1)))))
```

This algorithm takes a number of steps that is linear in `b`.  Now suppose
we include, together with addition, operations `double`, which doubles an
integer, and `halve`, which divides an (even) integer by 2.  Using these,
design a multiplication procedure analogous to `fast-expt` that uses a
logarithmic number of steps.

## [1.3 Formulating Abstractions with Higher Order Procedures](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3)

A common goal in programming is to recognize patterns and to
generalize.  For example, you often hear about DRY (Don't Repeat
Yourself).  Consider this problem of computing three different sums:

```
; Sum the integers a, a+1, a+2, ..., b
(define (sum-integers a b)
    (if (> a b)
        0
	(+ a (sum-integers (+ a 1) b))))

; Sum the cubes, a^3, (a+1)^3, (a+2)^3, ..., b^3
(define (sum-cubes a b)
    (if (> a b)
        0
	(+ (* a a a) (sum-cubes (+ a 1) b))))

; Sum inverse squares, 1/(a^2), 1/((a+1)^2), 1/((a+2)^2), ..., 1/(b^2)
(define (sum-inv-squares a b)
    (if (> a b)
        0
	(+ (/ 1.0 (* a a)) (sum-inv-squares (+ a 1) b))))
```

Almost all of this code is exactly the same except for one part?  How do you
generalize it?

You look for a common pattern. Notice how everything is the same except for the
actual term being summed, shown as `<term>` below.

```
; Sum the integers a, a+1, a+2, ..., b
(define (sum-integers a b)
    (if (> a b)
        0
	(+ <term> (sum-integers (+ a 1) b))))

; Sum the cubes, a^3, (a+1)^3, (a+2)^3, ..., b^3
(define (sum-cubes a b)
    (if (> a b)
        0
	(+ <term> (sum-cubes (+ a 1) b))))

; Sum inverse squares, 1/(a^2), 1/((a+1)^2), 1/((a+2)^2), ..., 1/(b^2)
(define (sum-inv-squares a b)
    (if (> a b)
        0
	(+ <term> (sum-inv-squares (+ a 1) b))))
```

In fact, you can make term a procedure argument:

```
; Sum terms.   term(a), term(a+1), term(a+2), ... term(b)
(define (sum-terms term a b)
    (if (> a b)
        0
	(+ (term a) (sum-terms (+ a 1) b))))
```

You use this by defining small procedures for the different terms

```
(define (identity n) n)
(define (cube n) (* n n n))
(define (inv-square n) (/ 1.0 (* n n)))

; Compute some sums
(sum-terms identity 1 5)
(sum-terms cube 1 5)
(sum-terms inv-square 1 5)
```

Instead of explicitly writing out named functions, you can also
use `lambda`.

```
(sum-terms (lambda (n) n) 1 5)
(sum-terms (lambda (n) (* n n n)) 1 5)
(sum-terms (lambda (n) (/ 1.0 (* n n))) 1 5)
```

### Exercises

**[Reading, Section 1.3-1.3.1](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3)**.

**Exercise 1.30:** The following `sum` procedure generates a linear recursion:

```
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
```

The procedure can be rewritten so that the sum is performed
iteratively.  Show how to do this by filling in the missing
expressions in the following definition:

```
(define (sum term a next b)
  (define (iter a result)
    (if ⟨??⟩
        ⟨??⟩
        (iter ⟨??⟩ ⟨??⟩)))
  (iter ⟨??⟩ ⟨??⟩))
```

**Exercise 1.31:**

1. The `sum` procedure is only the simplest of a vast number of similar
abstractions that can be captured as higher-order procedures. Write an analogous
procedure called `product` that returns the product of the values of a
function at points over a given range.  Show how to define `factorial` in
terms of `product`.  Also use `product` to compute approximations to
`pi` using the formula

```
pi   2 * 4 * 4 * 6 * 6 * 8 ...
-- = -------------------------
 4   3 * 3 * 5 * 5 * 7 * 7 ...
```

2. If your `product` procedure generates a recursive process, write one that
generates an iterative process.  If it generates an iterative process, write
one that generates a recursive process.

**Exercise 1.32:**

1. 

Show that `sum` and `product` are both special
cases of a still more general notion called `accumulate` that combines a
collection of terms, using some general accumulation function:

```
(accumulate combiner null-value term a next b)
```

`Accumulate` takes as arguments the same term and range specifications as
`sum` and `product`, together with a `combiner` procedure (of
two arguments) that specifies how the current term is to be combined with the
accumulation of the preceding terms and a `null-value` that specifies what
base value to use when the terms run out.  Write `accumulate` and show how
`sum` and `product` can both be defined as simple calls to `accumulate`.

2. If your `accumulate` procedure generates a recursive process, write one
that generates an iterative process.  If it generates an iterative process,
write one that generates a recursive process.


## [1.3.2 Constructing Procedures Using Lambda](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e2)

Instead of defining a named procedure such as this:

```
(define (square x) (* x x))
```

It is possible to use `lambda` instead.

```
(define square (lambda (x) (* x x)))
```

`lambda` creates an unnamed procedure.  It can be rather useful when passing
a procedure to other procedures.  For example, for use with the `sum`
procedure in the last section:

```
(sum (lambda (x) (* x x)) 1 (lambda (x) (+ x 1)) 10)
```

The first part of 1.3.2 discusses this use.  However, the section then
transitions into a much more interesting idea (although the presentation
itself is a bit murky).

SICP presents material that only relies upon the rules of computation
that have actually been introduced so far.  To this end, the only
description of computation that's been given is substitution. That is, if
you have a procedure:

```
(define (square x) (* x x))
```

The evaluation of `(square 2)` works by substituting `2` for `x` in
the expression `(* x x)`.  That's it.  There are no other rules that
we know about.

However, writing everything out in a single expression is often too complicated.
Especially if the expression involves repeated sub-expressions.

If you might indulge a slight diversion, consider, for a moment, this complicated
calculation (in Python):

```
def f(x, y):
    return x * (1 + x*y)*(1 + x*y) + y * (1 - y) + (1 + x*y) * (1 - y)
```

It's pretty hard to read.  However, if you were tasked with
simplifying it, you might consider introducing some temporary
variables for the repeated subexpressions:

```
def f(x y):
    a = 1 + x*y
    b = 1 - y
    return x*a*a + y*b + a*b
```

This is fine for Python, but it doesn't really fit into the overall
model of "computation" developed by SICP.  So far, the *ONLY*
computational process that you know is substitution.  There is no
notion of assignment to variables in the traditional sense (in fact,
SICP hasn't said anything about "storing" anything).  Yes, there is
the `define` statement, but let's ignore that for the moment.

So, how would you accomplish the same goal of having temporaries if
you didn't have the ability to introduce temporary variables?

One way to do it would be to define an inner helper procedure and to
bind its arguments to the values.  Consider this reformulation of the
above code:

```
def f(x, y):
    def helper(a, b):
        return x*a*a + y*b + a*b
    return helper(1 + x*y, 1-y)
```

Convince yourself that it gives the same answer.  Now, convince
yourself that this restatement involving lambda would work as
well (and indeed, it does not involve assignment to temporary variables):

```
def f(x, y):
    return (lambda a,b: x*a*a + y*b + a*b)(1+x*y, 1-y)
```

It turns out that this trick also works in Scheme.

```
(define (f x y)
     ((lambda (a b) (+ (* x a a) (* y b) (* a b))) (+ 1 (* x y)) (- 1 y)))
```

Spend a few moments to pull it apart, ponder it, and verify that
it indeed works.

### Introducing Let

Reading the code with the `lambda` and all of the substitutions is
very painful on the eyes.  So, there is an alternative way of doing
it, using the `let` special form.

```
(define (f x y)
    (let ((a (+ 1 (* x y)))
          (b (- 1 y)))
	  (+ (* x a a) (* y b) (* a b))
    )
)
```

The syntax of `let` is a bit wonky, but it works by taking a list of
name/value bindings along with an expression. The general form of `let` is as follows:

```
(let ((name1 value1)
      (name2 value2)
      ...
      (namen valuen))
      expression)
```

Under the hood, `let` is implemented as pure syntax translation to an expression involving
lambda. Specifically, the names and final expression are turned into
the following:

```
(lambda (name1 name2 ... namen) expression)
```

The values are then turned into the arguments of this function so
the entire `let` expression becomes:

```
((lambda (name1 name2 ... namen) expression) value1 value2 ... valuen)
```

It is easy to dismiss this "hack" as a mere technicality, but there's
a deeper idea at work. Certain special forms such as `(define name
value)` or `(and expr1 expr2 ...)` genuinely have different behavior
than a normal procedure.  However, `let` doesn't really change
anything about the semantics of how a program works--it's purely a
syntactic convenience.  Transformations like this are sometimes known
as "syntatic sugar."

Technically, you don't really need `let` at all--it's just nice to
have.  This leads to a more general question--can other programming
constructs be represented purely in terms of lower-level primitives.
Consider, `cond` for example:

```
(cond ((< x 0) (- x))
      ((= x 0) 0)
      ((> x 0) x)))
```

Perhaps this could be expressed in terms of nested `if` expressions:

```
(if (< x 0)
    (- x)
    (if (= x 0)
        0
	(if (> x 0)
	    x
	    #f)))
```	    

So, perhaps `cond` isn't really all that essential if it can be
rewritten as a a syntactic transformation to a series of `if`
expressions.

Deep thoughts:

* What is the absolute minimum set of "features" required to implement a programming language?
* Can higher-level abstractions be implemented purely as syntax translations to lower-level abstractions?

Related concepts from other programming languages:

* Macros
* Decorators

### Exercises

**[Reading, Section 1.3.2](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e2)**.
Pay very careful attention to the section on `let`.  Try some of the examples.

**Special Exercise**.  Why does this code not work?

```
(define (f x) 
   (let ((a (+ x 10))
         (b (* a 5)))
         (+ a b))
)
(f 2)      ; Fails.  Why?
```

**Special Exercise**.  What answer is given by the following code?  Can you explain it?

```
(define x 5)
(+ (let ((x 3))
        (+ x (* x 10)))
   x)
```

**Exercise 1.34:** Suppose we define the procedure

```
(define (f g) (g 2))
```

Then we have

```
(f square)
4

(f (lambda (z) (* z (+ z 1))))
6
```

What happens if we (perversely) ask the interpreter to evaluate the combination
`(f f)`?  Explain.

## [1.3.3. Procedures as General Methods](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e3)

In section 1.1.7, a case study involving the computation of square
roots was given.  The code worked by making a series of successive
approximations to the answer until guesses converged.  One might
wonder whether that kind of approach is a more general technique?

Naturally, it is (otherwise we wouldn't talk about it further).  This
section discusses a related concept known as a "fixed point."

A "fixed point" of a function `f(x)` is a value `x` such that `x = f(x)`.
In other words, it's a value that remains fixed/unchanged if you
apply a function to it.  As an example, consider the `sqrt`
function.  If you compute `(sqrt 1)`, the answer is `1`.  Thus, `1`
is a "fixed point" of `sqrt()`.

Fixed points are weird.  One thing that's strange about them is that
you can usually find a fixed-point by picking some random starting
value and repeatedly applying a function over and over again. Consider
the `sqrt` function again.  Try this experiment in a language like
Python or on a calculator:

```
>>> from math import sqrt
>>> sqrt(1234567)               # Pick some random number
1111.1107055554814
>>> sqrt(_)                     # Keep applying sqrt (_ is the last result)
33.333327249998334
>>> sqrt(_)
5.773502165063968
>>> sqrt(_)
2.402811304506446
>>> sqrt(_)
1.5501004175557291
>>> sqrt(_)
1.2450302878065775
>>> sqrt(_)
1.1158092524291854
>>> sqrt(_)
1.0563187267246499
>>> sqrt(_)
1.0277736748548534
>>> sqrt(_)
1.0137917314985625
>>> sqrt(_)
1.0068722518266964
>>> 
```

Notice that the answer keeps getting closer and closer to 1.0.
Eventually, it will reach 1.0 and just stay there.  Congratulations,
you've found a fixed point.  But, you really didn't do anything except
turn the crank by calling the function over and over again.

There's a certain appeal of something like this to computer
scientists.  First, since finding a fixed point is a repetitive
process, it seems like something that could be turned into a general 
algorithm.  That's what you're going to do.

### Exercises

**[Reading, Section 1.3.3](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e3):**
Read the part about "fixed points".  Enter the code for computing them
and try and few of the examples shown.  

## [1.3.4. Procedures as Returned Values](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e4)

Just as procedures can be accepted as arguments, procedures can also be created as the result
of a procedure.  For example:

```
(define (f x)
     (lambda (y) (+ x y))
)

(define g (f 10))     ; g -> (lambda (y) (+ 10 y))

(g 20)                ; --> 30
```

Nested procedures have the effect of "remembering" the values of outer
arguments.  This can be explained purely via substitution.  The outer
procedure "substitutes the x" in the inner procedure.

Note: In many programming languages, an inner procedure is called a
"closure" although SICP avoids this terminology entirely.

The idea of creating a procedure from other procedures is a powerful
concept.  In some sense, it's a form of "code generation."  It's a
step beyond the normal sort of programming that most people are used
to.

Digression:  There is an analogous idea from math.  Consider math classes
from school.  Students in grade school learn how to calculate things:

```
3 + (4 * (7 + 9) + 2)*10
```

In middle school, you start to learn about algebra and functions. For
example, you might study a function like this:

```
f(x) = 3*x*x + 7*x - 10
```

However, if you keep taking math courses, eventually you'll reach
calculus.  In calculus, you might be asked to figure out the derivative
of `f(x)`.  And, assuming you know the rules, you'd write out:

```
f'(x) = 6*x + 7
```

But wait!  What you just did is an example of a higher order function.
The "derivative" operation takes a function as input and produces
another function as output.  

```
f -> [ derivative ] -> f'
```

In fact, you probably do this sort of thing all of the time now
without even realizing it.  For example, using decorators in Python:

```
@decorator
def func(x, y):
    ...
```

Decorators take a function as input and produce a new function as
output.  It's just like derivatives (just don't tell anyone).

### Exercises

**[Reading, Section 1.3.4](http://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e4):** Read the first part of this section on
the technique of "average damping."  Try the examples involving square roots
and cube roots.  Skip the part on "Newton's Method."


**Exercise 1.41:** Define a procedure `double`
that takes a procedure of one argument as argument and returns a procedure that
applies the original procedure twice.  For example, if `inc` is a
procedure that adds 1 to its argument, then `(double inc)` should be a
procedure that adds 2.  What value is returned by

```
(((double (double double)) inc) 5)
```

**Exercise 1.42:** Let `f` and `g` be two
one-argument functions.  The composition `f` after `g` is defined
to be the function that maps `x` to `f(g(x))`.  Define a procedure
`compose` that implements composition.  For example, if `inc` is a
procedure that adds 1 to its argument,

```
((compose square inc) 6)    ; -> 49
```

**Exercise 1.43:** If `f` is a numerical function
and `n` is a positive integer, then we can form the nth repeated
application of `f`, which is defined to be the function whose value at `x`
is `f(f(...(f(x))))`.  For example, if `f` is the
function that maps `x` to `x+1`, then the nth repeated application of `f` is
the function that maps `x` to `x+n`. If `f` is the operation of squaring a
number, then the nth repeated application of `f` is the function that
raises its argument to the `2^n` power.  Write a procedure that takes as
inputs a procedure that computes `f` and a positive integer `n` and returns
the procedure that computes the nth repeated application of `f`.  Your
procedure should be able to be used as follows:

```
((repeated square 2) 5)    ;-> 625
```

Hint: You may find it convenient to use `compose` from Exercise 1.42.

**Exercise 1.46:** Several of the numerical methods
described in this chapter are instances of an extremely general computational
strategy known as "iterative improvement".  Iterative improvement says
that, to compute something, we start with an initial guess for the answer, test
if the guess is good enough, and otherwise improve the guess and continue the
process using the improved guess as the new guess.  Write a procedure
`iterative-improve` that takes two procedures as arguments: a method for
telling whether a guess is good enough and a method for improving a guess.
`Iterative-improve` should return as its value a procedure that takes a
guess as argument and keeps improving the guess until it is good enough.
Rewrite the `sqrt` procedure of section 1.1.7 and the
`fixed-point` procedure of section 1.3.3 in terms of
`iterative-improve`.

**Challenge Exercise:** Throughout chapter 1, the only model of computation described
is that of substitution.  For example, if you define a procedure `fact` like this:

```
(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
```

It evaluates by substituting the `n` with whatever value you provide.

```
(fact 5) ; --> (if (= 5 0) 1 (* 5 (fact (- 5 1)))))
```

After this substitution, further steps might be carried out to get to
a final answer (for example, recursive calls to `fact` involve further
substitutions).

One "fuzzy" aspect of this whole model is the behavior of `define`. It
assigns a name to a procedure, but where do these names live?  Are
procedures stored somewhere? We simply have no idea and no further
details.  Are defined names even necessary at all?  Maybe you don't
even need `define`.

Suppose you had the following procedure:

```
(define (square x) (* x x))
(square 10)       ; --> 100
```

As you know, an unnamed procedure can be defined using `lambda`.  So,
you could certainly write the above calculation as follows:

```
((lambda (x) (* x x)) 10)   ; --> 100
```

Observe:  The `define` statement went away as well as the name `square`.

Challenge: Can you also define `fact` as an unnamed procedure using `lambda`?
This is, could you write a single expression, involving no `define` statements,
that works like this:

```
; Compute 5!
((lambda <???> ...) 5)          ; --> 120
```

Hint:  Any free-variable `y` with value `v` in an expression `e` can be replaced by an
expression of the form `((lambda (y) e) v)`.   For example:

```
(define y 2)                ; A free variable
((lambda (x) (+ x y)) 3)    ; --> 5

; Can rewrite as follows
(((lambda (y) (lambda (x) (+ x y))) 2) 3)  ; --> 5
```





	      



































