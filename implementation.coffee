

############################################################################################################
$                         = exports
log                       = console.log
rpr                       = ( require 'util' ).inspect
#-----------------------------------------------------------------------------------------------------------


#===========================================================================================================
# SHINY MIXING STUFF
#-----------------------------------------------------------------------------------------------------------
$.compose   = ( pedigree... ) -> return @_compose_or_assemble pedigree, true
$.assemble  = ( pedigree... ) -> return @_compose_or_assemble pedigree, false

#-----------------------------------------------------------------------------------------------------------
$._compose_or_assemble = ( pedigree, allow_overrides ) ->
  progenitor           = {}
  seen_names  = if allow_overrides then null else {}
  #.........................................................................................................
  for ancestor in pedigree
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
        @set_property progenitor, name,
          descriptor.get
          descriptor.set
          'configurable': descriptor.configurable
          'enumerable':   descriptor.enumerable
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

#-----------------------------------------------------------------------------------------------------------
make_class = ( map ) ->
  R = ->
  R:: = map
  return R

#===========================================================================================================
# PROPER PROPERTY APPROPRIATION
#-----------------------------------------------------------------------------------------------------------
$.set_property = ( target, name, getter, setter, Q ) ->
  #.........................................................................................................
  argument_count = arguments.length
  if argument_count == 3
    Q       = {}
    setter  = undefined
  else if argument_count == 4 and isa_pod setter
    Q       = setter
    setter  = undefined
  else if argument_count > 5
    raise new Error "expected between 3 and 5 arguments, got #{argument_count}"
  #.........................................................................................................
  unless getter? or setter? then bye "need at least a getter or a setter, got neither"
  #.........................................................................................................
  Q[ 'configurable' ]  ?= yes
  Q[ 'enumerable'   ]  ?= yes
  Q[ 'get'          ]   = getter ? undefined
  Q[ 'set'          ]   = setter ? undefined
  #.........................................................................................................
  Object.defineProperty target, name, Q
  return null

#-----------------------------------------------------------------------------------------------------------
$.get_descriptor = ( x, name ) ->
  #.........................................................................................................
  try
    return @_get_descriptor x, name
  catch error
    if error[ 'message' ] == 'Object.getOwnPropertyDescriptor called on non-object'
      throw new Error "unable to retrieve descriptor #{rpr name} in this object (type #{type_of x})"
    throw error
  #.........................................................................................................
  bye "programming error; should never happen"

#...........................................................................................................
$._get_descriptor = ( x, name ) ->
  loop
    R = Object.getOwnPropertyDescriptor x, name
    return R if R?
    x = Object.getPrototypeOf x

#-----------------------------------------------------------------------------------------------------------
$.looks_like_a_property_descriptor = ( descriptor ) ->
  return descriptor.get? or descriptor.set?

#-----------------------------------------------------------------------------------------------------------
$.is_property_name_of = ( x, name ) ->
  """Given any kind of value ``x`` and a ``name``, return whether ``name`` is the name of a property (in the
  narrow sense) of ``x`` (i.e. whether its property descriptor has either ``get`` or ``set`` defined). This
  method will walk up the prototype chain of any value given (which means it works e.g. for objects composed
  with the MULTIMIX library) and even accepts such values as ``null`` and ``false`` (which are 'non-objects'
  or 'primitive' values in JavaScript)."""
  #.........................................................................................................
  try
    return @looks_like_a_property_descriptor @get_descriptor x, name
  #.........................................................................................................
  catch error
    throw error unless ( error[ 'message' ].indexOf 'unable to retrieve descriptor' ) == 0
  #.........................................................................................................
  return false

#===========================================================================================================
# HELPERS
#-----------------------------------------------------------------------------------------------------------
isa_pod       = ( x ) -> return ( Object.prototype.toString.call x ) == '[object Object]'
isa_function  = ( x ) -> return ( Object.prototype.toString.call x ) == '[object Function]'

# module.exports = $.compose $

# log $._compose_or_assemble
# log Object.keys $

