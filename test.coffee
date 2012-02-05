
############################################################################################################
$                         = exports ? here
_   = $._                 = {}
#-----------------------------------------------------------------------------------------------------------
log                       = console.log
multimix                  = require './multimix'

#-----------------------------------------------------------------------------------------------------------
test = ->
  x = {}
  x.move = ( meters ) ->
    log @name + " moved #{meters}m."
  x.speak = -> log "#{@name} says: 'miew'"

  y = {}
  y.speak = -> log "#{@name} says: 'yee-hah'"

  multimix.set_property y, 'random',
    get: -> log @name; return random_integer 0, 10000

  x = multimix.compose x, y
  multimix.set x, 'name', 'Sammy'

  log x
  x.move 2
  x.speak()
  log x.random
  log x.random
  log x.random

  z = {}
  z.f = ( x ) -> return x + 42
  # z.name = 'foobar'
  x = multimix.complement x, z
  log x.f 1234
  x.move 2
  x.speak()
  log x.random
  log x.random


############################################################################################################
test()










