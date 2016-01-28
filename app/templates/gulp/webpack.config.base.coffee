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

  ###
  # EXCLUDE REACT FROM BUNDLE
  #
  # Create a dummy-react.js exporting window.React and window.ReactDOM
  #
  # https://github.com/webpack/webpack/issues/1275#issuecomment-123751735
  ###
  # externals:
  #   'react': 'React'
  #   'react-dom': 'ReactDOM'

  # resolve:
  #   alias:
  #     'react': path.resolve(__dirname, '../', conf.path.dev.js, 'lib/dummy-react.js')
  #     'react-dom': path.resolve(__dirname, '../', conf.path.dev.js, 'lib/dummy-react.js')

  devtool: 'source-map'

  plugins: [
    new HappyPack({
      loaders: [{
        path: path.resolve(__dirname, '../node_modules/babel-loader/index.js'),
        query: '?presets[]=es2015,presets[]=react'
      }]
    })
  ]
