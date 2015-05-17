var TwitterImage = require('./twitter-image.jsx');

var mui = require('material-ui');

var ImageGrid = React.createClass({
  propTypes: {
    tweets: React.PropTypes.array.isRequired,
    col_num:  React.PropTypes.number.isRequired,
    margin: React.PropTypes.number.isRequired
  },
   
  render: function() {
    return ( 
    <div>
      {this.props.tweets.map(function(tweet, idx) {
        return <TwitterImage key={idx} tweet={tweet} size={this.calcSize()} margin={this.props.margin}/>
      }.bind(this))}
    </div>
    );
  },

  calcSize: function() {
    return (window.innerWidth / this.props.col_num) - (this.props.margin * 2);
  }
});

module.exports = ImageGrid;
