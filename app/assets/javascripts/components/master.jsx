var Router = require('react-router'); 
var RouteHandler = Router.RouteHandler;

var mui = require('material-ui');
var RaisedButton = mui.RaisedButton;
var DatePicker = mui.DatePicker;
var AppBar = mui.AppBar;

var Toolbar = mui.Toolbar;
var ToolbarGroup = mui.ToolbarGroup;
var FontIcon = mui.FontIcon;
var DropDownMenu = mui.DropDownMenu;
var DropDownIcon = mui.DropDownIcon;

var Master = React.createClass({
  render: function() {
    var filterOptions = [
      { payload: '1', text: 'All Broadcasts' },
      { payload: '2', text: 'All Voice' },
      { payload: '3', text: 'All Text' },
      { paylad: '4', text: 'Complete Voice' },
      { payload: '5', text: 'Complete Text' },
      { payload: '6', text: 'Active Voice' },
      { payload: '7', text: 'Active Text' },
    ];
    var iconMenuItems = [
      { payload: '1', text: 'Download' },
      { payload: '2', text: 'More Info' }
    ];

    return (
        <div>
          <AppBar title="Twitter Illust Ranking"/>
          <Toolbar>
            <ToolbarGroup key={0} float="left">
              <DropDownMenu menuItems={filterOptions} />
            </ToolbarGroup>
            <ToolbarGroup key={2} float="left">
              <DatePicker hintText="Portrait Dialog" />
            </ToolbarGroup>
            <ToolbarGroup key={3} float="right">
              <FontIcon className="mui-icon-pie" />
              <FontIcon className="mui-icon-sort" />
              <DropDownIcon iconClassName="icon-navigation-expand-more" menuItems={iconMenuItems} />
              <span className="mui-toolbar-separator">&nbsp;</span>
              <RaisedButton label="Create Broadcast" primary={true} />
            </ToolbarGroup>
          </Toolbar>
          <RouteHandler/>
        </div>
    );
  }
});

module.exports = Master;
