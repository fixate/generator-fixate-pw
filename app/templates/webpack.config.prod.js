const webpack = require('webpack');
const path = require('path');

const conf = require('./gulp/gulpconfig');
const webpackBase = require('./webpack.config.base');

const config = {
  output: Object.assign({}, webpackBase.output, {
    filename: '[name].bundle.min.js',
    path: path.join(__dirname, conf.path.prod.js),
    publicPath: '/assets/public/js/',
  }),

  module: {
    rules: webpackBase.module.rules.concat(
      [
        // dev loaders
      ]
    ),
  },

  externals: webpackBase.externals,

  devtool: 'source-map',

  plugins: webpackBase.plugins.concat([]),

  stats: webpackBase.stats,

  node: webpackBase.node,
};

module.exports = config;
