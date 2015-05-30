RankingApiCaller = {
  host: 'http://localhost:3000/api/',
  
  get: function(date, category_id, callback) {
    var query = this.host + 'rankings/' + date + '/genres/' + category_id;
    $.getJSON(query, function(res) { callback(res.tweets); })
  }
};

module.exports = RankingApiCaller;
