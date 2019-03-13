const webpack = require('webpack');
const path = require('path');

const conf = require('./gulp/gulpconfig');
const webpackBase = require('./webpack.config.base');

const config = {
  mode: 'development',

  output: webpackBase.output,

  module: {
    rules: webpackBase.module.rules.concat([
      // dev loaders
    ]),
  },

  externals: webpackBase.externals,

  devtool: 'cheap-module-eval-source-map',

  stats: webpackBase.stats,

  plugins: webpackBase.plugins.concat([]),
};

module.exports = config;
