const webpack = require('webpack');
const path = require('path');

const conf = require('./gulp/gulpconfig');
const webpackBase = require('./webpack.config.base');

const config = {
  output: webpackBase.output,

  module: {
    rules: webpackBase.module.rules.concat(
      [
        // dev loaders
      ]
    ),
  },

  externals: webpackBase.externals,

  devtool: 'eval',

  stats: {
    chunks: false,
    modules: false,
  },

  plugins: [].concat.apply(
    [new webpack.NoEmitOnErrorsPlugin()],
    webpackBase.plugins
  ),
};

module.exports = config;
