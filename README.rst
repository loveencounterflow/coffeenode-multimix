

.. image:: https://github.com/loveencounterflow/MULTIMIX/raw/master/artwork/multimix-small.png
   :align: left



TL;DR
============================================================================================================

Classes and prototypes are sooooo 1990s. Mixins FTW!


WTF?
============================================================================================================

So you want to mix & match your library code / your data objects and are fiddling with JavaScript prototype
red tape? You just discovered the convenience of CoffeeScript classes only to find out they're not
compatible with those shiny `ES4 properties`_? You've tried all those many many libraries out there that
promise to deliver traits / mixins but you got tangled up in the complexities of actually using them and
tired of having to dance with the API wolves just to get those things rolling? You tried to fix a bug in
another mixins/traits library but got intimidated by hundreds of LOC? You tried to roll your own in an hour
only to find that at the end of the day you find that the blogpost that explained to you how JavaScript
prototypes work got it all wrong? Which you only discover upon scrolling down all the way to comment #108?

.. _ES4 properties: https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperty


FTW!
============================================================================================================

Mixins don't have to be hard to use. They're also basically not hard to implement in JavaScript (the core of
this library is 28 lines of beautiful CoffeeScript). As a user, you don't have to bother (much) for the
classes / instances distinction when a library can abstract that away from you; some libraries want you to
make plain objects, which you cast as traits, which you then compose, which you then instantiate, and which
you then cannot use for further composition (you'd have to keep that traits incarnation around to do that).

MultiMix gives you:

* mixin creation from plain old objects;

* transparent creation of instances;

* ad-libitum mixing of instantiated and raw PODs in any compositional call;

* respectful treatment of `ES4 properties`_;

* two sensible methods to assemble a new object with new state from one or more source objects, enshrined as
  ``compose`` and ``assemble``::

  cat       = {}
  cat.move  = ( meters )  -> return "#{@name} has jumped #{meters}m."
  cat.speak =             -> return "#{@name} says: 'miew'"

  set_property cat, 'cat_count',
    get: ->
      @cat_counter ?= 0
      @cat_counter += 1
      return "#{@name} has cat-counted to #{@cat_counter}"

  horse       = {}
  horse.speak = -> return "#{@name} says: 'yee-hah'"

  set_property horse, 'horse_count',
    get: ->
      @horse_counter ?= 0
      @horse_counter += 1
      return "#{@name} has horse-counted to #{@horse_counter}"

  # The first two steps instantiate and set instance attributes by composing with an ad-hoc POD thrown into
  # the mix; this is of course not required. You will need to to say at least ``compose cat`` or ``assemble
  # cat`` (eek) if any cat method makes use of a ``@<name>`` reference—otherwise that step is not necessary:
  cat       = compose cat,        'name': 'Cat'       #
  horse     = compose horse,      'name': 'Horse'

  cat_horse = compose cat, horse, 'name': 'Cathorse'
  horse_cat = compose horse, cat, 'name': 'Horsecat'

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

* you start composing library functionality (that's what i do—as the example shows, MultiMix lends itself as
  easily to doing the walking, quaking OOP style you love and i abhorr) by defining values, methods, and
  properties on plain old objects (i call them PODs) (when i define a library, i typically make ``$``
  equal ``module.exports`` and have one library per module; since i don't want to have an object definition
  that is all indented hundreds of lines down the file, i rather repeat ``$.<name> =`` all the time. Which
  is also handy because there is usually one public, validating part to each method and one private part
  which does the real work and is bound to ``$._``. But i digress—just sayin' in what kind of slum this kid
  grew up).

* As soon as you have at least one library, you can call ``compose`` or ``complement`` with the object(s) as
  arguments. Yes, you *must* do that if any part of it refers to any ``@<name>`` thingie, otherwise
  JavaScript's magical ``this`` will not work the way you expected (yeah, this sounds like you still have to
  instantiate, but i don't see any way to avoid that in this context).

* When you call ``assemble``, you signal that you want to assemble a library from disjunct, orthogonal
  originators—none of the participating objects are allowed to have duplicate names. As a consequence, the
  order of participators in the call is irrelevant for name resolution.

* When you call ``compose``, you signal that you want to assemble a library from possibly overlapping
  namespaces. Name resolution happens from the right to the left, which is intuitive: since you can always
  compose in one single step or in several steps, adding building blocks in a piecemeal fashion, it is
  clear that most people would expect names from later libraries to prevail over names from earlier
  libraries, which is why i made it so that ``d = compose a, b, c`` is equivalent to ``d = compose a, b; d =
  compose d, c``. It also meshes well with what you would expect in weird chimera experiments: A cathorse is
  first and foremost a horse, so it says 'yee-hah', not 'meow'. Anyone with a secret genetics lab in their
  backyards will tell you this is indeed so, and that you must ``compose cat, horse`` to achieve this.

There's conceivably a third mode of composition, which is, however, not implemented: one that works like a
'merge', adding names and methods only where there is no such name present up the chain of inheritance. Here
i wait for a good use case before i implement anything. If that ever happens, i guess i would call such a
method ``complement``.

That's it—no less, no more. You probably wouldn't want to call MultiMix a traits library for the complete
lack of name resolution management, but then you can easily do that by manually aliasing conflicting names.
I'm currently mulling over introducing some kind of ``super``; i'll wait for a good use case to roll around
so i can better tell what bridge to cross.


































