_      = require 'lodash'
Server = require './src/server'

class Command
  getOpts: =>
    return @panic new Error('Missing enviroment APPID') if _.isEmpty process.env.APPID
    return {
      appId: process.env.APPID
      port:  process.env.WEATHER_SERVICE_PORT ? process.env.PORT ? 80
    }

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: (argv) =>
    {appId, port} = @getOpts()

    process.on 'SIGTERM', @onSIGTERM

    @server = new Server {appId, port}
    @server.start (error) =>
      return @panic error if error?
      {hostname, port} = @server.address()
      console.log "Listening: #{hostname}:#{port}"

  onSIGTERM: =>
    @server.stop (error) =>
      console.log 'Dying a clean, honorable death'
      process.exit 0

    setTimeout (=> @panic new Error 'Timeout exceeded. Dishonorably shutting down'), 10000

command = new Command
command.run()
