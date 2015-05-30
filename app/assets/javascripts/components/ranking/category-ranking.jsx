var RankingStore = require('../../stores/ranking-store');
var RankingAction = require('../../actions/ranking-action');
var ImageGrid = require('../image-grid/image-grid.jsx');

var CategoryRanking = React.createClass({
  getStateFromStore: function() {
    return {
      tweets: RankingStore.get()
    };
  },

  getInitialState: function() {
    return this.getStateFromStore();
  },

  componentDidMount: function() {
    RankingStore.addChangeListener(this._onChange);
    RankingAction.get(this.props.params.date, this.props.params.category_id);
  },

  componentWillUnmount: function() {
    RankingStore.removeChangeListener(this._onChange);
  },

  render: function() {
    return (<ImageGrid tweets={this.state.tweets} col_num={3} margin={1}/>);
  },

  _onChange: function() {
    this.setState(this.getStateFromStore());
  }
});

module.exports = CategoryRanking;
