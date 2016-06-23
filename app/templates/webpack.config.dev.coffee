webpack   = require 'webpack'
path      = require 'path'

conf      = require('./gulp/gulpconfig')
webpackBase = require './webpack.config.base'

module.exports =
  output: webpackBase.output

  module:
    loaders: webpackBase.module.loaders.concat([
      # dev loaders
    ])

  externals: webpackBase.externals

  devtool: 'source-map'

  plugins:
    [].concat.apply([
      new webpack.NoErrorsPlugin(),
    ], webpackBase.plugins)
