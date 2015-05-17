var React = require('react');
var Router = require('react-router'); 
var DefaultRoute = Router.DefaultRoute;
var Link = Router.Link;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var Master = require('./components/master.jsx');
var TotalRanking = require('./components/ranking/total-ranking.jsx');
var CategoryRanking = require('./components/ranking/category-ranking.jsx');

var AppRoutes = (
  <Route name="app" path="/" handler={Master}>
    <DefaultRoute handler={TotalRanking}/>
    <Route name="category-ranking" path="/rankings/:date/categories/:category_id" handler={CategoryRanking} />
  </Route>
);

module.exports = AppRoutes;
