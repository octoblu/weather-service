request = require 'request'

class WeatherService
  constructor: ({@appId}) ->
    throw new Error('appId is required') unless @appId?

  temperatureInCelcius: (query, callback) =>
    @request 'weather', query, (error, response, body={}) =>
      return callback error if error
      return callback null, @_kelvinToCelsius body.main?.temp

  temperatureInFahrenheit: (query, callback) =>
    @request 'weather', query, (error, response, body={}) =>
      return callback error if error
      return callback null, @_kelvinToFahrenheit body.main?.temp

  request: (endpoint, query, callback=->) =>
    options =
      url: "http://api.openweathermap.org/data/2.5/#{endpoint}"
      json: true
      timeout: 5000
      qs:
        q: query
        APPID: @appId
    request options, callback

  _kelvinToCelsius: (value) =>
    return @_roundTemp(value - 273.15)

  _kelvinToFahrenheit: (value) =>
    fahrenheit = (@_kelvinToCelsius(value) * 1.8) + 32
    return @_roundTemp fahrenheit

  _roundTemp: (temp) =>
    return Math.round(temp * 1000) / 1000

module.exports = WeatherService
