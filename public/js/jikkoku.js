/* root namespace */

'use strict';

var jikkoku = jikkoku || {};

// なぜかnameSpaceだと上手く行かない...(予約語？)
jikkoku.namespace = function (pkgName) {

  var parts = pkgName.split('.');
  var parent = jikkoku;

  if (parts[0] === 'jikkoku') {
    parts = parts.slice(1);
  }

  for (var i = 0; i < parts.length; i++) {
    if (typeof parent[parts[i]] === "undefined") {
      parent[parts[i]] = {};
    }
    parent = parent[parts[i]];
  }

};

jikkoku.inherit = function (base, child) {
  child.prototype = Object.create(base.prototype);
  child.prototype.constructor = child;
};

jikkoku.mixin = function (trait, consume) {
  Object.keys(trait).forEach(function (element) {
    consume.prototype[element] = trait[element];
  });
};

