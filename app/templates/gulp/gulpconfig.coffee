templates = "src/site/templates"
assets = "#{templates}/assets"

module.exports =
  path:
    db_backup: "database"
    dev:
      assets: "#{assets}"
      css:    "#{assets}/css"
      js:     "#{assets}/js"
      img:    "#{assets}/img"
      fnt:    "#{assets}/fnt"
      scss:   "#{assets}/css/scss"
      coffee: "#{assets}/js/coffee"
      php:    "#{templates}"
      views:  "#{templates}/views"
    prod:
      assets: "#{assets}/public"
      css:    "#{assets}/public/css"
      fnt:    "#{assets}/public/fnt"
      img:    "#{assets}/public/img"
      js:     "#{assets}/public/js"

  plumber:
    errorHandler: false

  ssh:
    port: 22

  rsync:
    up:
      dest: "public_html"
      src: "./src/"
      exclude: [
        ".git*"
        ".DS_Store"
        "node_modules"
        "config-dev.php"
        ".sass-cache"
        "*.scss"
        "*.css.map"
        "assets/css/style.css"
        "assets/js/main.js"
        "*.js.map"
        "*.coffee"
        "assets/cache"
        "assets/files"
        "assets/logs"
        "assets/sessions"
      ]
    down:
      dest: "./src/site/assets"
      src: "public_html/site/assets/files"

  revManifest:
    path: "#{assets}/rev-manifest.json"
    opts:
      merge: true

  revReplace:
    opts:
      "replaceInExtensions": [
        ".js"
        ".css"
      ]
