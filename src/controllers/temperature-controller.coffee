_       = require 'lodash'
debug   = require('debug')('weather-service:temperature-controller')

class TemperatureController
  constructor: ({@weatherService}) ->
    throw new Error('weatherService is required') unless @weatherService?

  currentCelsius: (req, res) =>
    {query, city, state, country} = req.location
    @weatherService.temperatureInCelcius query, (error, temperature) =>
      return res.status(502).send(error: message: error.message) if error?
      return res.status(200).send {temperature, city, state, country}

  currentFahrenheit: (req, res) =>
    {query, city, state, country} = req.location
    @weatherService.temperatureInFahrenheit query, (error, temperature) =>
      return res.status(502).send(error: message: error.message) if error?
      return res.status(200).send {temperature, city, state, country}

  convertListToHuman: (list, tempConverter) =>
    return _.map list, (listItem) =>
      return @convertItemToHuman listItem, tempConverter

module.exports = TemperatureController
