_ = require 'lodash'

locationParser = (req, res, next) ->
  {city, state, country} = req.query
  query = _.compact([city, state, country]).join ','

  if _.isEmpty query
    return res.status(422).send error: 'At least one of [city, state, country] is required'

  req.location = {query, city, state, country}
  next()

module.exports = locationParser
