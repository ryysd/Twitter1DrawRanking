var StylePropable = require('../../../mixins/style-propable.js');
var IconStyle = require('./style.jsx');

var RetweetIcon = React.createClass({
  mixins: [StylePropable],

  propTypes: {
    count: React.PropTypes.number.isRequired,
    style: React.PropTypes.object
  },

  getStyles: function() {
    var styles = {
      root: this.merge(IconStyle, {color: '#85B95E'})
    }

    return styles;
  },

  render: function() {
    if (!this.hasOwnProperty('styles')) this.styles = this.getStyles();

    return (
      <i style={this.merge(this.styles.root, this.props.style)} className="fa fa-retweet fa-border">
        {this.props.count}
      </i>
    );
  }
});

module.exports = RetweetIcon;
