_= require('underscore')
path= require('path')
connect= require('connect')
assert = require('assert')
malifi = require('malifi')
http = require('http')
port= 8889
host = 'localhost'

app= connect.createServer()
app.use(connect.urlencoded())
app.use(malifi(__dirname+'/sites/main'))
app.listen(port)

getResponse= (res,expected,statusCode,done)->
  if _.isFunction(expected)
    done= expected
  buf= ''
  res.statusCode.should.equal(statusCode)
  res.setEncoding('utf8')
  res.on 'data', (chunk)->
    buf += chunk
  res.on 'end', ()->
    if _.isFunction(expected)
      expected(null,buf,res)
    else
      buf.should.equal(expected)
      done()
  res.on 'error', (exception) ->
    done(exception)

get= (url, expected, statusCode, done)->
  unless done?
    done= statusCode
    statusCode=200
  options =
    host: host,
    port: port,
    path: url
    headers:
      accept: 'text/html'
  req= http.get options, (res)->
    if typeof expected is 'number'
      res.statusCode.should.equal(expected)
      done()
    else
      getResponse(res,expected,statusCode,done)

describe 'Malifi', ->
  before (cb) ->
    process.nextTick cb
  after ->
    app.close

  it 'should render a jade template', (done) ->
    get('/jaded','<div id="user">me &lt;human@example.com&gt;</div>', done)

  it 'should render a bare jade template that has extends a layout template', (done) ->
    get('/extended','<html><head><title>My Site</title></head><body><h1>a simple page</h1><p>my content</p><div id="footer"><p>some footer content</p></div></body></html>', done)

  # Answers the question of whether an include in another included or extended file is relative to the original file or to the
  # included file.  Shows that include and extends are indeed relative to the file they are in and jumping around paths is not
  # a problem.
  it 'should render jade template in a subdirectory based upon a layout in the main directory that in turn includes another main directory file', (done) ->
    get('/sub/sub/extended','<html><head><title>My Site</title></head><body><h1>a simple page</h1><p>my content</p><div id="footer"><p>some footer content</p></div></body></html>', done)
