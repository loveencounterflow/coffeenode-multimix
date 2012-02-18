

.. image:: https://github.com/loveencounterflow/MULTIMIX/raw/master/artwork/multimix-small.png
   :align: left

**MultiMix—Swearing at prototypes so you don't have to.**



🚀 TL;DR
============================================================================================================

Classes and prototypes are sooooo 1990s. Mixins FTW!


💀 WTF?
============================================================================================================

● So you want to mix & match your library code / your data objects but are lost grappling with JavaScript
prototype red tape? ● You just discovered the convenience of CoffeeScript classes only to find out they're
not compatible with those shiny `ES4 properties`_? ● You've tried all those many many libraries out there
that promise to deliver traits / mixins but find yourself dancing with the API wolves instead? ● Tried to
fix a bug in or add a feature to some traits / mixins library but got intimidated by hundreds of LOC? ●
Tried to roll your own in an hour only to find out late at night that the blogpost explaining the subtleties
of JavaScript prototypes got the details wrong? ● Got a working library but find it tedious to use? Like,
you have to start with a plain object, which you then use as argument to a traits casting operation, which
yields a traits object that you compose with other traits objects, which gives you a class that you have to
instantiate—but which you cannot use for further composition (you'd have to keep that traits incarnation
around to do that). 💥OMFG💥. Life can be so much simpler.

.. _ES4 properties: https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperty


👍 FTW!
============================================================================================================

Mixins *can* be easy to use. They're also not *too* hard to implement in JavaScript (the core of this
library is 30 lines of beautiful CoffeeScript). Don't bother about the classes / instances distinction;
MultiMix abstracts that away from you.

MultiMix gives you:

* derp-eezy, transparent creation of instances—no fiddling with 'classes' or 'prototypes';

* library composition from plain old objects;

* ad-libitum mixing of instantiated and raw PODs in any compositional call;

* respectful treatment of `ES4 properties`_;

* two sensible methods to assemble a new object with new state from one or more source objects, enshrined as
  ``compose`` and ``assemble``;

.. * all methods are explicitly bound to their o

* hidden goodies—read on to learn more!

The usual ill-conceived / conventionalized / silly OOP example where we pretend that objects in the computer
quack and wack like a duck, a car, or a cat (just here 'coz you probably already got used to this level of
BS, definitely *not* meant as a style recommendation)::

  #---------------------------------------------------------------------------------------------------------
  multimix            = require 'multimix'
  compose             = multimix.compose
  assemble            = multimix.assemble
  set_property        = multimix.set_property

  #---------------------------------------------------------------------------------------------------------
  cat       = {}
  cat.move  = ( meters )  -> return "#{@name} has jumped #{meters}m."
  cat.speak =             -> return "#{@name} says: 'miew'"

  #.........................................................................................................
  set_property cat, 'cat_count',
    get: ->
      @cat_counter ?= 0
      @cat_counter += 1
      return "#{@name} has cat-counted to #{@cat_counter}"

  #---------------------------------------------------------------------------------------------------------
  horse       = {}
  horse.speak = -> return "#{@name} says: 'yee-hah'"

  #.........................................................................................................
  set_property horse, 'horse_count',
    get: ->
      @horse_counter ?= 0
      @horse_counter += 1
      return "#{@name} has horse-counted to #{@horse_counter}"

  #---------------------------------------------------------------------------------------------------------
  cat       = compose cat,        'name': 'Cat'
  horse     = compose horse,      'name': 'Horse'
  cat_horse = compose cat, horse, 'name': 'Cathorse'
  horse_cat = compose horse, cat, 'name': 'Horsecat'

  #---------------------------------------------------------------------------------------------------------
  log = console.log
  log '---------------------------------------'       # ---------------------------------------
  log cat.name                                        # Cat
  log horse.name                                      # Horse
  log cat_horse.name                                  # Cathorse
  log horse_cat.name                                  # Horsecat
  log '---------------------------------------'       # ---------------------------------------
  log cat.speak()                                     # Cat says: 'miew'
  log horse.speak()                                   # Horse says: 'yee-hah'
  log cat_horse.speak()                               # Cathorse says: 'yee-hah'
  log horse_cat.speak()                               # Horsecat says: 'miew'
  log '---------------------------------------'       # ---------------------------------------
  log cat.cat_count                                   # Cat has cat-counted to 1
  log horse.cat_count                                 # undefined
  log cat_horse.cat_count                             # Cathorse has cat-counted to 1
  log horse_cat.cat_count                             # Horsecat has cat-counted to 1
  log '---------------------------------------'       # ---------------------------------------
  log cat.horse_count                                 # undefined
  log horse.horse_count                               # Horse has horse-counted to 1
  log cat_horse.horse_count                           # Cathorse has horse-counted to 1
  log horse_cat.horse_count                           # Horsecat has horse-counted to 1
  log '---------------------------------------'       # ---------------------------------------
  log cat.horse_count                                 # undefined
  log horse.horse_count                               # Horse has horse-counted to 2
  log cat_horse.horse_count                           # Cathorse has horse-counted to 2
  log horse_cat.horse_count                           # Horsecat has horse-counted to 2

