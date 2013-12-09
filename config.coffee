exports.config =
  # See http://brunch.io/#documentation for docs.
  server:
    path: 'server.js', port: 3333, base: '/', run: yes
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(bower_components|vendor)/
        'test/test.js': /^test/
      order:
        after: [
          'test/vendor/scripts/test-helper.js'
        ]

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(?!test)/
        'test/test.css': /^test/
      order:
        after: ['vendor/styles/helpers.css']

    templates:
      joinTo: 'javascripts/app.js'

  plugins:
    sass:
      debug: 'comments'
    cleancss:
      keepSpecialComments: 0
      removeEmpty: true
    uglify:
      mangle: false
      compress:
        global_defs:
          DEBUG: false