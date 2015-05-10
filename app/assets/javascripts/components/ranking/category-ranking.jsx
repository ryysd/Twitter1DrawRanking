var ImageGrid = require('../image-grid/image-grid.jsx');

var CategoryRanking = React.createClass({
  getInitialState: function() {
    return {data: []};
  },

  loadRankingData: function() {
    var self = this;
    $.getJSON("http://localhost:3000/api//rankings/2015-05-08/genres/2", function(res) {
      res.tweets.sort(function(a, b) {return b.score - a.score;});
      var urls = res.tweets.map(function(tweet) {return tweet.illust_urls[0];})
      self.setState({data: urls});
    });
  },

  componentDidMount: function() {
    this.loadRankingData();
  },

  render: function() {
    return (<ImageGrid urls={this.state.data} />);
  }
});

module.exports = CategoryRanking;
