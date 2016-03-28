request = require 'request'
_       = require 'lodash'
debug   = require('debug')('weather-service:temperature-controller')

class TemperatureController
  currentCelsius: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    if _.isEmpty location
      return res.status(422).send error: 'At least one of [city, state, country] is required'

    @request 'weather', location, (error, response, body={}) =>
      debug 'current weather celsius', body
      return res.status(502).send(error) if error?
      weatherObj = @convertItemToHuman body, @kelvinToCelsius
      res.status(body.cod).send _.extend weatherObj, city: city, state: state, country: country

  currentFahrenheit: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    if _.isEmpty location
      return res.status(422).send error: 'At least one of [city, state, country] is required'

    @request 'weather', location, (error, response, body={}) =>
      debug 'current weather fahrenheit', body
      return res.status(502).send(error) if error?
      weatherObj = @convertItemToHuman body, @kelvinToFahrenheit
      res.status(body.cod).send _.extend weatherObj, city: city, state: state, country: country

  forecastCelsius: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    if _.isEmpty location
      return res.status(422).send error: 'At least one of [city, state, country] is required'
    @request 'forecast', location, (error, response, body={}) =>
      debug 'forecast celsius', body
      return res.status(502).send(error) if error?
      res.status(body.cod).send forecast: @convertListToHuman(body.list, @kelvinToCelsius), city: city, state: state, country: country

  forecastFahrenheit: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','
    if _.isEmpty location
      return res.status(422).send error: 'At least one of [city, state, country] is required'
    @request 'forecast', location, (error, response, body={}) =>
      debug 'forecast fahrenheit', body
      return res.status(502).send(error) if error?
      res.status(body.cod).send forecast: @convertListToHuman(body.list, @kelvinToFahrenheit), city: city, state: state, country: country

  convertListToHuman: (list, tempConverter) =>
    return _.map list, (listItem) =>
      return @convertItemToHuman listItem, tempConverter

  convertItemToHuman: (item, tempConverter) =>
    return {
      temperature: @roundTemp(tempConverter(item.main?.temp)),
      temperature_min: @roundTemp(tempConverter(item.main?.temp_min)),
      temperature_max: @roundTemp(tempConverter(item.main?.temp_max)),
      pressure: item.main?.pressure,
      humidity: item.main?.humidity,
      weather: _.first(_.map item.weather, 'description')
      wind:
        speed: item.wind?.speed,
        degrees: item.wind?.deg,
      date: item.dt_txt
    }

  roundTemp: (temp) =>
    return Math.round(temp * 1000) / 1000

  kelvinToFahrenheit: (value) =>
    return (@kelvinToCelsius(value) * 1.8) + 32

  kelvinToCelsius: (value) =>
    return value - 273.15

  request: (endpoint, location, callback=->) =>
    options =
      url: "http://api.openweathermap.org/data/2.5/#{endpoint}"
      json: true
      timeout: 5000
      qs:
        q: location
        APPID: process.env.APPID
    request options, callback

module.exports = TemperatureController
