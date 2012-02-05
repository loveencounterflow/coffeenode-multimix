
############################################################################################################
$                         = exports ? here
_   = $._                 = {}
#-----------------------------------------------------------------------------------------------------------


SORRY this code should work but doesn't after a little refactoring. I'll be back.

Also, must define / replace ``bye``.

#-----------------------------------------------------------------------------------------------------------
make_class = ( map ) ->
  R = ->
  R:: = map
  return R

#-----------------------------------------------------------------------------------------------------------
$.compose = ( pedigree... ) ->
  # validate_argument_count arguments, 'min': 1 # this is from the FlowMatic library
  return _.compose pedigree, true

#-----------------------------------------------------------------------------------------------------------
$.complement = ( pedigree... ) ->
  # validate_argument_count arguments, 'min': 1 # this is from the FlowMatic library
  return _.compose pedigree, false

#-----------------------------------------------------------------------------------------------------------
_.compose = ( pedigree, allow_overrides ) ->
  progenitor  = {}
  seen_names  = if allow_overrides then null else {}
  #.........................................................................................................
  for idx in [ 0 ... pedigree.length ]
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
$.set_property = ( target, name, Q ) ->
  # Q[ 'enumerable' ] ?= yes
  Object.defineProperty target, name, Q
  return null

#-----------------------------------------------------------------------------------------------------------
$.set = ( x, name, value ) ->
  """Experimental; sets a value on a mixin without producing a new instance (as ``compose`` would)."""
  ( Object.getPrototypeOf x )[ name ] = value

