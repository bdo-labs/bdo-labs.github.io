(function outer(modules, cache, entries){

  /**
   * Global
   */

  var global = (function(){ return this; })();

  /**
   * Require `name`.
   *
   * @param {String} name
   * @param {Boolean} jumped
   * @api public
   */

  function require(name, jumped){
    if (cache[name]) return cache[name].exports;
    if (modules[name]) return call(name, require);
    throw new Error('cannot find module "' + name + '"');
  }

  /**
   * Call module `id` and cache it.
   *
   * @param {Number} id
   * @param {Function} require
   * @return {Function}
   * @api private
   */

  function call(id, require){
    var m = cache[id] = { exports: {} };
    var mod = modules[id];
    var name = mod[2];
    var fn = mod[0];

    fn.call(m.exports, function(req){
      var dep = modules[id][1][req];
      return require(dep ? dep : req);
    }, m, m.exports, outer, modules, cache, entries);

    // expose as `name`.
    if (name) cache[name] = cache[id];

    return cache[id].exports;
  }

  /**
   * Require all entries exposing them on global if needed.
   */

  for (var id in entries) {
    if (entries[id]) {
      global[entries[id]] = require(id);
    } else {
      require(id);
    }
  }

  /**
   * Duo flag.
   */

  require.duo = true;

  /**
   * Expose cache.
   */

  require.cache = cache;

  /**
   * Expose modules
   */

  require.modules = modules;

  /**
   * Return newest require.
   */

   return require;
})({
1: [function(require, module, exports) {

/**
 * Module dependencies.
 */

var Highlight = require('segmentio/highlight');
var each = require('component/each');
var bash = require('segmentio/highlight-bash');
var html = require('segmentio/highlight-xml');
var js = require('segmentio/highlight-javascript');

/**
 * Syntax highlighter.
 */

var highlight = new Highlight()
  .use(bash)
  .use(html)
  .use(js);

/**
 * Highlight code-block's
 */

highlight.elements('.lang-bash', 'bash');
highlight.elements('.lang-javascript', 'javascript');
highlight.elements('.lang-xml', 'xml');

/**
 * DOM Cache.
 */

var main = document.querySelector('main');
var dock = document.querySelector('.dock');
var anchors = document.querySelectorAll('nav a');

/**
 * Dock/Un-dock sidebar.
 */
dock.addEventListener('click', function(e){
  e.preventDefault();
  toggleClass([main, dock], 'docked');
});

/**
 * Toggle specified class for all elements in array.
 *
 * @param {Array} els
 * @param {String} className
 * @api public
 */

function toggleClass(els, className){
  els = Array.isArray(els) ? els : [els];
  each(els, function(el){
    el.classList.toggle(className);
  });
}

/**
 * Select menu-item.
 */

var repo = location.pathname.replace(/\/*/g, '');
selectActiveNavigation(repo, anchors);

/**
 * Select navigation-item by adding `active`-class
 *
 * @param {String} select    should equal the last segment of path
 * @param {Array} anchors
 */

function selectActiveNavigation(select, anchors) {
  each(anchors, function(a){
    var href = a.href.replace(/\/$/g, '').split('/').pop();
    if (select == href) {
      a.classList.add('active');
    }
  });
}


}, {"segmentio/highlight":2,"component/each":3,"segmentio/highlight-bash":4,"segmentio/highlight-xml":5,"segmentio/highlight-javascript":6}],
2: [function(require, module, exports) {

var escape = require('escape-html');

/**
 * Expose `Highlight`.
 */

module.exports = Highlight;

/**
 * Initialize a new `Highlight` instance.
 */

function Highlight(){
  if (!(this instanceof Highlight)) return new Highlight();
  this.languages = {};
  this.prefix('Highlight-');
}

/**
 * Use a `plugin` function.
 *
 * @param {Function} plugin
 * @return {Highlight}
 */

Highlight.prototype.use = function(plugin){
  plugin(this);
  return this;
};

/**
 * Get or set the highlighted class `prefix`.
 *
 * @param {String} prefix
 * @return {Highlight or String}
 */

Highlight.prototype.prefix = function(prefix){
  if (!arguments.length) return this._prefix;
  this._prefix = prefix;
  return this;
}

/**
 * Define a new `language` with a `grammar`.
 *
 * @param {String} language
 * @param {Object} grammar
 * @return {Highlight}
 */

Highlight.prototype.language = function(language, grammar){
  this.languages[language] = grammar;
  return this;
};

/**
 * Highlight an HTML `string` of a given `language`.
 *
 * @param {String} string
 * @param {String} language
 * @return {String}
 */

Highlight.prototype.string = function(string, language){
  var ast = this.parse(string, language);
  var str = this.stringify(ast);
  return str;
};

/**
 * Highlight an `el`, with optional `language`.
 *
 * @param {Element or String} el
 * @param {String} language (optional)
 */

Highlight.prototype.element = function(el, language){
  if ('string' == typeof el) el = document.querySelector(el);
  var str = this.string(el.textContent, language || lang(el));
  el.innerHTML = str;
};

/**
 * Highlight an array of `els`, with optional `language`.
 *
 * @param {Array or String} els
 * @param {String} language (optional)
 */

Highlight.prototype.elements = function(els, language){
  if ('string' == typeof els) els = document.querySelectorAll(els);
  for (var i = 0, el; el = els[i]; i++) this.element(el, language);
};

/**
 * Highlight all elements in the DOM with language attributes.
 */

Highlight.prototype.all = function(){
  this.elements(document.querySelectorAll('[data-language]'));
  this.elements(document.querySelectorAll('[class*="language-"]'));
  this.elements(document.querySelectorAll('[class*="lang-"]'));
};

/**
 * Parse a `string` with a given language's `grammar`, returning an AST.
 *
 * @param {String} string
 * @param {String or Object} grammar
 * @return {Array}
 */

Highlight.prototype.parse = function(string, grammar){
  if ('string' == typeof grammar) {
    var lang = grammar;
    grammar = this.languages[lang];
    if (!grammar) throw new Error('unknown language "' + lang + '"');
  }

  if (!grammar) throw new Error('must provide a grammar');
  if (!string) return [];
  var ret = [string];

  for (var key in grammar) {
    var rule = grammar[key];
    var regexp = rule.pattern || rule;

    for (var i = 0; i < ret.length; i++) {
      var str = ret[i];
      if ('object' == typeof str) continue;
      var m = regexp.exec(str);
      if (!m) continue;

      var contents = m[0];
      var before = str.slice(0, m.index);
      var after = str.slice(m.index + contents.length);
      var args = [i, 1];
      var token = {
        type: key,
        value: rule.children ? this.parse(contents, rule.children) : contents
      };

      if (before) args.push(before);
      args.push(token);
      if (after) args.push(after);
      ret.splice.apply(ret, args);
    }
  }

  return ret;
}

/**
 * Stringify a given `ast`.
 *
 * @param {Array} ast
 * @return {String}
 */

Highlight.prototype.stringify = function(ast){
  var prefix = this.prefix();
  var self = this;

  return ast.map(function(t){
    if ('string' == typeof t) return escape(t);
    var type = t.type;
    var value = 'object' == typeof t.value
      ? self.stringify(t.value)
      : escape(t.value);
    return '<span class="' + prefix + type + '">' + value + '</span>';
  }).join('');
};

/**
 * Language class matcher.
 */

var matcher = /\blang(?:uage)?-(\w+)\b/i;

/**
 * Get the code language for a given `el`. First look for a `data-language`
 * attribute, then a `language-*` class, then search up the DOM tree for them.
 *
 * @param {Element} el
 * @return {String}
 */

function lang(el){
  if (!el) return;
  var m;
  if (el.hasAttribute('data-language')) return el.getAttribute('data-language');
  if (m = matcher.exec(el.className)) return m[1];
  return language(el.parentNode);
}
}, {"escape-html":7}],
7: [function(require, module, exports) {
/**
 * Escape special characters in the given string of html.
 *
 * @param  {String} html
 * @return {String}
 * @api private
 */

module.exports = function(html) {
  return String(html)
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

}, {}],
3: [function(require, module, exports) {

/**
 * Module dependencies.
 */

try {
  var type = require('type');
} catch (err) {
  var type = require('component-type');
}

var toFunction = require('to-function');

/**
 * HOP reference.
 */

var has = Object.prototype.hasOwnProperty;

/**
 * Iterate the given `obj` and invoke `fn(val, i)`
 * in optional context `ctx`.
 *
 * @param {String|Array|Object} obj
 * @param {Function} fn
 * @param {Object} [ctx]
 * @api public
 */

module.exports = function(obj, fn, ctx){
  fn = toFunction(fn);
  ctx = ctx || this;
  switch (type(obj)) {
    case 'array':
      return array(obj, fn, ctx);
    case 'object':
      if ('number' == typeof obj.length) return array(obj, fn, ctx);
      return object(obj, fn, ctx);
    case 'string':
      return string(obj, fn, ctx);
  }
};

/**
 * Iterate string chars.
 *
 * @param {String} obj
 * @param {Function} fn
 * @param {Object} ctx
 * @api private
 */

function string(obj, fn, ctx) {
  for (var i = 0; i < obj.length; ++i) {
    fn.call(ctx, obj.charAt(i), i);
  }
}

/**
 * Iterate object keys.
 *
 * @param {Object} obj
 * @param {Function} fn
 * @param {Object} ctx
 * @api private
 */

function object(obj, fn, ctx) {
  for (var key in obj) {
    if (has.call(obj, key)) {
      fn.call(ctx, key, obj[key]);
    }
  }
}

/**
 * Iterate array-ish.
 *
 * @param {Array|Object} obj
 * @param {Function} fn
 * @param {Object} ctx
 * @api private
 */

function array(obj, fn, ctx) {
  for (var i = 0; i < obj.length; ++i) {
    fn.call(ctx, obj[i], i);
  }
}

}, {"type":8,"component-type":8,"to-function":9}],
8: [function(require, module, exports) {

/**
 * toString ref.
 */

var toString = Object.prototype.toString;

/**
 * Return the type of `val`.
 *
 * @param {Mixed} val
 * @return {String}
 * @api public
 */

module.exports = function(val){
  switch (toString.call(val)) {
    case '[object Function]': return 'function';
    case '[object Date]': return 'date';
    case '[object RegExp]': return 'regexp';
    case '[object Arguments]': return 'arguments';
    case '[object Array]': return 'array';
    case '[object String]': return 'string';
  }

  if (val === null) return 'null';
  if (val === undefined) return 'undefined';
  if (val && val.nodeType === 1) return 'element';
  if (val === Object(val)) return 'object';

  return typeof val;
};

}, {}],
9: [function(require, module, exports) {

/**
 * Module Dependencies
 */

var expr;
try {
  expr = require('props');
} catch(e) {
  expr = require('component-props');
}

/**
 * Expose `toFunction()`.
 */

module.exports = toFunction;

/**
 * Convert `obj` to a `Function`.
 *
 * @param {Mixed} obj
 * @return {Function}
 * @api private
 */

function toFunction(obj) {
  switch ({}.toString.call(obj)) {
    case '[object Object]':
      return objectToFunction(obj);
    case '[object Function]':
      return obj;
    case '[object String]':
      return stringToFunction(obj);
    case '[object RegExp]':
      return regexpToFunction(obj);
    default:
      return defaultToFunction(obj);
  }
}

/**
 * Default to strict equality.
 *
 * @param {Mixed} val
 * @return {Function}
 * @api private
 */

function defaultToFunction(val) {
  return function(obj){
    return val === obj;
  };
}

/**
 * Convert `re` to a function.
 *
 * @param {RegExp} re
 * @return {Function}
 * @api private
 */

function regexpToFunction(re) {
  return function(obj){
    return re.test(obj);
  };
}

/**
 * Convert property `str` to a function.
 *
 * @param {String} str
 * @return {Function}
 * @api private
 */

function stringToFunction(str) {
  // immediate such as "> 20"
  if (/^ *\W+/.test(str)) return new Function('_', 'return _ ' + str);

  // properties such as "name.first" or "age > 18" or "age > 18 && age < 36"
  return new Function('_', 'return ' + get(str));
}

/**
 * Convert `object` to a function.
 *
 * @param {Object} object
 * @return {Function}
 * @api private
 */

function objectToFunction(obj) {
  var match = {};
  for (var key in obj) {
    match[key] = typeof obj[key] === 'string'
      ? defaultToFunction(obj[key])
      : toFunction(obj[key]);
  }
  return function(val){
    if (typeof val !== 'object') return false;
    for (var key in match) {
      if (!(key in val)) return false;
      if (!match[key](val[key])) return false;
    }
    return true;
  };
}

/**
 * Built the getter function. Supports getter style functions
 *
 * @param {String} str
 * @return {String}
 * @api private
 */

function get(str) {
  var props = expr(str);
  if (!props.length) return '_.' + str;

  var val, i, prop;
  for (i = 0; i < props.length; i++) {
    prop = props[i];
    val = '_.' + prop;
    val = "('function' == typeof " + val + " ? " + val + "() : " + val + ")";

    // mimic negative lookbehind to avoid problems with nested properties
    str = stripNested(prop, str, val);
  }

  return str;
}

/**
 * Mimic negative lookbehind to avoid problems with nested properties.
 *
 * See: http://blog.stevenlevithan.com/archives/mimic-lookbehind-javascript
 *
 * @param {String} prop
 * @param {String} str
 * @param {String} val
 * @return {String}
 * @api private
 */

function stripNested (prop, str, val) {
  return str.replace(new RegExp('(\\.)?' + prop, 'g'), function($0, $1) {
    return $1 ? $0 : val;
  });
}

}, {"props":10,"component-props":10}],
10: [function(require, module, exports) {
/**
 * Global Names
 */

var globals = /\b(this|Array|Date|Object|Math|JSON)\b/g;

/**
 * Return immediate identifiers parsed from `str`.
 *
 * @param {String} str
 * @param {String|Function} map function or prefix
 * @return {Array}
 * @api public
 */

module.exports = function(str, fn){
  var p = unique(props(str));
  if (fn && 'string' == typeof fn) fn = prefixed(fn);
  if (fn) return map(str, p, fn);
  return p;
};

/**
 * Return immediate identifiers in `str`.
 *
 * @param {String} str
 * @return {Array}
 * @api private
 */

function props(str) {
  return str
    .replace(/\.\w+|\w+ *\(|"[^"]*"|'[^']*'|\/([^/]+)\//g, '')
    .replace(globals, '')
    .match(/[$a-zA-Z_]\w*/g)
    || [];
}

/**
 * Return `str` with `props` mapped with `fn`.
 *
 * @param {String} str
 * @param {Array} props
 * @param {Function} fn
 * @return {String}
 * @api private
 */

function map(str, props, fn) {
  var re = /\.\w+|\w+ *\(|"[^"]*"|'[^']*'|\/([^/]+)\/|[a-zA-Z_]\w*/g;
  return str.replace(re, function(_){
    if ('(' == _[_.length - 1]) return fn(_);
    if (!~props.indexOf(_)) return _;
    return fn(_);
  });
}

/**
 * Return unique array.
 *
 * @param {Array} arr
 * @return {Array}
 * @api private
 */

function unique(arr) {
  var ret = [];

  for (var i = 0; i < arr.length; i++) {
    if (~ret.indexOf(arr[i])) continue;
    ret.push(arr[i]);
  }

  return ret;
}

/**
 * Map with prefix `str`.
 */

function prefixed(str) {
  return function(_){
    return str + _;
  };
}

}, {}],
4: [function(require, module, exports) {

/**
 * Expose `bash`
 */

module.exports = bash;

/**
 * Add `bash` as a language.
 *
 * @param {Highlight} highlight
 * @api public
 */

function bash(highlight){
  highlight.language('sh', bash);
  highlight.language('bash', bash);
  highlight.language('shellscript', bash);
}

/**
 * Comments
 */

bash.comment = /(#.*?$)/m

/**
 * Strings
 */

bash.string = /(("|')(\\?.)*?\2)/;

/**
 * Keywords
 */

bash.keyword = /\b(if|then|else|elif|fi|for|in|do|done|select|case|continue|esac|while|until|return|export|declare|typeset|local|readonly)\b/;

/**
 * Operators
 */

bash.operator = /(;|&&?|\|\||=[=~]?|!=?|&lt;|&gt;|\|)/;

/**
 * Builtins
 */

bash.builtin = /\b(alias|bg|bind|break|builtin|caller|cd|command|compgen|complete|dirs|disown|echo|enable|eval|exec|exit|false|fc|fg|getopts|hash|help|history|jobs|kill|let|logout|popd|printf|pushd|pwd|read|readonly|set|shift|shopt|source|suspend|test|times|trap|true|type|ulimit|umask|unalias|unset|wait)\b/;
}, {}],
5: [function(require, module, exports) {

/**
 * Expose `plugin`.
 */

module.exports = plugin;

/**
 * Plugin to highlight XML code.
 *
 * @param {Highlight} highlight
 */

function plugin(highlight){
  highlight
    .language('xml', grammar)
    .language('html', grammar);
}

/**
 * Grammar.
 */

var grammar = {};

/**
 * Comments.
 */

grammar.comment = /<!--[\w\W]*?-->/m;

/**
 * Entities.
 */

grammar.entity = /&#?[\dA-Za-z]{1,8};/;

/**
 * Doctypes.
 */

grammar.doctype = /<!DOCTYPE.+?>/i;

/**
 * CDATA.
 */

grammar.cdata = /<!\[CDATA\[[\w\W]*?]]>/i;

/**
 * Prologs.
 */

grammar.prolog = /<\?.+?\?>/;

/**
 * Tags. Children declared separately to maintain order.
 */

var children = {
  string: /('|")[\w\W]*?\1/,
  punctuation: /(^<\/?|\/?>$|=)/,
  name: /^[\w:-]+/,
  attribute: /[\w:-]+/
};

grammar.tag = {
  pattern: /<\/?[\w:-]+\s*(\s+[\w:-]+(=(("|')[\w\W]*\4|[^\s'">=]+))?\s*)*\/?>/,
  children: children
};
}, {}],
6: [function(require, module, exports) {

/**
 * Expose `plugin`.
 */

module.exports = plugin;

/**
 * Plugin to highlight Javascript code.
 *
 * @param {Highlight} highlight
 */

function plugin(highlight){
  highlight
    .language('javascript', grammar)
    .language('js', grammar);
}

/**
 * Grammar.
 */

var grammar = {};

/**
 * Comments.
 */

grammar.comment = /(?!\\{2})(\/\*[\w\W]*?\*\/|\/\/.*?$)/m;

/**
 * Booleans.
 */

grammar.boolean = /\b(true|false)\b/;

/**
 * Strings.
 */

grammar.string = /(("|')(\\?.)*?\2)/;

/**
 * Keywords.
 */

grammar.keyword = /\b(break|catch|continue|delete|do|else|finally|for|function|if|in|instanceof|let|new|null|return|this|self|throw|try|typeof|var|while|with|yield)\b/;

/**
 * Constants.
 */

grammar.constant = /\b(document|window|global)\b/;

/**
 * Functions.
 *
 * Children are set separately to maintain ordering.
 */

grammar.function = {
  pattern: /(\w+)\(/,
  children: {}
};

grammar.function.children.class = /\b([A-Z]\w*)\b/;
grammar.function.children.function = /(\w+)/;
grammar.function.children.punctuation = /\(/;

/**
 * Numbers.
 */

grammar.number = /\b-?(0x[\dA-Fa-f]+|\d*\.?\d+([Ee]-?\d+)?|NaN|-?Infinity)\b/;

/**
 * Operators.
 */

grammar.operator = /([-+]{1,2}|!|&lt;=?|>=?|={1,3}|&lt;{1,2}|>{1,2}|(&amp;){1,2}|\|{1,2}|\?|\*|\/|\~|\^|\%)/;

/**
 * Punctuation.
 */

grammar.punctuation = /[{}[\];(),.:]/;
}, {}]}, {}, {"1":""})
