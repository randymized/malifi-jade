malifi-jade
===========

Adds Jade template support to Malifi.

Usage:
In the metadata `template_map_` object for the target MIME type, map file extension(s) to `malifi-jade`.

For example, to establish template mapping for an entire site, in the site's root directory `_default.meta.coffee` file:
```
malifi_jade= require 'malifi-jade'

module.exports=
  template_map_:
    'text/html': [
      ['jade', malifi_jade]
    ]
```

Remember that Malifi can map file extensions to template engine, so the following map would choose either the Jade or the Underscore template engine, based on file extension:

```
module.exports=
  template_map_:
    'text/html': [
      ['jade', malifi_jade]
      ['html', malifi_consolidate('underscore')]
    ]
```

Alternatively, the site-wide mapping of Jade templates could be expressed in Javascript in `_default.meta.js` as:
```
(function() {
  var malifi_jade;

  malifi_jade = require('../../../index');

  module.exports = {
    template_map_: {
      'text/html': [
        ['jade', malifi_jade]
      ]
    }
  };

}).call(this);
```

Of course, the metadata file could define other metadata, and the mapping could be established for any directory or even for individual URLs.

## Options

If `ext_malifi_jade_options_` is defined in metadata, those options will be passed to Jade's `compile` function.  The filename option will always be set by malifi-jade to the name of the template file.

