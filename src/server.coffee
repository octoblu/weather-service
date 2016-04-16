#!/usr/bin/env coffee

_                  = require 'lodash'
express            = require 'express'
path               = require 'path'
morgan             = require 'morgan'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
locationParser     = require './middlewares/location-parser'
WeatherService     = require './services/weather-service'
Router             = require './router'

class Server
  constructor: ({appId, @port}) ->
    throw new Error('appId is required') unless appId?
    throw new Error('port is required') unless @port?

    weatherService = new WeatherService({appId})
    @router = new Router({weatherService})

  address: =>
    @server.address()

  start: (callback) =>
    app = express()
    app.set 'port', @port
    app.use errorHandler()
    app.use meshbluHealthcheck()
    app.use morgan 'dev', immediate: false
    app.use bodyParser.json()
    app.use bodyParser.urlencoded(extended: true)
    app.use express.static path.join(__dirname, '..', 'public')
    app.use locationParser

    _.each @router.routes(), (handler, route) =>
      [method, path] = _.split route, ' '
      app[_.lowerCase method](path, handler)

    @server = app.listen app.get('port'), callback

  stop: (callback) =>
    @server.close callback

module.exports = Server

#
#
# process.on 'SIGTERM', =>
#   console.log 'Dying a clean, honorable death'
#   process.exit 0
#
# TemperatureController = require './controllers/temperature-controller'
# temperatureController = new TemperatureController()
#
# return console.error "Missing enviroment APPID" unless process.env.APPID?
#
# app = express()
#
#
#
#
# app.get '/temperature/c', temperatureController.currentCelsius
# app.get '/temperature/celsius', temperatureController.currentCelsius
#
# app.get '/temperature/f', temperatureController.currentFahrenheit
# app.get '/temperature/fahrenheit', temperatureController.currentFahrenheit
#
# app.get '/forecast/f', temperatureController.forecastCelsius
# app.get '/forecast/celsius', temperatureController.forecastCelsius
#
# app.get '/forecast/f', temperatureController.forecastFahrenheit
# app.get '/forecast/fahrenheit', temperatureController.forecastFahrenheit
#
# app.listen app.get('port'), ->
#   console.log "Weather service listening on port #{app.get('port')}"
#
#
#
# #!/usr/bin/env coffee
#
# express        = require 'express'
# path           = require 'path'
# favicon        = require 'serve-favicon'
# morgan         = require 'morgan'
# methodOverride = require 'method-override'
# bodyParser     = require 'body-parser'
# multer         = require 'multer'
# errorHandler   = require 'errorhandler'
# meshbluHealthcheck = require 'express-meshblu-healthcheck'
#
# process.on 'SIGTERM', =>
#   console.log 'Dying a clean, honorable death'
#   process.exit 0
#
# TemperatureController = require './controllers/temperature-controller'
# temperatureController = new TemperatureController()
#
# return console.error "Missing enviroment APPID" unless process.env.APPID?
#
# app = express()
#
# app.use meshbluHealthcheck()
#
# app.set 'port', process.env.WEATHER_SERVICE_PORT ? process.env.PORT ? 80
# app.set 'views', path.join(__dirname, 'views')
# app.set 'view engine', 'jade'
# # app.use favicon(__dirname + '/public/favicon.ico'
# app.use morgan 'dev', immediate: false
# app.use methodOverride()
# app.use bodyParser.json()
# app.use bodyParser.urlencoded(extended: true)
# app.use multer()
# app.use express.static(path.join(__dirname, 'public'))
#
# app.use errorHandler()
#
# app.get '/temperature/c', temperatureController.currentCelsius
# app.get '/temperature/celsius', temperatureController.currentCelsius
#
# app.get '/temperature/f', temperatureController.currentFahrenheit
# app.get '/temperature/fahrenheit', temperatureController.currentFahrenheit
#
# app.get '/forecast/f', temperatureController.forecastCelsius
# app.get '/forecast/celsius', temperatureController.forecastCelsius
#
# app.get '/forecast/f', temperatureController.forecastFahrenheit
# app.get '/forecast/fahrenheit', temperatureController.forecastFahrenheit
#
# app.listen app.get('port'), ->
#   console.log "Weather service listening on port #{app.get('port')}"
