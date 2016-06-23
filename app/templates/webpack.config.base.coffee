path = require 'path'

conf = require './gulp/gulpconfig'

module.exports =
  output:
    path: path.join(__dirname, conf.path.dev.js)
    publicPath: '/assets/js/'
    filename: '[name].bundle.js'

  externals:
    'jQuery': 'jQuery'

  module:
    loaders: [
      {
        test: /\.jsx?$/
        exclude: /node_modules/
        loaders: ['babel']
      }
    ]

  plugins: []
