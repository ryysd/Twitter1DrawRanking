(function() {
  var React = require('react');
  var Router = require('react-router');
  var AppRoutes = require('./app-routes.jsx');
  var injectTapEventPlugin = require("react-tap-event-plugin");

  window.React = React;
  injectTapEventPlugin();

  $(function() {
    Router.run(AppRoutes, function (Handler) {
      React.render(<Handler/>, document.body);
    });
  });
}) ();
