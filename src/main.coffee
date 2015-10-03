# @cjsx React.DOM

React = require('react/addons')
Reflux = require('reflux')
request = require('superagent')

defaultStore = Reflux.createStore
  init: ->
    request "http://www.telize.com/geoip", (err, res) =>
      @trigger
        message: "You are in #{res.body.country} and your ip is #{res.body.ip}"

  getInitialState: ->
    message: 'Getting ip infomercial...'

MainComponent = React.createClass

  mixins: [Reflux.connect(defaultStore)]

  render: ->
    <div>
      {@state.message}
    </div>

app = React.render <MainComponent />, document.getElementById('main')


