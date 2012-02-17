io = (require 'socket.io').listen 7070

io.sockets.on 'connection', (socket) ->
    socket.emit 'djs', [{name: 'nine'}, {name: 'boris'}]
