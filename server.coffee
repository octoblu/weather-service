#!/usr/bin/env coffee

express            = require 'express'
path               = require 'path'
compression        = require 'compression'
favicon            = require 'serve-favicon'
morgan             = require 'morgan'
OctobluRaven       = require 'octoblu-raven'
methodOverride     = require 'method-override'
bodyParser         = require 'body-parser'
multer             = require 'multer'
expressVersion     = require 'express-package-version'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
sendError          = require 'express-send-error'


TemperatureController = require './controllers/temperature-controller'
temperatureController = new TemperatureController()

return console.error "Missing enviroment APPID" unless process.env.APPID?

app = express()
app.use compression()
octobluRaven = new OctobluRaven
octobluRaven.patchGlobal()
app.use octobluRaven.express().handleErrors()
app.use sendError()
app.use expressVersion({format: '{"version": "%s"}'})
app.use meshbluHealthcheck()
app.set 'port', process.env.WEATHER_SERVICE_PORT ? process.env.PORT ? 80
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
# app.use favicon(__dirname + '/public/favicon.ico'
skip = (request, response) =>
  return response.statusCode < 400
app.use morgan 'dev', { immediate: false, skip }
app.use methodOverride()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use multer()
app.use express.static(path.join(__dirname, 'public'))

app.get '/temperature/c', temperatureController.currentCelsius
app.get '/temperature/celsius', temperatureController.currentCelsius

app.get '/temperature/f', temperatureController.currentFahrenheit
app.get '/temperature/fahrenheit', temperatureController.currentFahrenheit

app.get '/forecast/c', temperatureController.forecastCelsius
app.get '/forecast/celsius', temperatureController.forecastCelsius

app.get '/forecast/f', temperatureController.forecastFahrenheit
app.get '/forecast/fahrenheit', temperatureController.forecastFahrenheit

server = app.listen app.get('port'), ->
  console.log "Weather service listening on port #{app.get('port')}"

process.on 'SIGTERM', =>
  console.log 'Dying a clean, honorable death'
  server.close =>
    process.exit 0
