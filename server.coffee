#!/usr/bin/env coffee

path           = require 'path'
express        = require 'express'
octobluExpress = require 'express-octoblu'
methodOverride = require 'method-override'

TemperatureController = require './controllers/temperature-controller'
temperatureController = new TemperatureController()

PORT = process.env.PORT ? 80

return throw new Error "Missing enviroment APPID" unless process.env.APPID?

app = octobluExpress()
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use express.static path.join(__dirname, 'public')

app.get '/temperature/c', temperatureController.currentCelsius
app.get '/temperature/celsius', temperatureController.currentCelsius

app.get '/temperature/f', temperatureController.currentFahrenheit
app.get '/temperature/fahrenheit', temperatureController.currentFahrenheit

app.get '/forecast/c', temperatureController.forecastCelsius
app.get '/forecast/celsius', temperatureController.forecastCelsius

app.get '/forecast/f', temperatureController.forecastFahrenheit
app.get '/forecast/fahrenheit', temperatureController.forecastFahrenheit

server = app.listen PORT, ->
  console.log "Weather service listening on port #{server.address().port}"

process.on 'SIGTERM', =>
  console.log 'Dying a clean, honorable death'
  return process.exit 0 unless server?.close?
  server.close =>
    process.exit 0
