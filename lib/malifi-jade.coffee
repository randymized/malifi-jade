###!
 * malifi-jade
 * Copyright(c) 2013 Randy McLaughlin <8b629a9884@snkmail.com>
 * MIT Licensed
###
jade= require('jade')
fs= require('fs')

module.exports= jade_renderer=
  compile_file: (req,res,filename,when_compiled)->
    fs.readFile filename, 'utf8', (err, template)->
      if (err)
        when_compiled(err)
      else
        try
          options= req.malifi.meta.ext_malifi_jade_options_ || {}
          options.filename= filename
          compiled= jade.compile(template,options)
          when_compiled null,
            render: (context,done)->
              try
                done(null, compiled(context))
              catch err
                done(err)
        catch err
          when_compiled(err)