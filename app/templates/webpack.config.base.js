const path = require('path');

const conf = require('./gulp/gulpconfig');

const config = {
  output: {
    path: path.join(__dirname, conf.path.dev.js),
    publicPath: '/assets/js/',
    filename: '[name].bundle.js',
  },

  externals: {
    jQuery: 'jQuery',
  },

  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
    ],
  },

  plugins: [],
};

module.exports = config;
