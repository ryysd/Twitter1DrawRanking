var StylePropable = require('../../mixins/style-propable.js');
var ThumbnailImage = require('./thumbnail-image.jsx');

var TwitterImage = React.createClass({
  mixins: [StylePropable],

  propTypes: {
    tweet: React.PropTypes.object.isRequired,
    size:  React.PropTypes.number.isRequired,
    margin: React.PropTypes.number.isRequired
  },

  getStyles: function() {
    var styles = {
      root: {
        position: 'relative',
        float: 'left',
        overflow: 'hidden',
        height: this.props.size + 'px',
        width: this.props.size + 'px',
        display: 'block',
        margin: this.props.margin
      }
    };

    return styles;
  },

  render: function() {
    if (!this.hasOwnProperty('styles')) this.styles = this.getStyles();

    return (
      <div style={this.styles.root}>
        <ThumbnailImage url={this.props.tweet.illust_urls[0]} size={this.props.size} margin={this.props.margin} />
      </div>
    );
  }
});

module.exports = TwitterImage;
