request = require 'request'
_       = require 'lodash'

class TemperatureController
  celsius: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    @request 'metric', location, (error, response, body) =>
      return res.status(500).send(error) if error?

      res.status(body.cod)
      return res.send(body.message) unless body.cod == 200
      res.send "#{body.main.temp}"

  fahrenheit: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    @request 'imperial', location, (error, response, body) =>
      return res.status(500).send(error) if error?

      res.status(body.cod)
      return res.send(body.message) unless body.cod == 200
      res.send "#{body.main.temp}"

  request: (units, location, callback=->) =>
    options =
      url: 'http://api.openweathermap.org/data/2.5/weather'
      json: true
      qs:
        units: units
        q: location

    request options, callback

module.exports = TemperatureController
