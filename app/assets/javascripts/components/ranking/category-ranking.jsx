var ImageGrid = require('../image-grid/image-grid.jsx');

var CategoryRanking = React.createClass({
  getInitialState: function() {
    return {tweets: []};
  },

  loadRankingData: function(date, category_id) {
    var self = this;
    $.getJSON("http://localhost:3000/api//rankings/" + date + "/genres/" + category_id, function(res) {
      res.tweets.sort(function(a, b) {return b.score - a.score;});
      console.log(res.tweets.length);
      // var urls = res.tweets.map(function(tweet) {return tweet.illust_urls[0];})
      self.setState({tweets: res.tweets});
    });
  },

  componentDidMount: function() {
    this.loadRankingData(this.props.params.date, this.props.params.category_id);
  },

  render: function() {
    return (<ImageGrid tweets={this.state.tweets} col_num={3} margin={1}/>);
  }
});

module.exports = CategoryRanking;
