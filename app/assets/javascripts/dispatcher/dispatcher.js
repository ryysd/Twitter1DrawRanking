var Dispatcher = require('flux').Dispatcher;
window.dispatcher = window.dispatcher || new Dispatcher;
module.exports = window.dispatcher;
