const webpack = require('webpack');
const path    = require('path');

const conf        = require('./gulp/gulpconfig');
const webpackBase = require('./webpack.config.base');

const config = {
  output: webpackBase.output,

  module: {
    loaders: webpackBase.module.loaders.concat([
      // dev loaders
    ])
  },

  externals: webpackBase.externals,

  devtool: 'source-map',

  plugins:
    [].concat.apply([
      new webpack.NoErrorsPlugin(),
    ], webpackBase.plugins)
};

module.exports = config;
