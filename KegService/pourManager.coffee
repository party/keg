SockJS = require('sockjs')

PourDao = require('./pourDao')
pourDao = new PourDao


class PourManager

  clients: {}

  constructor: (app) ->
    @server = SockJS.createServer {sockjs_url: "http://cdn.sockjs.org/sockjs-0.3.min.js"}
    @server.installHandlers app, {prefix: "/io"}
    @server.on 'connection', (conn) =>
      console.log 'Receiving socket connection'
      @clients[conn.id] = conn

      setTimeout =>
        @_broadcast {ounces: 400}
      , 2000

      conn.on 'close', =>
        console.log 'Closing socket connection'
        delete @clients[conn.id]

  _broadcast: (data) =>
    for id, client of @clients when @clients.hasOwnProperty(id)
      client.write JSON.stringify(data)

  create: (volume) ->
    pourDao.create(volume)
    @_broadcast JSON.stringify({action: 'done'})

  pour: (volume) ->
    @_broadcast JSON.stringify({
      action: 'pouring'
      amount: volume
    })

  list: (kegId, callback) ->
    pourDao.list(kegId, callback)

  get: (pourId, callback) ->
    pourDao.get(pourId, callback)

  daily: (callback) ->
    pourDao.daily(callback)

  weekly: (callback) ->
    pourDao.weekly(callback)

module.exports = PourManager