What happens here is that

* you start composing functionality by defining values, methods, and properties on plain old objects (i call
  them PODs)


* As soon as you have at least one library, you can call ``compose`` or ``assemble`` with any number of
  objects as arguments. In the above example, we use inline PODs to define ad-hoc instance attributes.

* By calling ``assemble``, you signal that you want to assemble a library from disjunct, orthogonal
  progenitors—none of the participating objects are allowed to have duplicate names. As a consequence, the
  order of participators in the call is irrelevant for name resolution.

* By calling ``compose``, you signal that you want to assemble a library from possibly overlapping
  namespaces. Name resolution happens from the right to the left, which i for one find intuitive. You can
  always equivalently compose in one single step or in several steps (adding building blocks in a piecemeal
  fashion—in other words, ``d = compose a, b, c`` is equivalent to ``d = compose a, b; d = compose d, c``;
  and ``d[ name ]`` will be resolved as ``c[ name ]`` → ``b[ name ]`` → ``a[ name ]`` until there's a hit).

There's conceivably a third mode of composition, which is, however, not implemented: one that works like a
'merge', adding names and methods only where there is no such name present up the chain of inheritance. Here
i wait for a good use case before i implement anything. If that ever happens, i guess i would call such a
method ``complement``.

That's it as for inheritance—no less, no more. You probably wouldn't want to call MultiMix a traits library
for the complete lack of name resolution management, but then you can easily do that by manually aliasing
conflicting names. I'm currently mulling over introducing some kind of ``super``; i'll wait for a good use
case to roll around so i can better tell what bridge to cross.


EVEN MORE 🐮 HOLY COW
============================================================================================================

❁**Walking up the prototype chain so you don't have to**❁ As if this wasn't enough to make you lean back,
close your eyes, inhale deeply and smile blithely for all the goodness that is MultiMix, here's yet another
thingie related to inheritance / building better libraries: a JavaScript property creator and discovery
method! YAY!

**WTF??** Yes, JavaScript as of ES4 does have properties similar to the ones you might know from languages
like Python. They sure are a less-well known and underemployed part of the language, and, this being
JavaScript, can be confusing to work with and certainly are circumlocutory to boot. The standard way to
define them looks like ::

  Object.defineProperty x, 'foo',
    enumerable:   yes
    get:          -> return 42      # imagine a very meaningful computation here
    set:          ( value ) -> ...  # setting a value can have side effects now

Should you forget to explicitly set ``enumerable`` to ``true`` you will be surprised to just have created a
property that won't get listed when doing a ``for name, value of x`` loop but can still be accessed as
``x.foo``, which makes it feel like—? a stealth / zombie / camouflage / phantom attribute?—whatever kind of
identity disorder is your favorite. Yes, design by comittee once more, but hey, you never expected anything
else, right?

Also, when you access ``x.foo``, of course what you get back is whatever the getter returns to you (that's
what properties are there for), not the getter itself. So how can you test whether ``x.foo`` is an ordinary
attribute or a property (that's very important to know when copying attributes—if you don't pay attention to
this detail you'll turn dynamic properties into static attributes (which is sometimes exactly right to be
sure (more braces, anyone?)))?

Well, JavaScript offers ``Object.getOwnPropertyDescriptor x, name`` for retrieving attribute details[#]_. Of
course, as the name implies, this method will *not* walk up the property chain, so you can still end up with
confusing results.

.. [#] for *any* kind of attributes, which the language designers chose to dub 'properties'. When *i* say
  'properties', i always mean 'properties proper' (yes), that is, what is called properties in Python.
  These things are distinguished by the presence of so-called 'accessors' in the descriptor, namely,
  ``get`` and ``set``.

**FTW!** MULTIMIX provides three methods for working with descriptors and properties: ``set_property``,
``is_property_name_of``, and ``get_descriptor``. They are convenient to use::

  set_property x, 'seconds', -> return ( new Date() ) / 1000
  log x.seconds
  log is_property_name_of x, 'seconds' # true
  log get_descriptor x, 'seconds' #

In this case, the property descriptor will look like this::

  { get: [Function],
    set: undefined,
    enumerable: true,
    configurable: true }

``set_property`` takes three to five arguments: the object to set the property on, a non-empty text for the
property name, a getter and a setter (which are both optional, but cannot be both omitted); as a final
argument, a POD with the options ``configurable`` and ``enumerable`` (with their standard meanings, but both
defaulting to ``true``) may be passed in.

``is_property_name_of`` takes exactly two arguments: any kind of value ``x`` and a ``name``, which again
must be a non-empty text. In contradistinction to ``getOwnPropertyDescriptor``, the method will start at
``x`` itself and then walk up the prototype chain, so you'll get an authoritative answer to your question
rather than an tentative one. Also, the method accepts *any* kind of value for ``x`` (except ``undefined``,
which is an abomination), unlike its JavaScript relative which spits at ``null``, ``false``, numbers and
other untervalues.

``get_descriptor`` takes the same arguments as is_property_name_of and returns a POD that may have the
following members: ``get``, ``set``, ``enumerable``, ``configurable``, ``value``, ``writable``.















