request = require 'request'

process.env.APPID = 'this-will-not-work'
process.env.PORT = 0xdead

require '../'

describe 'Server', ->
  describe '/healthcheck', ->
    beforeEach (done) ->
      request.get "http://localhost:#{0xdead}/healthcheck", { json: true }, (error, @response, @body) =>
        done error

    it 'should respond with a 200', ->
      expect(@response.statusCode).to.equal 200

    it 'should respond with online true', ->
      expect(@body).to.deep.equal online: true
