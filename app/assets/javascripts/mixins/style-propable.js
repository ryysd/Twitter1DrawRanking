var Extend = require('../utils/extend');

/**
 *	@params:
 *	styles = Current styles.
 *  props = New style properties that will override the current style.
 */
module.exports = {

  propTypes: {
    style: React.PropTypes.object
  },

  merge: function() {
    var args = Array.prototype.slice.call(arguments, 0);
    var base = args[0];
    for (var i = 1; i < args.length; i++) {
      if (args[i]) base = Extend(base, args[i]);
    }
    
    return base;
  }
}
