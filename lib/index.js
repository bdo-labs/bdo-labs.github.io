
/**
 * Module dependencies.
 */

var Highlight = require('segmentio/highlight');
var each = require('component/each');
var bash = require('segmentio/highlight-bash');
var html = require('segmentio/highlight-xml');
var js = require('segmentio/highlight-javascript');

/**
 * Redirect root-requests.
 */

if (window.location.pathname === '/') {
  window.location.pathname = '/home/';
}

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

var main = document.querySelector('main');
var dock = document.querySelector('.dock');
dock.addEventListener('click', function(e){
  e.preventDefault();
  toggleClass([main, dock], 'docked');
});

function toggleClass(els, className){
  els = Array.isArray(els) ? els : [els];
  each(els, function(el){
    el.classList.toggle(className);
  });
}

/*
 * Select menu-item.
 */

var repo = location.pathname.replace(/\/*/g, '');
var anchors = document.querySelectorAll('nav a');
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

