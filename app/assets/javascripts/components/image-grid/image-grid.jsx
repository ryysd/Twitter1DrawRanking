var ThumbnailImage = require('./thumbnail-image.jsx');

var mui = require('material-ui');

var ImageGrid = React.createClass({
  propTypes: {
    col_num:  React.PropTypes.number.isRequired,
    margin: React.PropTypes.number.isRequired
  },
   
  render: function() {
    return ( 
    <div>
      {this.props.urls.map(function(url, idx) {
        return <ThumbnailImage key={idx} url={url} size={this.calcSize()} margin={this.props.margin}/>
      }.bind(this))}
    </div>
    );
  },

  calcSize: function() {
    return (window.innerWidth / this.props.col_num) - (this.props.margin * 2);
  }
});

module.exports = ImageGrid;
