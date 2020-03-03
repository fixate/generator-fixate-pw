const Fiber = require('fibers');

const templates = 'src/site/templates';
const assets = `${templates}/assets`;

const rsyncExcludes = [
  '*.coffee',
  '*.css.map',
  '*.js.map',
  '*.scss',
  '.DS_Store',
  '.git*',
  '.sass-cache',
  'assets/cache',
  'assets/css',
  'assets/files',
  'assets/js',
  'assets/fnt',
  'assets/img',
  'assets/logs',
  'assets/sessions',
  'config-dev.php',
  'node_modules',
  'src/info.php',
];

const config = {
  path: {
    db_backup: 'database',
    dev: {
      assets: `${assets}`,
      css: `${assets}/css`,
      js: `${assets}/js`,
      img: `${assets}/img`,
      fnt: `${assets}/fnt`,
      scss: `${assets}/css/scss`,
      coffee: `${assets}/js/coffee`,
      php: `${templates}`,
      views: `${templates}/views`,
    },
    prod: {
      assets: `${assets}/public`,
      css: `${assets}/public/css`,
      fnt: `${assets}/public/fnt`,
      img: `${assets}/public/img`,
      js: `${assets}/public/js`,
    },
  },

  revManifest: {
    path: `${assets}/rev-manifest.json`,
    opts: {
      merge: true,
    },
  },

  revReplace: {
    opts: {
      replaceInExtensions: ['.js', '.css'],
    },
  },

  rsync: {
    prodUp: {
      dest: 'public_html',
      src: './src/',
      exclude: rsyncExcludes,
    },
    prodDown: {
      dest: './src/site/assets',
      src: 'public_html/site/assets/files',
    },
  },

  sass: {
    fiber: Fiber,
    includePaths: ['node_modules/normalize.css'],
  },

  ssh: {
    port: 22,
  },
};

module.exports = config;
