request = require 'request'

class TemperatureController
  fahrenheit: (req, res) =>
    options =
      url: 'http://api.openweathermap.org/data/2.5/weather'
      json: true
      qs:
        units: 'imperial'
        q: req.query.location

    request options, (error, response, body) =>
      return res.send 500, error if error?
      return res.send body.cod, body.message unless body.cod == 200
      res.send 200, body.main.temp

module.exports = TemperatureController
