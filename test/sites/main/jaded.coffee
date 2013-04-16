module.exports= (req,res,next)->
  req.malifi.render 'text/html',
    name: 'me'
    email: 'human@example.com'
