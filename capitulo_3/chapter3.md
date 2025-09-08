# Chapter 3 : Modularity, Objects, and State

As programs grow in size, one needs a strategy for their management.
Also, modeling objects in the physical world presents unique
strategies.  This chapter introduces more concepts concerning,
objects, mutability, concurrency, and streams.

## [3.1 Assignment and Local State](http://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1)


This section introduces the idea of objects and their behavior.  For example, consider
the problem of managing a bank account.  A bank account has an associated balance.
Over time, the balance changes.

Up to this point, nothing has been said about changing values. However, Scheme
provides a `(set! name newvalue)` special form that can be used to
mutate a value.   Here is an example:

```
(define balance 100)

(define (withdraw amt)
    (begin
        (set! balance (- balance mt))
	balance
    )
)

;  Example

(withdraw 10)
90
(withdraw 50)
40
```

In this code, there is a side-effect or a state change.

Introducing assignment also introduces a new style of programming known as
"imperative" programming.   Imperative programming is characterized by sequences
of steps--each carrying out some kind of action. Actions "do things" such as
change the value of a variable, perform I/O, etc. To allow for multiple steps,
the `(begin ...)` special form can be used.   `begin` allows multiple expressions
to be grouped together and executed in sequence.  The result of the final expression
is the final result.

Note: In some places you can already use multiple expressions and avoid the use of
`(begin ...)`.  For example, a procedure body can already contain multiple steps.
So, you might see code written like this instead:

```
(define (withdraw amt)
    (set! balance (- balance amt))
    balance
    )
```

Multiple expressions can also be used in the clauses of `(cond ...)`.  

Digression: It's kind of amazing that assignment has not been used
once up to this point (pg. 217 in the printed book).  When one refers
to "functional programming", it usually implies programming without
assignments or mutation.  Assignment changes everything--especially
the evaluation model.

Previously, we discussed the scoping/binding of names.  For example:

```
(define a 42
(define (outer x)
    (define (inner y)
        (+ a x y))
    (inner 10))

(outer 37)
```

In this example, there are nested environments:

```
 _______________________________________
| a: 42                        Globals  |
|   _________________________________   |
|  | x: 37                     outer |  |
|  |   _________________________     |  |
|  |  | y: 10           inner   |    |  |
|  |  |                         |    |  |
|  |  |_________________________|    |  |
|  |_________________________________|  |
|_______________________________________|
```

With assignment, these environments become a place to store
and load state.

In fact, the environments can serve as a kind of object.
Try this example:

```
(define (make-counter n)
    (define (incr)
         (begin
	      (set! n (+ n 1))
	      n
	 )
    )
    incr
)

; Example
(define c (make-counter 0))
(define d (make-counter 10))

(c)    ; -> 1
(c)    ; -> 2
(d)    ; -> 11
(d)    ; -> 12
```

Behind the scenes, the `incr` procedure that's returned is attached
to an environment that holds the value of the `n` variable.  Each application
of `make-counter` creates a separate environment.

```
c : [ procedure: incr ]--->{ 'n': 0 }
d : [ procedure: incr ]--->{ 'n': 10 }   
```

Digression:  This technique also works in Python:

```
def make_counter(n):
    def incr():
        nonlocal n   # Need to modify the outer value
        n += 1
        return n
    return incr

# Example

>>> c = make_counter(0)
>>> d = make_counter(10)
>>> c()
1
>>> c()
2
>>> d()
11
>>>
```

If you introduce an internal dispatching function, you can make more complex objects:

```
(define (make-account balance)
    (define (withdraw amount)
         (begin (set! balance (- balance amount))
                 balance)

    (define (deposit amount)
         (begin (set! balance (+ balance amount))
                balance)

    (define (dispatch m)
          (cond ((eq? m 'withdraw) withdraw)
                ((eq? m 'deposit) deposit)))
    dispatch)

; Example

(define acc (make-account 100))
((acc 'withdraw) 30)
((acc 'deposit) 75)
```

### Exercises

