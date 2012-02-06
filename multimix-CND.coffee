

# STATUS: tests HAVE passed


############################################################################################################
$                         = exports ? here
self                      = ( fetch '/COFFEENODE/flow/library/barista' ).foo __filename
log                       = self.log
log_ruler                 = self.log_ruler
stop                      = self.STOP
_   = $._                 = {}
$.$ = $$                  = {}
#-----------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------
make_class = ( map ) ->
  R = ->
  R:: = map
  return R

#-----------------------------------------------------------------------------------------------------------
compose = ( pedigree... ) ->
  validate_argument_count arguments, 'min': 1
  return _.compose pedigree, true

#-----------------------------------------------------------------------------------------------------------
complement = ( pedigree... ) ->
  validate_argument_count arguments, 'min': 1
  return _.compose pedigree, false

#-----------------------------------------------------------------------------------------------------------
_.compose = ( pedigree, allow_overrides ) ->
  progenitor  = {}
  seen_names  = if allow_overrides then null else {}
  #.........................................................................................................
  for idx in [ 0 ... length_of pedigree ]
    ancestor = pedigree[ idx ]
    ancestor = ancestor[ '~MIXIN/%self' ] ? ancestor
    #.......................................................................................................
    for name in Object.keys ancestor
      #.....................................................................................................
      if not allow_overrides
        if seen_names[ name ]
          bye "encountered duplicate name #{rpr name}; use ``compose`` instead of ``complement`` " + \
            "to allow for this"
        seen_names[ name ] = true
      #.....................................................................................................
      descriptor = Object.getOwnPropertyDescriptor ancestor, name
      #.....................................................................................................
      if descriptor.get? or descriptor.set?
        set_property progenitor, name,
          get: descriptor.get
          set: descriptor.set
      #.....................................................................................................
      else
        progenitor[ name ] = ancestor[ name ]
  #.........................................................................................................
  progenitor[ '~MIXIN/%self' ] = progenitor
  return new ( make_class progenitor )()

#-----------------------------------------------------------------------------------------------------------
set = ( x, name, value ) ->
  ( Object.getPrototypeOf x )[ name ] = value


############################################################################################################
$.set_property = ( target, name, Q ) ->
  """Like ``Object.defineProperty``, but ``enumerable`` defaults to ``yes``."""
  Q[ 'enumerable' ] ?= yes
  Object.defineProperty target, name, Q
  return null

#===========================================================================================================
cat = {}

#-----------------------------------------------------------------------------------------------------------
cat.move = ( meters ) ->
  return "#{@name} has jumped #{meters}m."

#-----------------------------------------------------------------------------------------------------------
cat.speak = ->
  return "#{@name} says: 'miew'"

#-----------------------------------------------------------------------------------------------------------
set_property cat, 'cat_count',
  get: ->
    @cat_counter ?= 0
    @cat_counter += 1
    return "#{@name} has cat-counted to #{@cat_counter}"


#===========================================================================================================
horse = {}

#-----------------------------------------------------------------------------------------------------------
horse.speak = ->
  return "#{@name} says: 'yee-hah'"

#-----------------------------------------------------------------------------------------------------------
set_property horse, 'horse_count',
  get: ->
    @horse_counter ?= 0
    @horse_counter += 1
    return "#{@name} has horse-counted to #{@horse_counter}"


#===========================================================================================================
cat       = compose cat,        'name': 'Cat'
horse     = compose horse,      'name': 'Horse'
cat_horse = compose cat, horse, 'name': 'Cathorse'
horse_cat = compose horse, cat, 'name': 'Horsecat'

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













