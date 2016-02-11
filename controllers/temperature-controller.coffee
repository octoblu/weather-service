request = require 'request'
_       = require 'lodash'
debug   = require('debug')('weather-service:temperature-controller')

class TemperatureController
  celsius: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    @request location, (error, response, body={}) =>
      debug 'celsius', body
      return res.status(502).send(error) if error?
      kelvinTemp = body.main?.temp
      temp = @kelvinToCelsius kelvinTemp if kelvinTemp?
      return res.status(502).send error: 'invalid response' unless temp?
      res.status(body.cod).send temperature: Math.round(temp * 1000) / 1000, city: city, state: state, country: country

  fahrenheit: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    @request location, (error, response, body={}) =>
      debug 'fahrenheit', body
      return res.status(502).send(error) if error?
      kelvinTemp = body.main?.temp
      temp = @kelvinToFahrenheit kelvinTemp if kelvinTemp?
      return res.status(502).send error: 'invalid response' unless temp?
      res.status(body.cod).send temperature: Math.round(temp * 1000) / 1000, city: city, state: state, country: country

  kelvinToFahrenheit: (value) =>
    (@kelvinToCelsius(value) * 1.8) + 32

  kelvinToCelsius: (value) =>
    value - 273.15

  request: (location, callback=->) =>
    options =
      url: 'http://api.openweathermap.org/data/2.5/weather'
      json: true
      timeout: 5000
      qs:
        q: location
        APPID: process.env.APPID
    request options, callback

module.exports = TemperatureController
