var mui = require('material-ui');
var Paper = mui.Paper;

var Image = React.createClass({
  render: function() {
    return (
      <Paper>
        <img src={this.props.url} />
      </Paper>
    );
  }
});

module.exports = Image;
