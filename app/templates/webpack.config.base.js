const path = require('path');

const conf = require('./gulp/gulpconfig');

const config = {
  output: {
    path: path.join(__dirname, conf.path.dev.js),
    publicPath: '/assets/js/',
    filename: '[name].bundle.js'
  },

  externals: {
    'jQuery': 'jQuery'
  },

  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loaders: ['babel']
      }
    ]
  },

  plugins: []
};

module.exports = config;
