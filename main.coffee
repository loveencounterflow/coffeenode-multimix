

############################################################################################################
$                         = exports
log                       = console.log
xrpr                      = require 'COFFEENODE/ENGINE/xrpr'
#-----------------------------------------------------------------------------------------------------------
Σ                         = require 'COFFEENODE/Σ/implementation'
TYPES                     = require 'COFFEENODE/TYPES/implementation'

#===========================================================================================================
# SHINY MIXING STUFF
#-----------------------------------------------------------------------------------------------------------
$.compose   = ( pedigree... ) -> return @_compose_or_assemble pedigree, true
$.assemble  = ( pedigree... ) -> return @_compose_or_assemble pedigree, false

# #-----------------------------------------------------------------------------------------------------------
# $._compose_or_assemble = ( pedigree, allow_overrides, names ) ->
#   progenitor  = {}
#   seen_names  = if allow_overrides then null else {}
#   #.........................................................................................................
#   for ancestor in pedigree
#     #.......................................................................................................
#     for name of ancestor
#       #.....................................................................................................
#       if not allow_overrides
#         if seen_names[ name ]
#           bye "encountered duplicate name #{xrpr name}; use ``compose`` instead of " + \
#             "``assemble`` to allow for this"
#         seen_names[ name ] = true
#       #.....................................................................................................
#       descriptor = @get_descriptor ancestor, name
#       continue unless descriptor?
#       #.....................................................................................................
#       if descriptor.get? or descriptor.set?
#         @set_property progenitor, name,
#           descriptor.get
#           descriptor.set
#           'configurable': descriptor.configurable
#           'enumerable':   yes
#       #.....................................................................................................
#       else
#         if isa_function descriptor[ 'value' ]
#           progenitor[ name ] = ancestor[ name ].bind progenitor
#         else
#           progenitor[ name ] = ancestor[ name ]
#   #.........................................................................................................
#   # return @bundle new ( make_class progenitor )() # what make_class good for?
#   return @bundle progenitor

#-----------------------------------------------------------------------------------------------------------
$._compose_or_assemble = ( ancestors, allow_overrides, names ) ->
  # log '¢7z5', ancestors
  seen_names  = if allow_overrides then null else {}
  #.........................................................................................................
  class MULTIMIX_NONCE_CLASS
  R = new MULTIMIX_NONCE_CLASS()
  #.........................................................................................................
  for ancestor in ancestors
    # log '¢9i7', ancestor
    for name of ancestor
      # log '¢9i8', name
      #.....................................................................................................
      if not allow_overrides
        if seen_names[ name ]
          bye "encountered duplicate name #{xrpr name}; use ``compose`` instead of " + \
            "``assemble`` to allow for this"
        seen_names[ name ] = true
      #.....................................................................................................
      descriptor = @get_descriptor ancestor, name
      continue unless descriptor?
      #.....................................................................................................
      if descriptor.get? or descriptor.set?
        @set_property MULTIMIX_NONCE_CLASS::, name,
          descriptor.get
          descriptor.set
          'configurable': descriptor.configurable
          'enumerable':   yes
      #.....................................................................................................
      else
        MULTIMIX_NONCE_CLASS::[ name ] = descriptor.value
  #.........................................................................................................
  return R



# #-----------------------------------------------------------------------------------------------------------
# make_class = ( map ) ->
#   R = ->
#   R:: = map
#   return R

#-----------------------------------------------------------------------------------------------------------
$.bundle = ( object ) ->
  """Given an ``object`` which may contain named methods, iterate over all methods and bind each one to
  ``object``, thereby making them 'detachable' (i.e. you can then pass around ``object.method`` without
  having to worry about the value of ``@`` / ``this`` inside the method)."""
  for name of object
    descriptor = @get_descriptor object, name
    continue if @looks_like_a_property_descriptor descriptor
    #.......................................................................................................
    if isa_function descriptor[ 'value' ]
      original_method = descriptor[ 'value' ]
      bound_method    = original_method.bind object
      object[ name ]  = bound_method
      #.....................................................................................................
      for sub_name of original_method
        bound_method[ sub_name ]  = original_method[ sub_name ]
  #.........................................................................................................
  return object

# #-----------------------------------------------------------------------------------------------------------
# $.set = ( x, name, value ) ->
#   """Experimental; sets a value on a mixin without producing a new instance (as ``compose`` would)."""
#   if x::
#     delete x[ name ] if x[ name ]?
#     x::[ name ] = value
#   else
#     x[ name ] = value
#   return null

#-----------------------------------------------------------------------------------------------------------
$.get = ( object, name, fallback = undefined ) ->
  #.........................................................................................................
  try
    descriptor = @get_descriptor object, name
  #.........................................................................................................
  catch error
    throw error unless error[ 'message' ]?
    if 0 == error[ 'message' ].indexOf 'unable to retrieve descriptor '
      return fallback if fallback isnt undefined
      throw new Error "unable to find #{xrpr name} in this object"
    throw error
  #.........................................................................................................
  return object[ name ].bind object if isa_function descriptor[ 'value' ]
  return object[ name ]

#...........................................................................................................
# Σ.listen '?COFFEENODE/Δ/get/*', ( signal, object, name ) ->
#   Σ.update signal, $.get object, name

#===========================================================================================================
# PROPER PROPERTY APPROPRIATION
#-----------------------------------------------------------------------------------------------------------
$.set_property = ( target, name, getter, setter, Q ) ->
  # ( require 'COFFEENODE/ENGINE/locator-of-caller' ).report
  # log '898e8t798t', xrpr ( TYPES.type_of a for a in arguments )
  #.........................................................................................................
  argument_count = arguments.length
  if argument_count == 3
    Q       = {}
    setter  = undefined
  else if argument_count == 4
    if isa_pod setter
      Q       = setter
      setter  = undefined
    else
      Q       = {}
  else if argument_count < 3 or argument_count > 5
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
    throw error unless error[ 'message' ]?
    if error[ 'message' ] == 'Object.getOwnPropertyDescriptor called on non-object'
      throw new Error "unable to retrieve descriptor #{xrpr name} in this object (type #{TYPES.type_of x})"
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
    throw error unless error[ 'message' ]?
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

