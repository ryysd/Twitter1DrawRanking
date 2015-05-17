var StylePropable = require('../../mixins/style-propable.js');

var RetweetIcon = require('./icon/retweet-icon.jsx');
var FavoriteIcon = require('./icon/favorite-icon.jsx');
var UserIcon = require('./icon/user-icon.jsx');
var TwitterIcon = require('./icon/twitter-icon.jsx');
var DownloadIcon = require('./icon/download-icon.jsx');

var TwitterInfoBar = React.createClass({
  mixins: [StylePropable],

  propTypes: {
    tweet: React.PropTypes.object,
    style: React.PropTypes.object
  },

  getStyles: function() {
    var styles = {
      root: {
        height: '30px',
      }
    }

    return styles;
  },

  render: function() {
    if (!this.hasOwnProperty('styles')) this.styles = this.getStyles();

    return (
      <div style={this.merge(this.styles.root, this.props.style)}>
        <RetweetIcon count={this.props.tweet.retweet_count} />
        <FavoriteIcon count={this.props.tweet.favorite_count} />
        <UserIcon style={{marginLeft: '20px'}}/>
        <TwitterIcon />
        <DownloadIcon />
      </div>
    );
  }
});

module.exports = TwitterInfoBar;
