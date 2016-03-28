#!/usr/bin/env coffee

express        = require 'express'
path           = require 'path'
favicon        = require 'serve-favicon'
morgan         = require 'morgan'
methodOverride = require 'method-override'
bodyParser     = require 'body-parser'
multer         = require 'multer'
errorHandler   = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'

process.on 'SIGTERM', =>
  console.log 'Dying a clean, honorable death'
  process.exit 0

TemperatureController = require './controllers/temperature-controller'
temperatureController = new TemperatureController()

return console.error "Missing enviroment APPID" unless process.env.APPID?

app = express()

app.use meshbluHealthcheck()

app.set 'port', process.env.WEATHER_SERVICE_PORT ? process.env.PORT ? 80
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
# app.use favicon(__dirname + '/public/favicon.ico'
app.use morgan 'dev', immediate: false
app.use methodOverride()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use multer()
app.use express.static(path.join(__dirname, 'public'))

app.use errorHandler()

app.get '/temperature/c', temperatureController.currentCelsius
app.get '/temperature/celsius', temperatureController.currentCelsius

app.get '/temperature/f', temperatureController.currentFahrenheit
app.get '/temperature/fahrenheit', temperatureController.currentFahrenheit

app.get '/forecast/f', temperatureController.forecastCelsius
app.get '/forecast/celsius', temperatureController.forecastCelsius

app.get '/forecast/f', temperatureController.forecastFahrenheit
app.get '/forecast/fahrenheit', temperatureController.forecastFahrenheit

app.listen app.get('port'), ->
  console.log "Weather service listening on port #{app.get('port')}"
