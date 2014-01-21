(function() {
  var TYPES, log, rpr,
    __slice = [].slice;

  TYPES = require('coffeenode-types');

  log = console.log;

  rpr = (require('util')).inspect;

  this.compose = function() {
    var pedigree;
    pedigree = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return this._compose_or_assemble(pedigree, true);
  };

  this.assemble = function() {
    var pedigree;
    pedigree = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return this._compose_or_assemble(pedigree, false);
  };

  this._compose_or_assemble = function(ancestors, allow_overrides, names) {
    var MULTIMIX_NONCE_CLASS, R, ancestor, descriptor, name, seen_names, _i, _len;
    seen_names = allow_overrides ? null : {};
    MULTIMIX_NONCE_CLASS = (function() {
      function MULTIMIX_NONCE_CLASS() {}

      return MULTIMIX_NONCE_CLASS;

    })();
    R = new MULTIMIX_NONCE_CLASS();
    for (_i = 0, _len = ancestors.length; _i < _len; _i++) {
      ancestor = ancestors[_i];
      for (name in ancestor) {
        if (!allow_overrides) {
          if (seen_names[name]) {
            throw new Error("encountered duplicate name " + (rpr(name)) + "; use `compose instead of `assemble` to allow for this");
          }
          seen_names[name] = true;
        }
        descriptor = this.get_descriptor(ancestor, name);
        if (descriptor == null) {
          continue;
        }
        if ((descriptor.get != null) || (descriptor.set != null)) {
          this.set_property(MULTIMIX_NONCE_CLASS.prototype, name, descriptor.get, descriptor.set, {
            'configurable': descriptor.configurable,
            'enumerable': true
          });
        } else {
          MULTIMIX_NONCE_CLASS.prototype[name] = descriptor.value;
        }
      }
    }
    return R;
  };

  this.bundle = function(object) {
    var bound_method, descriptor, name, original_method, sub_name;
    for (name in object) {
      descriptor = this.get_descriptor(object, name);
      if (this.looks_like_a_property_descriptor(descriptor)) {
        continue;
      }
      if (TYPES.isa_function(descriptor['value'])) {
        original_method = descriptor['value'];
        bound_method = original_method.bind(object);
        object[name] = bound_method;
        for (sub_name in original_method) {
          bound_method[sub_name] = original_method[sub_name];
        }
      }
    }
    return object;
  };

  this.get = function(object, name, fallback) {
    var descriptor, error;
    if (fallback == null) {
      fallback = void 0;
    }
    try {
      descriptor = this.get_descriptor(object, name);
    } catch (_error) {
      error = _error;
      if (error['message'] == null) {
        throw error;
      }
      if (0 === error['message'].indexOf('unable to retrieve descriptor ')) {
        if (fallback !== void 0) {
          return fallback;
        }
        throw new Error("unable to find " + (rpr(name)) + " in this object");
      }
      throw error;
    }
    if (TYPES.isa_function(descriptor['value'])) {
      return object[name].bind(object);
    }
    return object[name];
  };

  this.set_property = function(target, name, getter, setter, Q) {
    var argument_count;
    argument_count = arguments.length;
    if (argument_count === 3) {
      Q = {};
      setter = void 0;
    } else if (argument_count === 4) {
      if (TYPES.isa_pod(setter)) {
        Q = setter;
        setter = void 0;
      } else {
        Q = {};
      }
    } else if (argument_count < 3 || argument_count > 5) {
      raise(new Error("expected between 3 and 5 arguments, got " + argument_count));
    }
    if (!((getter != null) || (setter != null))) {
      throw new Error("need at least a getter or a setter, got neither");
    }
    if (Q['configurable'] == null) {
      Q['configurable'] = true;
    }
    if (Q['enumerable'] == null) {
      Q['enumerable'] = true;
    }
    Q['get'] = getter != null ? getter : void 0;
    Q['set'] = setter != null ? setter : void 0;
    Object.defineProperty(target, name, Q);
    return null;
  };

  this.get_descriptor = function(x, name) {
    var error;
    try {
      return this._get_descriptor(x, name);
    } catch (_error) {
      error = _error;
      if (error['message'] == null) {
        throw error;
      }
      if (error['message'] === 'Object.getOwnPropertyDescriptor called on non-object') {
        throw new Error("unable to retrieve descriptor " + (rpr(name)) + " in this object (type " + (TYPES.type_of(x)) + ")");
      }
      throw error;
    }
    throw new Error("programming error; should never happen");
  };

  this._get_descriptor = function(x, name) {
    var R, error;
    while (true) {
      try {
        R = Object.getOwnPropertyDescriptor(x, name);
      } catch (_error) {
        error = _error;

        /* patched for compatibility with https://github.com/tvcutsem/harmony-reflect */
        if (error['message'] === 'Invalid value used as weak map key') {
          throw new Error('Object.getOwnPropertyDescriptor called on non-object');
        }
        throw Error;
      }
      if (R != null) {
        return R;
      }
      x = Object.getPrototypeOf(x);
    }
  };

  this.looks_like_a_property_descriptor = function(descriptor) {
    return (descriptor.get != null) || (descriptor.set != null);
  };

  this.is_property_name_of = function(x, name) {
    var error;
    try {
      return this.looks_like_a_property_descriptor(this.get_descriptor(x, name));
    } catch (_error) {
      error = _error;
      if (error['message'] == null) {
        throw error;
      }
      if ((error['message'].indexOf('unable to retrieve descriptor')) !== 0) {
        throw error;
      }
    }
    return false;
  };

  module.exports = this.compose(this);

}).call(this);
/****generated by https://github.com/loveencounterflow/larq****/