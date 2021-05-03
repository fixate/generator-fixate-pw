const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');
const path = require('path');

const conf = require('./gulp/gulpconfig');
const webpackBase = require('./webpack.config.base');

const config = {
  mode: 'production',

  output: {
    path: path.join(__dirname, conf.path.prod.js),
    publicPath: '/assets/public/js/',
    filename: '[name].bundle.min.js',
  },

  module: {
    rules: webpackBase.module.rules.concat([
      // prod loaders
    ]),
  },

  externals: webpackBase.externals,

  stats: webpackBase.stats,

  plugins: webpackBase.plugins,

  optimization: {
    minimize: true,
    minimizer: [new TerserPlugin()],
  },
};

module.exports = config;
