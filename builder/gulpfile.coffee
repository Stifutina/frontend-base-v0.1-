# node modules
fs = require 'fs'
yaml = require 'js-yaml'

# gulp modules
gulp = require 'gulp'
gulpLoadPlugins = require 'gulp-load-plugins'
g = gulpLoadPlugins()

client  = require('tiny-lr')()
lr_port = 35728

# config.yml file
config = yaml.load(fs.readFileSync("config.yml", "utf8"))

consoleErorr = (err) ->
  g.util.beep()
  console.log err.message
  return

gulp.task 'bower', ->
  g.bower config.paths.built.libs

gulp.task 'html', ->
  gulp.src [config.paths.built.html.all]
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.livereload client
  .pipe g.notify {message: 'Views refreshed'}

gulp.task 'css', ->
  gulp.src config.paths.built.styles.path + '/' + config.paths.built.styles.file
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.livereload client
  .pipe g.notify {message: 'Styles refreshed'}

gulp.task 'lint', ->
  gulp.src(config.paths.built.scripts.all)
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.jshint()
  .pipe g.livereload client
  .pipe g.notify {message: 'Lint done'}

gulp.task 'sprite', ->
  spriteData = gulp.src config.paths.src.sprites.images.all
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.spritesmith
    imgName: 'sprite.png'
    cssName: 'sprite.styl'
    padding: 2
    cssFormat: 'stylus'
    algorithm: 'binary-tree'
    cssTemplate: 'stylus.template.mustache'
    cssVarMap: (sprite) ->
      sprite.name = 's-' + sprite.name
      return

  spriteData.img.pipe(gulp.dest(config.paths.built.images.design.path));
  spriteData.css.pipe(gulp.dest(config.paths.src.sprites.style));

  return

gulp.task 'coffee', ->
  gulp.src config.paths.src.scripts.all
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.coffee
    bare: true
  .pipe gulp.dest config.paths.built.scripts.path

gulp.task 'vendor', ->
  gulp.src config.paths.src.scripts.vendor.all
  .pipe gulp.dest config.paths.built.scripts.vendor.path

gulp.task 'stylus', ->
  gulp.src config.paths.src.styles.main
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.stylus()
  .pipe gulp.dest config.paths.built.styles.path + '/'
  .pipe g.livereload client
  .pipe g.notify {message: 'Stylus done'}

gulp.task 'concat-css', ['stylus'], ->
  gulp.src [
    config.paths.built.styles.path + '/' + config.paths.built.styles.file
  ]
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.concat(config.paths.built.styles.file)
  .pipe gulp.dest config.paths.built.styles.path + '/'

gulp.task 'images', ->
  gulp.src [config.paths.src.images.all, '!'+config.paths.src.sprites.images.all]
  .pipe gulp.dest config.paths.built.images.path

gulp.task 'jade', ->
  gulp.src config.paths.src.templates.pages.all
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.jade
    pretty: true
    locals: {version: '0.0.1'}
  .pipe gulp.dest config.paths.built.path

gulp.task 'autoprefixer', ->
  gulp.src config.paths.built.styles.all
  .pipe g.autoprefixer()
  .pipe gulp.dest config.paths.built.styles.path

gulp.task 'fonts', ->
  gulp.src config.paths.built.fonts.bootsrap
  .pipe gulp.dest config.paths.built.fonts.all


gulp.task 'scripts:min', ->
  gulp.src config.paths.built.scripts.path + '/' + config.paths.built.scripts.file
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.uglify()
  .pipe g.rename({extname: '.min.js'})
  .pipe gulp.dest config.paths.built.scripts.path


gulp.task 'styles:min', ['concat-css'], ->
  gulp.src config.paths.built.styles.path + '/' + config.paths.built.styles.file
  .pipe g.plumber
    errorHandler: consoleErorr
  .pipe g.minifyCss()
  .pipe g.rename({extname: '.min.css'})
  .pipe gulp.dest config.paths.built.styles.path

gulp.task 'live', ->
  client.listen lr_port, (err)->
    if (err)
      console.error err

gulp.task 'watch', ->
  gulp.watch config.paths.src.scripts.all, ['coffee']
  gulp.watch config.paths.built.scripts.path+'/'+config.paths.built.scripts.file, ['scripts:min']
  gulp.watch [config.paths.src.styles.parts.blocks, config.paths.src.styles.parts.common, config.paths.src.styles.parts.helpers], ['styles:min']
  gulp.watch config.paths.src.images.all, ['images']
  gulp.watch config.paths.src.sprites.images.all, ['sprite']
  gulp.watch config.paths.src.templates.all, ['jade']

  return



gulp.task 'default', ['bower', 'sprite', 'css', 'lint', 'styles:min', 'scripts:min', 'fonts', 'images', 'html', 'jade']


gulp.task 'dev', ['default', 'watch']


gulp.task 'minify', ['scripts:min', 'styles:min']


gulp.task 'prod', ['default', 'autoprefixer'], ->
  gulp.start 'minify'
