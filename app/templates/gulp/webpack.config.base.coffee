HappyPack = require 'happypack'
path      = require 'path'

conf      = require('./gulpconfig')

module.exports =
  output:
    path: path.join(__dirname, '../', conf.path.dev.js)
    filename: './[name].bundle.js'

  module:
    loaders: [
      {
        test: /\.jsx?$/
        exclude: /node_modules/
        loader: 'happypack/loader'
      }
    ]

  # Exclude React from your bundle
  externals:
    'react': 'React'
    'react-dom': 'ReactDOM'

  devtool: 'source-map'

  plugins: [
    new HappyPack({
      loaders: [{
        path: path.resolve(__dirname, '../node_modules/babel-loader/index.js'),
        query: '?presets[]=es2015,presets[]=react'
      }]
    })
  ]
