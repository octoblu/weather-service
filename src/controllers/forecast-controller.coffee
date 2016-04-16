
class ForecastController
  constructor: ({@weatherService}) ->
    throw new Error('weatherService is required') unless @weatherService?

  forecastCelsius: (req, res) =>
    {query, city, state, country} = req.location
    @weatherService.forecastInCelsius 

    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','

    if _.isEmpty location
      return res.status(422).send error: 'At least one of [city, state, country] is required'

    @request 'forecast', location, (error, response, body={}) =>
      return res.status(502).send(error) if error?
      forecast = @convertListToHuman(body.list, @kelvinToCelsius)
      res.status(body.cod).send {forecast, city, state, country}

  forecastFahrenheit: (req, res) =>
    {city, state, country} = req.query
    location = _.compact([city, state, country]).join ','

    if _.isEmpty location
      return res.status(422).send error: 'At least one of [city, state, country] is required'

    @request 'forecast', location, (error, response, body={}) =>
      return res.status(502).send(error) if error?

      forecast = @convertListToHuman(body.list, @kelvinToFahrenheit)
      res.status(body.cod).send {forecast, city, state, country}
