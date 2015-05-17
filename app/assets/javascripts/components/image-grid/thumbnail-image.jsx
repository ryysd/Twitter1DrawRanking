var StylePropable = require('../../mixins/style-propable.js');

var ThumbnailImage = React.createClass({
  mixins: [StylePropable],

  propTypes: {
    url:  React.PropTypes.string.isRequired,
    size:  React.PropTypes.number.isRequired,
  },

  getStyles: function() {
    var styles = {
      image_container: {
        position: 'relative',
        float: 'left',
        overflow: 'hidden',
        height: this.props.size + 'px',
        width: this.props.size + 'px',
        display: 'block',
      },

      image: {
        position: 'absolute',
        display: 'block',
      }
    };

    return styles;
  },

  render: function() {
    if (!this.hasOwnProperty('styles')) this.styles = this.getStyles();

    return (
      <div style={this.styles.image_container}>
        <img style={this.styles.image} src={this.props.url} onLoad={this.onLoad} />
      </div>
    );
  },

  onLoad: function(e) {
    this.updateImageStyle(e.target);
  },

  updateImageStyle: function(image) {
    var is_oblong = image.width > image.height;

    if(!is_oblong) {
      image.style.width = this.props.size + 'px';
    } else {
      image.style.height = this.props.size + 'px';
    }

    image.style.left = ((this.props.size - image.width) / 2) + 'px';
    image.style.top = ((this.props.size - image.height) / 2) + 'px';
  },
});

module.exports = ThumbnailImage;
