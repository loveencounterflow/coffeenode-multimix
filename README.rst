

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
tired of having to dance with the API wolves just to get those things rolling? You tried to fix a bug in a
library but got intimidated by hundreds of LOC?

.. _ES4 properties: https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperty


FTW!
============================================================================================================

Mixins don't have to be hard to use. They're also basically not hard to implement in JavaScript. You don't
have to bother for the classes / instances distinction when a library can abstract that away from you.

MultiMix gives you:

* mixin creation from plain old objects;

* transparent creation of instances;

* two sensible methods to assemble a new object with new state from one or more source objects.

MultiMix exports two main methods: ``compose`` and ``complement``, which you call like::

  d = compose a, b, c

where ``a, b, c`` is called the *pedigree* of ``d``. The rule of inheritance is intuitive: objects that come
later in the call override namesake members of earlier objects (at least that's what i find intuitive).

The sole difference between ``compose`` and ``complement`` is that with ``complement``, overrides are never
permitted (and cause an error to be thrown on creation time), so the ordring of objects in the pedigree does
not matter (under the hood, the name lookup still progresses from right to left, so there might be a slight
performance penalty if you often need a deeply- buried attribute).

That's it—no less, no more. You probably wouldn't want to call MultiMix a traits library for the complete
lack of name resolution management, but then you can easily do that by manually aliasing conflicting names.










