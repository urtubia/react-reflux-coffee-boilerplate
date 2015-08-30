express = require('express')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
morgan = require('morgan')

app = express()

# Router
# http://scotch.io/tutorials/javascript/learn-to-use-the-new-router-in-expressjs-4

# Passport
# http://scotch.io/tutorials/javascript/upgrading-our-easy-node-authentication-series-to-expressjs-4-0
# http://scotch.io/tutorials/javascript/easy-node-authentication-setup-and-local

# Restful
# http://scotch.io/tutorials/javascript/build-a-restful-api-using-node-and-express-4

app.use morgan('dev')
app.use cookieParser()
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })
app.use express.static __dirname + '/../public'

server = app.listen 3000, () ->
  host = server.address().address
  port = server.address().port

  console.log "Listening on #{host} #{port}"
