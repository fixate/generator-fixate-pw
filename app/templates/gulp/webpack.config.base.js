(function () {
    var CleanPlugin, CommonsPlugin, HappyPack, conf, path, production, webpack;

    HappyPack = require('happypack');

    path = require('path');

    CommonsPlugin = new require("webpack/lib/optimize/CommonsChunkPlugin");

    CleanPlugin = require('clean-webpack-plugin');

    production = process.env.NODE_ENV === 'production';

    webpack = require('webpack');

    conf = require('./gulpconfig');

    module.exports = {
        debug: true,
        //devtool: production != null ? production : {
        //    "false": 'eval'
        //},
        devtool: 'source-map',
        output: {
            path: path.join(__dirname, '../', conf.path.prod.js),
            filename: production != null ? production : {
                '[name]-[hash].js': 'bundle.js'
            },
            chunkFilename: '[name]-[chunkhash].js',
            publicPath: '/site/templates/js/dist/'
        },
        module: {
            loaders: [
                {
                    test: /\.jsx?$/,
                    exclude: /node_modules/,
                    loader: 'happypack/loader'
                },
                {test: /\.css$/, loader: "style-loader!css-loader"}

                //{
                //    test: /\.coffee?$/,
                //    exclude: /(node_modules|bower_components)/,
                //    loader: 'babel', // 'babel-loader' is also a legal name to reference
                //    query: {
                //        presets: ['es2015']
                //    }
                //},
            ]
        },
        externals: {
            'react': 'React',
            'react-dom': 'ReactDOM',
            "jquery": "jQuery"

        },
        plugins: [
            new HappyPack({
                loaders: [
                    {
                        path: path.resolve(__dirname, '../node_modules/babel-loader/index.js'),
                        query: '?presets[]=es2015,presets[]=react',
                        threads: 4
                    }
                ]
            }),
            new webpack.optimize.DedupePlugin, new webpack.optimize.OccurenceOrderPlugin, new webpack.optimize.MinChunkSizePlugin({
                minChunkSize: 51200
            }), new webpack.optimize.CommonsChunkPlugin({
                minChunks: 2,
                name: "main"
            }), new webpack.ProvidePlugin({
                $: "jquery",
                jQuery: "jquery"
            })
            //,new webpack.optimize.UglifyJsPlugin({
            //    compress: {
            //        warnings: false
            //    }
            //})
        ]
    };

}).call(this);
