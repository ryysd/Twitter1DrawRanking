var StylePropable = require('../../../mixins/style-propable.js');
var IconStyle = require('./style.jsx');

var UserIcon = React.createClass({
  mixins: [StylePropable],

  PropTypes: {
    style: React.PropTypes.object
  },

  getStyles: function() {
    var styles = {
      root: IconStyle
    }

    return styles;
  },

  render: function() {
    if (!this.hasOwnProperty('styles')) this.styles = this.getStyles();

    return (
      <i style={this.merge(this.styles.root, this.props.style)} className="fa fa-user fa-border" />
    );
  }
});

module.exports = UserIcon;
