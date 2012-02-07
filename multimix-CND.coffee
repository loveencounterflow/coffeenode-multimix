

"""

**NB** This module is intended to be used in the context of CoffeeNode (NYSE: CND), being the foundation
environment for FlowMatic_. In order to get a working copy of this code that has no dependencies (except for
CoffeeScript), head over to `multimix.coffee`_.

.. _FlowMatic:        https:://github.com/loveencounterflow/FLOWMATIC
.. _multimix.coffee:  https://github.com/loveencounterflow/MULTIMIX/raw/master/multimix.coffee

"""


############################################################################################################
# Don't fret over the details of these lines; their days are pretty much counted:
$                         = exports ? here
self                      = ( fetch '/COFFEENODE/flow/library/barista' ).foo __filename
log                       = self.log
log_ruler                 = self.log_ruler
stop                      = self.STOP
_   = $._                 = {} # this is used to define private members of the library
$$  = $.$                 = {} # this is used to define global names
#-----------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------
make_class = ( map ) ->
  R = ->
  R:: = map
  return R

#-----------------------------------------------------------------------------------------------------------
$$.compose = ( pedigree... ) ->
  validate_argument_count arguments, 'min': 1
  return _.compose pedigree, true

#-----------------------------------------------------------------------------------------------------------
$$.assemble = ( pedigree... ) ->
  validate_argument_count arguments, 'min': 1
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
          bye "encountered duplicate name #{rpr name}; use ``compose`` instead of " + \
            "``assemble`` to allow for this"
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
$.set = ( x, name, value ) ->
  """Experimental; sets a value on a mixin without producing a new instance (as ``compose`` would)."""
  ( Object.getPrototypeOf x )[ name ] = value


