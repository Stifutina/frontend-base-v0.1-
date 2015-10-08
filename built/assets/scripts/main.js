
/*!=================PROJECT CUSTOM SCRIPT================= */
jQuery(document).ready(function() {
  'use strict';
  $(this).controllerModule();
  return true;
});

window.onload = function() {
  $(document).layoutModule();
  return true;
};


/*!--------MODULES-------- */


/*!Layout module */

(function($) {
  'use strict';
  var methods, variables;
  variables = {
    orientation: window.innerHeight > window.innerWidth ? 'vertical' : 'horizontal',
    initialWindowSize: [window.innerHeight, window.innerWidth],
    currentWindowSize: [window.innerHeight, window.innerWidth]
  };
  methods = {
    init: function(options) {
      $.extend(variables, options, {
        element: this
      });
      methods.resizeViewPort();
      return this;
    },
    resizeViewPort: function() {
      $(window).resize(function() {
        variables.currentWindowSize = [window.innerHeight, window.innerWidth];
        if (window.innerHeight > window.innerWidth) {
          variables.orientation = 'vertical';
        } else {
          variables.orientation = 'horizontal';
        }
        return true;
      });
      if (Modernizr.touch) {
        $('input, textarea').focus(function() {

          /*! virtual keyboard */
          return this;
        });
      }
      return true;
    }
  };
  return $.fn.layoutModule = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      return $.error('No such method');
    }
  };
})(jQuery);