**[Reading, Section 3.1.1](http://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1_002e1)**

**Exercise 3.1:**
An accumulator is a
procedure that is called repeatedly with a single numeric argument and
accumulates its arguments into a sum.  Each time it is called, it returns the
currently accumulated sum.  Write a procedure `make-accumulator` that
generates accumulators, each maintaining an independent sum.  The input to
`make-accumulator` should specify the initial value of the sum; for
example

```
(define A (make-accumulator 5))

(A 10)
15

(A 10)
25
```

**Exercise 3.2:** In software-testing applications,
it is useful to be able to count the number of times a given procedure is
called during the course of a computation.  Write a procedure
`make-monitored` that takes as input a procedure, `f`, that itself
takes one input.  The result returned by `make-monitored` is a third
procedure, say `mf`, that keeps track of the number of times it has been
called by maintaining an internal counter.  If the input to `mf` is the
special symbol `how-many-calls?`, then `mf` returns the value of the
counter.  If the input is the special symbol `reset-count`, then `mf`
resets the counter to zero.  For any other input, `mf` returns the result
of calling `f` on that input and increments the counter.  For instance, we
could make a monitored version of the `sqrt` procedure:

```
(define s (make-monitored sqrt))

(s 100)
10

(s 'how-many-calls?)
1
```

Note: This exercise is similar to writing a decorator in Python.

**[Reading, Section 3.1.3](http://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1_002e3)**


**Exercise 3.8:** When we defined the evaluation
model in 1.1.3, we said that the first step in evaluating an
expression is to evaluate its subexpressions.  But we never specified the order
in which the subexpressions should be evaluated (e.g., left to right or right
to left).  When we introduce assignment, the order in which the arguments to a
procedure are evaluated can make a difference to the result.  Define a simple
procedure `f` such that evaluating 

```
(+ (f 0) (f 1))
```

will return 0 if
the arguments to `+` are evaluated from left to right but will return 1 if
the arguments are evaluated from right to left.


## [3.2 The Environment Model of Evaluation](http://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2)

The introduction of assignment breaks the entire substitution model of evaluation.  Consider this:

```
(define (make-accum n)
   (lambda (x)
       (set! n (+ n x))
       n
   ))
```

Now, consider the application:

```
(define a (make-accum 0))
```

The substitution model works literally through symbol replacement.  So, everywhere you see an
`n`, you put `0`.  Thus, the application `(make-accum 0)` would produce this:

```
(lambda (x)
    (set! 0 (+ 0 x))
    0
))
```

That's clearly wrong on many accounts (e.g., look at the `set!`).

To accommodate assignment, you need a different approach.  That approach is the "environment model" where
names represent locations within an environment.  Get and set operations are used to load and store
values out of the environment.

Think of an environment as being like a dictionary in Python. If you
go back to the `make-accum` example, instead of substituting symbols,
the application of `(make-accum 0)` now creates a procedure with an
attached environment like this:

```
(lambda (x)            ; env --> { 'n': 0 }
    (set! n (+ n x))   
    n
)
```

The evaluation of `n` performs an environment lookup `env['n']` which
returns the value.  Setting `n` to a new value performs an environment
assignment `env['n'] = value`.

When you apply this procedure, there are two environments (the original
definition environment and an environment that holds the procedure
input arguments):

```
(define a (make-accum 0))
(a 10)        ; env --> {'x': 10} --> {'n': 0 }
              ; (set! n (+ n x)) --> (set! n (+ 0 10))
              ; n                --> 10
```

Understanding the environment model can be tricky, but there are two
key ideas:

* All procedures have an attached environment that represents the
  environment in which they were defined.  This environment holds
  the free variables.  Sometimes it's called a "closure"

* When you apply a procedure, a new environment is created to hold
  the procedure arguments and internal definitions.   This is sometimes
  called an "activation frame".  You see it when you get traceback
  messages when your program crashes.

### Exercises

**Exercise 3.9:** Will discuss as a group.  In 1.2.1 we used the
substitution model to analyze two procedures for computing factorials, a
recursive version

```
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))
```

and an iterative version

```
(define (factorial n)
  (fact-iter 1 1 n))

(define (fact-iter product 
                   counter 
                   max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))
```

Show the environment structures created by evaluating `(factorial 6)`
using each version of the `factorial` procedure.

**Exercise 3.11:** Will discuss as a group.  In 3.2.3 we saw how
the environment model described the behavior of procedures with local state.
Now we have seen how internal definitions work.  A typical message-passing
procedure contains both of these aspects.  Consider the bank account procedure
of 3.1.1:

```
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance 
                     (- balance 
                        amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request: 
                        MAKE-ACCOUNT" 
                       m))))
  dispatch)
```

Show the environment structure generated by the sequence of interactions

```
(define acc (make-account 50))

((acc 'deposit) 40)
90

((acc 'withdraw) 60)
30
```

Where is the local state for `acc` kept?  Suppose we define another
account

```
(define acc2 (make-account 100))
```

How are the local states for the two accounts kept distinct?  Which parts of
the environment structure are shared between `acc` and `acc2`?

## [3.3 Modeling with Mutable Data](http://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3)

This section introduces the idea of mutable data through mutable cons cells.

```
(define c (cons 3 4))
(set-car! c 10)    ; Changes left value
(set-cdr! c 20)    ; Changes right value
```

Mutable pairs allow you to make a variety of new data structures including
mutable lists, queues, trees, etc.

One complexity:  Racket does have mutable cons!  Instead, you have to
use a different construct `mcons` along with functions such as `mcar`,
`mcdr`, etc.

```
(define c (mcons 3 4))

(mcar c)    ; -> 3
(mcdr c)    ; -> 4
(set-mcar! c 10)
(set-mcdr! c 20)
```

We're going to work through some examples of mutable data.

### Exercises

**[Reading: 3.3-3.3.1](http://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3)**

**Exercise 3.12:**  The following procedure for
appending lists was introduced in 2.2.1.  It has been modified for use in Racket specifically
for this exercise.

```
(define (append x y)
  (if (null? x)
      y
      (mcons (mcar x) (append (mcdr x) y))))
```

`Append` forms a new list by successively `cons`ing the elements of
`x` onto `y`.  The procedure `append!` is similar to
`append`, but it is a mutator rather than a constructor.  It appends the
lists by splicing them together, modifying the final pair of `x` so that
its `cdr` is now `y`.  (It is an error to call `append!` with an
empty `x`.)

```
(define (append! x y)
  (set-mcdr! (last-pair x) y)
  x)
```

Here `last-pair` is a procedure that returns the last pair in its
argument:

```
(define (last-pair x)
  (if (null? (mcdr x))
      x
      (last-pair (mcdr x))))
```

Consider the interaction

```
(define x (mcons 'a (mcons 'b null)))
(define y (mcons 'c (mcons 'd null)))
(define z (append x y))

z
(mcons 'a (mcons 'b (mcons 'c (mcons 'd '()))))

(cdr x)
⟨response⟩

(define w (append! x y))

w
(mcons 'a (mcons 'b (mcons 'c (mcons 'd '()))))

(cdr x)
⟨response⟩
```

What are the missing `⟨response⟩`s?  Draw box-and-pointer diagrams to
explain your answer.

**Exercise 3.16:** Ben Bitdiddle decides to write a
procedure to count the number of pairs in any list structure.  "It's easy,"
he reasons.  "The number of pairs in any structure is the number in the
`car` plus the number in the `cdr` plus one more to count the current
pair."  So Ben writes the following procedure (modified for Racket):

```
(define (count-pairs x)
  (if (not (mpair? x))
      0
      (+ (count-pairs (mcar x))
         (count-pairs (mcdr x))
         1)))
```

Show that this procedure is not correct.  In particular, draw box-and-pointer
diagrams representing list structures made up of exactly three pairs for which
Ben's procedure would return 3; return 4; return 7; never return at all.  Encode
these diagrams as data structures using Racket `mcons`.

**[Reading 3.3.2 Queues](http://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e2):**
Work through the queue example in detail. Then proceed to
the next exercise.

**Exercise 3.22:** Instead of representing a queue
as a pair of pointers, we can build a queue as a procedure with local state.
The local state will consist of pointers to the beginning and the end of an
ordinary list.  Thus, the `make-queue` procedure will have the form

```
(define (make-queue)
  (let ((front-ptr ... )
        (rear-ptr ... ))
    ⟨ definitions of internal procedures ⟩
    (define (dispatch m) ...)
    dispatch))
```

Complete the definition of `make-queue` and provide implementations of the
queue operations using this representation.

## Thorny Issues of Assignment

Much of Chapter 3 is devoted to discussing complex problems that arise
from the introduction of mutability.  Much of this stems from the
mathematical elegance of the substitution model.  Substitution is easy
to describe and easy to reason about.  In some sense, this *IS* is the
primary appeal of functional programming in general.

As noted mutability entirely breaks the substitution model of evaluation.
Instead, you have now have to worry about environments and load/store
operations.  There are new problems concerning the concept of "sameness."
For example:

```
(define a (cons 2 3))
(define b (cons 2 3))
```

Question:  Are "a" and "b" the same?

If they are, what about this?

```
(define a (cons 2 3))
(define b (cons 2 4))     ; Not the same

(set-cdr! b 3)            ; Is b now the same as a?
```

In many languages, difficulties related to "sameness" manifest in
the form of different types of object comparisons.  For example, in
Python, you can compare objects using `is` or `==`.  The `is` operator
tests if two objects are literally the same object in memory (meaning
stored at the same memory location).  The `==` operator tests two
objects to see if they have the same value. For example:

```
a = [1,2,3]
b = a
c = [1,2,3]

a == b       # -> True    (same value)
a == c       # -> True    (same value)
a is b       # -> True    (same object)
a is c       # -> False   (different objects)
```

A greater problem concerns the introduction of "time" into program
evaluation.  With assignment, operations now need to be sequenced in a
particular order.  Moreover, the final result now depends on the
execution order.

Section 3.4 discusses time sequencing of operations in the context of
concurrency and introduces some ideas concerning thread programming.
For example, consider a scenario as shown in [Figure 3.29](http://sarabander.github.io/sicp/html/3_002e4.xhtml#Figure-3_002e29).

Since this isn't a course on concurrency, we're not going to say much more
about it here.  However, I will do a few live demonstrations of concurrency
issues in Python.

## [3.5 Streams](http://sarabander.github.io/sicp/html/3_002e5.xhtml#g_t3_002e5)

This chapter introduces a new concept, the "stream."  As background, a common
way to organize systems is as a workflow where data flows through a series
of processing steps:

```
[ step 1 ] ---> [ step 2  ] ---> [ step 3 ]
```

A real-world example might be Unix pipes:

```
tail -f logfile | grep foo | awk '{print $1}'
```

Python generators might also be a similar example.  For example, consider this:

```
def count_forever(n):
    while True:
         yield n
	 n += 1

for x in count_forever(10):
    print(x)

10
11
12
...
13
```

One unusual thing about a generator concerns the evaluation model.  For example,
a generator does nothing until a value is demanded:

```
>>> c = count_forever(10)
>>> next(c)
10
>>> next(c)
11
>>>
```

Big idea: The execution is delayed until later.

Scheme has a special form that can be used to delay evaluation:

```
(define p (delay (+ 3 4)))
```

Creates a "promise".  Does NOT evaluate the expression.   To get
the value, you need to force it:

```
(force p)      ; -> 7
```

These features can be implemented using lambda:

```
(define p (lambda () (+ 3 4)))   ; 0-argument lambda (aka. "thunk")

; Force
(define (force p) (p))
```

Recall the concept of a list:

```
(cons a (cons b (cons c nil)))
```

New Concept: A Stream

```
(cons a (delay b))
```

It's like a list, but the remainder of the list is "delayed".  You can define
a few primitives to help out:

```
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream))
```

Streams are interesting and weird.  Consider this example:

```
(define (enumerate-interval start stop)
    (if (> start stop)
        '()
	(cons start
	      (delay (enumerate-interval (+ start 1) stop)))))

; Now create a huge stream
(define nums (enumerate-interval 1 100000000))

; Does it shatter the memory of your computer?  No. nums is
; just a single cons cell.
```

Here's an example of a procedure that consumes a stream:

```
(define (display-stream s)
     (if (null? s) nil
         (begin (display (stream-car s))
                (newline)
                (display-stream (stream-cdr s)))))

; Example
(display-stream (enumerate-interval 0 3))
0
1
2
3
```

Because streams are interesting and useful, Scheme implementations usually
provide a number of special forms and procedures for dealing with them.  In Racket,
the following procedures pertain to Streams:

```
empty-stream             ; empty stream object
(stream-empty? s)        ; Check for empty
(stream-cons first rest) ; Make a new stream
(stream-first s)         ; First element
(stream-rest s)          ; Remaining elements
(stream-for-each proc s) ; Apply proc to each item
```

These procedures differ from SICP.  In the exercises and examples that follow, I will
use the Racket functions so that you can try the code.

Example:  Consider this procedure that computes the sum inverse squares:

```
; Non-stream version

(define (sum-inv-squares start end)
   (if (> start end)
       0
       (+ (/ 1 (* start start)) (sum-inv-squares (+ start 1) end))))

(sum-inv-squares 1.0 5.0)
1.4636111111111112
```

Inside this procedure, the whole calculation is mixed together into a jumbled
mess.  We're going to restructure this as a stream calculation

```
;  nums           squares        invsquares
[ 1, 2, ...] -> [1, 4, ...] -> [1, 0.25, ...] -> [ sum ]
```

Start by defining a few core functions

```
(define (enumerate-interval start stop)
    (if (> start stop)
        empty-stream
        (stream-cons start 
                     (enumerate-interval (+ start 1) stop))))

(define (stream-map proc s)
    (if (stream-empty? s) 
        empty-stream
        (stream-cons (proc (stream-first s))
                     (stream-map proc (stream-rest s)))))

(define (stream-sum s)
    (if (stream-empty? s)
        0
	(+ (stream-first s) (stream-sum (stream-rest s)))))
```

Now, use these to solve the specific problem shown:

```
(define nums (enumerate-interval 1.0 5.0))
(define squares (stream-map (lambda (x) (* x x)) nums))
(define invsquares (stream-map (lambda (x) (/ 1.0 x)) squares))
(stream-sum invsquares)
```

Carefully contemplate how data is flowing through the system.

### Exercises

**[Reading 3.5, 3.5.1](http://sarabander.github.io/sicp/html/3_002e5.xhtml#g_t3_002e5):** Read and try some of the examples.

**Exercise 3.51:** In order to take a closer look at
delayed evaluation, we will use the following procedure, which simply returns
its argument after printing it:

```
(define (show x)
  (display-line x)
  x)
```

What does the interpreter print in response to evaluating each expression in
the following sequence? [footnote](http://sarabander.github.io/sicp/html/3_002e5.xhtml#FOOT187)

```
(define x 
  (stream-map 
   show 
   (stream-enumerate-interval 0 10)))

(stream-ref x 5)
(stream-ref x 7)
```


**Exercise 3.52:** One common optimization of streams is that of
"memoization."  When the delayed part of a stream is evaluated, the
the result is cached or memorized for later.  This can avoid repeated
operations.  This exercise explores that idea.

Consider the sequence of expressions

```
(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq 
  (stream-map 
   accum 
   (stream-enumerate-interval 1 20)))

(define y (stream-filter even? seq))

(define z 
  (stream-filter 
   (lambda (x) 
     (= (remainder x 5) 0)) seq))

(stream-ref y 7)
(display-stream z)
```

What is the value of `sum` after each of the above expressions is
evaluated?  What is the printed response to evaluating the `stream-ref`
and `display-stream` expressions?  Would these responses differ if we had
implemented `(delay ⟨exp⟩)` simply as `(lambda () ⟨exp⟩)`
without using the optimization provided by `memo-proc`?  Explain.

**[Reading, 3.5.2](http://sarabander.github.io/sicp/html/3_002e5.xhtml#g_t3_002e5_002e2):**
Implement the `(add-stream s1 s2)` procedure without
using stream-map.

**Exercise 3.53:** Without running the program,
describe the elements of the stream defined by

```
(define s (stream-cons 1 (add-streams s s)))
```

**Exercise 3.54:** Define a procedure
`mul-streams`, analogous to `add-streams`, that produces the
elementwise product of its two input streams.  Use this together with the
stream of `integers` to complete the following definition of the stream
whose nth element (counting from 0) is `n + 1` factorial:

```
(define factorials 
  (cons-stream 1 (mul-streams ⟨??⟩ ⟨??⟩)))
```








































