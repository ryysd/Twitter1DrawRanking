var Image = require('./image.jsx');

var mui = require('material-ui');

var ImageGrid = React.createClass({
  render: function() {
    return ( 
    <div>
      {this.props.urls.map(function(url) {
        return <Image url={url} />
      })}
    </div>
    );
  }
});

module.exports = ImageGrid;
