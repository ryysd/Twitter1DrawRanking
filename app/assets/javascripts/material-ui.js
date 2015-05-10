var React = require('react');
var injectTapEventPlugin = require("react-tap-event-plugin");
injectTapEventPlugin();

var mui = require('material-ui');
var RaisedButton = mui.RaisedButton;
var DatePicker = mui.DatePicker;
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
          <DatePicker hintText="Portrait Dialog"/>
          <DatePicker
            hintText="Landscape Dialog"
              mode="landscape"/>
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
