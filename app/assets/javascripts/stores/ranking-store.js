var EventEmitter = require('events').EventEmitter;
var ActionTypes = require('../constants/Constants').ActionTypes;
var Dispatcher = require('../dispatcher/Dispatcher');
var assign = require('object-assign');

var CHANGE_EVENT = 'change';
var _tweets = [];

var RankingStore = assign({}, EventEmitter.prototype, {
  emitChange: function() {
    this.emit(CHANGE_EVENT);
  },

  addChangeListener: function(callback) {
    this.on(CHANGE_EVENT, callback);
  },

  removeChangeListener: function(callback) {
    this.removeListener(CHANGE_EVENT, callback);
  },

  get: function() {
    return _tweets;
  },

  sort: function() {
    _tweets.sort(function(a, b) {return b.score - a.score;});
  },

  set: function(ranking) {
    _tweets = tweets;
  }
});

RankingStore.dispatchToken = Dispatcher.register(function(action) {
  switch(action.type) {
    case ActionTypes.SHOW_RANKING:
      _tweets = action.tweets;
      RankingStore.emitChange();
      break;
    default:
  }
});

module.exports = RankingStore;
