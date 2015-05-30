var Dispatcher = require('../dispatcher/dispatcher');
var ActionTypes = require('../constants/constants').ActionTypes;
var RankingApiCaller = require('../utils/ranking-api-caller');

var RankingAction = {
  show: function(data) {
    Dispatcher.dispatch({
      type: ActionTypes.SHOW_RANKING,
      tweets: data
    });
  },

  get: function(date, category_id) {
    RankingApiCaller.get(date, category_id, this.show);
  }
};

module.exports = RankingAction;
