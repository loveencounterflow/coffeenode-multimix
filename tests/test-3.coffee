

A = {}
A.f = -> return @g() * 2
A.g = -> return 2
A.h = -> return 100

B = {}
B.g = -> return 3

C = compose A, B
log C.f()

log C
log C::
log C.f
log C.g

C = compose C, g: -> return @h()
log C.f()
C = compose C
log gold C.h

D = {}
D.h = -> return 1000

E = compose C, D

log plum E.f()
log plum E.f
log green E.g
log E.h
log E.h()

