request = require 'request'
_       = require 'lodash'

class TemperatureController
  celsius: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    @request location, (error, response, body={}) =>
      return res.status(500).send(error) if error?
      kelvinTemp = body.list?[0]?.main?.temp
      temp = @kelvinToCelsius kelvinTemp if kelvinTemp?
      return res.status(500).send error: 'invalid response' unless temp?
      res.status(body.cod).send temperature: Math.round(temp * 1000) / 1000, city: city, state: state, country: country

  fahrenheit: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    @request location, (error, response, body={}) =>
      return res.status(500).send(error) if error?
      kelvinTemp = body.list?[0]?.main?.temp
      temp = @kelvinToFahrenheit kelvinTemp if kelvinTemp?
      return res.status(500).send error: 'invalid response' unless temp?
      res.status(body.cod).send temperature: Math.round(temp * 1000) / 1000, city: city, state: state, country: country

  kelvinToFahrenheit: (value) =>
    (@kelvinToCelsius(value) * 1.8) + 32

  kelvinToCelsius: (value) =>
    value - 273.15

  request: (location, callback=->) =>
    options =
      url: 'http://openweathermap.org/data/2.5/forecast/city'
      json: true
      qs:
        q: location
        APPID: process.env.APPID
    request options, callback

module.exports = TemperatureController
