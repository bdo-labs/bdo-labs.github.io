
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

