console.log("read");

var Router = require('react-router'); 
var RouteHandler = Router.RouteHandler;

var mui = require('material-ui');
var RaisedButton = mui.RaisedButton;
var DatePicker = mui.DatePicker;
var AppBar = mui.AppBar;

var Master = React.createClass({
  render: function() {
    return (
        <div>
          <AppBar/>
          <DatePicker hintText="Portrait Dialog"/>
          <RouteHandler/>
        </div>
    );
  }
});

module.exports = Master;
