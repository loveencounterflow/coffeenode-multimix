
############################################################################################################
$                         = exports
log                       = console.log
rpr                       = ( require 'util' ).inspect
#-----------------------------------------------------------------------------------------------------------
MULTIMIX                  = require '../implementation'

#===========================================================================================================
cat = {}

#-----------------------------------------------------------------------------------------------------------
cat.move = ( meters ) ->
  return "#{@name} has jumped #{meters}m."

#-----------------------------------------------------------------------------------------------------------
cat.speak = ->
  return "#{@name} says: 'miew'"

#-----------------------------------------------------------------------------------------------------------
MULTIMIX.set_property cat, 'cat_count', ->
  @cat_counter ?= 0
  @cat_counter += 1
  return "#{@name} has cat-counted to #{@cat_counter}"


#===========================================================================================================
horse = {}

#-----------------------------------------------------------------------------------------------------------
horse.speak = ->
  return "#{@name} says: 'yee-hah'"

#-----------------------------------------------------------------------------------------------------------
MULTIMIX.set_property horse, 'horse_count', ->
  @horse_counter ?= 0
  @horse_counter += 1
  return "#{@name} has horse-counted to #{@horse_counter}"


#===========================================================================================================
$.main = ->
  log rpr ( name for name of cat )
  log rpr ( name for name of horse )
  log rpr ( name for name of horse_cat )
  log rpr ( name for name of cat_horse )

  cat       = MULTIMIX.compose cat,        'name': 'Cat'
  horse     = MULTIMIX.compose horse,      'name': 'Horse'
  cat_horse = MULTIMIX.compose cat, horse, 'name': 'Cathorse'
  horse_cat = MULTIMIX.compose horse, cat, 'name': 'Horsecat'

  log rpr ( name for name of cat )
  log rpr ( name for name of horse )
  log rpr ( name for name of cat_horse )
  log rpr ( name for name of horse_cat )

  log '---------------------------------------'
  log cat.name
  log horse.name
  log cat_horse.name
  log horse_cat.name

  log '---------------------------------------'
  log cat.speak()
  log horse.speak()
  log cat_horse.speak()
  log horse_cat.speak()

  log '---------------------------------------'
  log cat.cat_count
  log horse.cat_count
  log cat_horse.cat_count
  log horse_cat.cat_count

  log '---------------------------------------'
  log cat.horse_count
  log horse.horse_count
  log cat_horse.horse_count
  log horse_cat.horse_count

  log '---------------------------------------'
  log cat.horse_count
  log horse.horse_count
  log cat_horse.horse_count
  log horse_cat.horse_count


  # log x
  # x.move 2
  # x.speak()
  # echo x.random
  # echo x.random
  # echo x.random

  # z = {}
  # z.f = ( x ) -> return x + 42
  # # z.name = 'foobar'
  # x = complement x, z
  # log x.f 1234
  # x.move 2
  # x.speak()
  # echo x.random
  # echo x.random









