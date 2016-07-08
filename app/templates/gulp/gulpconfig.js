(function() {
  var assets, templates;

  templates = "src/site/templates";

  assets = templates + "/assets";

  module.exports = {
    path: {
      db_backup: "database",
      dev: {
        assets: "" + assets,
        css: templates + "/css",
        js: templates + "/js/src",
        img: assets + "/img",
        icons: assets + "/img/icons",
        fnt: templates + "/fnt",
        scss: templates + "/css/scss",
        coffee: templates + "/js/coffee",
        php: "" + templates,
        views: "" + templates
      },
      prod: {
        assets: assets + "/public",
        css: templates + "/css",
        fnt: assets + "/public/fnt",
        img: assets + "/img",
        js: templates + "/js/dist"
      }
    },
    ssh: {
      port: 22
    },
    rsync: {
      up: {
        dest: "public_html",
        src: "./src/",
        exclude: [".git*", ".DS_Store", "node_modules", "config-dev.php", ".sass-cache", "*.scss", "*.css.map", "assets/css/style.css", "assets/js/main.js", "*.js.map", "*.coffee", "assets/cache", "assets/files", "assets/logs", "assets/sessions"]
      },
      down: {
        dest: "./src/site/assets",
        src: "public_html/site/assets/files"
      }
    },
    revManifest: {
      path: assets + "/rev-manifest.json",
      opts: {
        merge: true
      }
    },
    revReplace: {
      opts: {
        "replaceInExtensions": [".js", ".css"]
      }
    }
  };

}).call(this);
