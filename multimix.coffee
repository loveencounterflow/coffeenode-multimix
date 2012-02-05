
############################################################################################################
$                         = exports ? here
self                      = ( fetch 'library/barista' ).foo __filename
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
    log_ruler()
    ancestor = pedigree[ idx ]
    ancestor = ancestor[ '~MIXIN/%self' ] ? ancestor
    #.......................................................................................................
    # for name of ancestor
      # continue unless descriptor?
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


x = {}
x.move = ( meters ) ->
  echo green @name + " moved #{meters}m."
x.speak = -> echo red "#{@name} says: 'miew'"

y = {}
y.speak = -> echo red "#{@name} says: 'yee-hah'"

set_property y, 'random',
  get: -> log cyan @name; return random_integer 0, 10000

x = compose x, y
set x, 'name', 'Sammy'

log x
x.move 2
x.speak()
echo x.random
echo x.random
echo x.random

z = {}
z.f = ( x ) -> return x + 42
# z.name = 'foobar'
x = complement x, z
log x.f 1234
x.move 2
x.speak()
echo x.random
echo x.random













