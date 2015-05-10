var ImageGrid = require('../image-grid/image-grid.jsx');

var TotalRanking = React.createClass({
  getInitialState: function() {
    return {data: []};
  },

  loadRankingData: function() {
    $.getJSON("http://localhost:3000/api//rankings/2015-05-08/genres/2", function(res) {
      var urls = res.tweets.map(function(obj) {return obj.illust_urls[0];})
      this.setState({data: urls});
    });
  },

  componentDidMount: function() {
    this.loadRankingData();
  },

  render: function() {
    return (<ImageGrid urls={this.state.data} />);
  }
});

module.exports = TotalRanking;

