# Chapter 5 : Computing with Register Machines

Up to this point, SICP has covered a lot about computation, abstraction,
and programming.  However, it still feels very magical and unsettling (at least I think so).
At some point, programs have to work in physical reality.  But how?

Chapter 5 ultimately teaches you how to make a compiler!  Along the way,
it introduces machine code, garbage collection, memory management, and all sorts
of other things.   Even at the University, it is typical for a SICP to skip Chapter 5.
There's simply too much material for a single semester.

That said, out goal is to introduce a tiny bit of it.  We'll talk about
register machines and how computational processes map to register
machines.

## Registers

The most primitive concept in this chapter is the concept of a
"register."  A register is a place to store a value.  Think of it as a box.
There are just two operations--get/set.

```
               _______
	      |       |
   Register   |  42   |
              |_______|

(r 'get)          ;  -> 42
(r 'set! 13)      ;  Changes the value to 13
```

A register is something that can be built with circuits--a bunch of bits
that hold a value.

### Exercise:

Implement a procedure `make-register`  that creates a register object
with the interface shown.  Note: This uses the "message passing" idea
introduced earlier.

```
(define r (make-register))
(r 'get)
(r 'set! newvalue)
```

## Mapping Iterative Processes to Register Machines

This is a highly condensed discussion of material from [section 5.1](http://sarabander.github.io/sicp/html/5_002e1.xhtml#g_t5_002e1).

Consider this procedure:

```
(define (fact n)
    (define (fact-iter n result)
         (if (= n 1) result
             (fact-iter (- n 1) (* n result))))
    (fact-iter n 1)
)
```

Recall that it executes this sequence of operations:

```
(fact 5)
(fact-iter 5 1)
(fact-iter 4 5)
(fact-iter 3 20)
(fact-iter 2 60)
(fact-iter 1 120)
...
```

Study it for a few moments.  Now, follow the following
recipe for mapping the algorithm to a register machine:

### Step 1: Identify the registers

Registers hold values.  Your first step is to identify the
distinct values in the procedure.   In the case of `(fact n)`,
there are two registers--they correspond to the procedure
arguments of `fact` and `fact-iter`:

```
(define n (make-register))
(define result (make-register))
```

### Step 2: Identify the operations

Identify the internal operations that get carried out
by the procedure.  All operations have the following rules:

* Inputs must come from registers
* Results must be placed into a register

One way to figure this out is to study the transition of
procedure arguments from one step to the next step.
For example, look at the evaluation steps:

```
(fact-iter 5 1)
(fact-iter 4 5)
(fact-iter 3 20)
...
```

How do the `n` and `result` values change from step-to-step?
Encode these steps as zero-argument procedures and give them names:

```
; n is a register (defined already)

(define (decrement-n)
    (n 'set! (- (n 'get) 1)))
```

**Exercise:** Write the following procedure

```
(define (product-n-result)
   <you define>
   )
```

There is one transition you're probably overlooking.  The
initial call to `(fact-iter n 1)` places a 1 into `result`.
Make that a procedure as well:

```
(define (set-result-1)
   (result 'set! 1)
   )
```

You should now have two registers and three instructions:

```
(define n (make-register))
(define result (make-register))

(decrement-n)        ; n - 1 -> n
(product-n-result)   ; n * result -> result
(set-result-1)       ; 1 -> result
```

Keep in mind: the instructions are also something that could be
built with circuits (i.e., digital adders, multipliers, etc.).

### Step 3: Instruction Sequencing

To properly carry out the calculation, these instructions must
execute in a particular order.

**Exercise:** The value of 4 has been placed into register `n`.

```
(n 'set! 4)
```

Show the precise sequence of instructions that must be carried out
to arrive at final answer of `(fact 4)`.  You are *only* allowed to
use the three instructions defined above and nothing else.

### Step 4: Control Flow

In answering the last exercise, you probably noticed that you needed
to repeat certain sequences of operations.  Moreover, you had to
make a decision about when to stop.    The concept of repetition
can be expressed by a `goto` operation.  The concept of making a
decision is expressed by a conditional `branch` operation.

**Exercise:** Take the instructions you wrote down in last exercise
and place them into the following sequence by replacing the portions
indicated by "...":

```
fact-start:
    ...   ; put instructions here
    goto-fact-test

fact-test:
    branch-fact-done-if-n-is-1
    ...  ; put instructions here
    ...
    goto-fact-test

fact-done:
    halt
```

The names `fact-start`, `fact-test`, and `fact-done` are labels.
They don't do anything.

The names `goto-fact-test` and `branch-fact-done-if-n-is-1` are
instructions that have yet to be written.  Let's do that.

First, we'll introduce a new register "PC". It represents the currently
executing instruction.

```
(define pc (make-register))
```

Next, we'll define instructions that set the PC to specific program labels

```
(define (goto-fact-test)
    (pc 'set! fact-test))

(define (branch-fact-done-if-n-is-1)
    (if (= (n 'get) 1) (pc 'set! fact-done)))
```

In these instructions, the names `fact-test` and `fact-done` are
labels yet to be defined.  Let's do that.

**Exercise:** Define lists that represent labeled blocks of instructions:

```
(define fact-start (list
    ...    ; Instructions here
    goto-fact-test
  )
)

(define fact-test (list
    branch-fact-done-if-n-is-1
    ...    ; Instructions here
    goto-fact-test
  )
)

(define fact-done (list))   ; Note: empty list
```

Fill in the ... with the proper sequence of instructions from earlier.
Important:  We are defining lists, not procedures.  Every item in the
list should be a zero-argument procedure.   Note: we are *not* calling the
procedures so don't use parentheses.
    
### Running a Program

To run instructions, define a procedure that executes forever as long as the PC register points at something:

```
(define (execute)
   (let ((instructions (pc 'get)))
       (cond ((null? instructions) 'done)
             (else 
                (pc 'set! (cdr instructions))
                ((car instructions))
                (execute)
             )
        )
    )
)
```

Try running it on your program:

```
(n 'set! 4)
(pc 'set! fact-start)
(execute)
(result 'get)
``` 

**Exercise:** Explain the weird sequencing of operations here:

```
(pc 'set! (cdr instructions))
((car instructions))         
(execute)
```

Can the order of the first two steps be interchanged?

```
((car instructions))         
(pc 'set! (cdr instructions))
(execute)
```

## Mapping a Recursive Process to Registers

Consider this as a final challenge.  Can you figure out how to encode
the following recursive procedure to a register machine?

```
(define (fact n)
    (if (= n 1)
        1
        (* n (fact (- n 1)))))
```

If you can figure this out, you're well on your way to making
programs run in reality... but that's the topic for a different course
and a different day.







































