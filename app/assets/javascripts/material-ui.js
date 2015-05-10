var React = require('react');
var mui = require('material-ui');
var RaisedButton = mui.RaisedButton;
var AppBar = mui.AppBar;

var Router = require('react-router'); 
var DefaultRoute = Router.DefaultRoute;
var Link = Router.Link;
var Route = Router.Route;
var RouteHandler = Router.RouteHandler;

var App = React.createClass({
  render: function() {
    return (
        <div>
          <AppBar/>
          <RouteHandler/>
        </div>
    );
  }
});

var Dashboard = React.createClass({
  render: function() {
    return (<div>aaaaaaaaaaaaaaa</div>);
  }
});

var Test = React.createClass({
  render: function() {
    return (<div>bbbbbbbbbbbbbbbb</div>);
  }
});

var routes = (
  <Route name="app" path="/" handler={App}>
    <DefaultRoute handler={Dashboard}/>
    <Route name="test" handler={Test} />
  </Route>
);

$(function() {
  Router.run(routes, function (Handler) {
    React.render(<Handler/>, document.body);
  });
});
