c =
  helo: 'c'
  foo:  'c'

d =
  helo: 'd'
  world: 'd'

e =
  world: 'e'

f = compose c, d
g = compose f, e

log 'c', Object.keys c
log 'd', Object.keys d
log 'e', Object.keys e
log 'f', Object.keys f
log 'g', Object.keys g

log()
log 'c', facets_of c
log 'd', facets_of d
log 'e', facets_of e
log 'f', facets_of f
log 'g', facets_of g

log 'c', names_of c
log 'd', names_of d
log 'e', names_of e
log 'f', names_of f
log 'g', names_of g

log()
log 'c', length_of c
log 'd', length_of d
log 'e', length_of e
log 'f', length_of f
log 'g', length_of g

log()
log 'c', truth ( Object.getOwnPropertyDescriptor c, 'helo' )?
log 'd', truth ( Object.getOwnPropertyDescriptor d, 'helo' )?
log 'e', truth ( Object.getOwnPropertyDescriptor e, 'helo' )?
log 'f', truth ( Object.getOwnPropertyDescriptor f, 'helo' )?
log 'g', truth ( Object.getOwnPropertyDescriptor g, 'helo' )?
