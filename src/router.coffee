TemperatureController = require './controllers/temperature-controller'

class Router
  constructor: ({weatherService}) ->
    throw new Error('weatherService is required') unless weatherService?

    @temperatureController = new TemperatureController {weatherService}

  routes: =>
    'GET /temperature/c':          @temperatureController.currentCelsius
    'GET /temperature/celsius':    @temperatureController.currentCelsius
    'GET /temperature/f':          @temperatureController.currentFahrenheit
    'GET /temperature/fahrenheit': @temperatureController.currentFahrenheit

module.exports = Router
