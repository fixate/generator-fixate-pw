GitUtils = require './lib/git-utils'
myUtils  = require './lib/utils'
yeoman   = require 'yeoman-generator'
shell    = require 'shelljs'
fs       = require 'fs'
path     = require 'path'

module.exports = class FixatePwGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    super args, options, config

    @on "end", ->
      @installDependencies skipInstall: options["skip-install"]

    @pkg = myUtils.loadJSON("../package.json", __dirname)
    @settings = myUtils.loadJSON("./settings.json", __dirname)

  askFor: () =>
    cb = @async()


    #*------------------------------------*\
    #   $YEOMAN PROMPTS
    #*------------------------------------*/
    console.log @yeoman
    prompts = []
    prompts.push
      name: "pwBranch"
      message: "Which branch of ProcessWire would you like to use?"
      default: "master"

    prompts.push
      name: "cssBranch"
      message: "Which branch of the CSS Framework would you like to use?"
      default: 'inuit'

    prompts.push
      name: "domain"
      message: "What is the domain name for the production website (without protocol)?"
      default: "example.com"

    @prompt prompts, (props) =>
      @props = props
      cb()

  app: () =>
    github = (repo) ->
      "https://github.com/#{repo}.git"

    dest = (p = '/') =>
      path.join(@destinationRoot(), p)

    at = (p, cb) ->
      try
        shell.pushd p
        cb()
      finally
        shell.popd()


    #*------------------------------------*\
    #   $REPOSITORY
    #*------------------------------------*/
    setupRepo = () =>
      @mkdir d for d in [
        'src',
        'database/dev',
        'database/prod',
        'styleguide'
      ]

      @copy ".bowerrc",             ".bowerrc"
      @copy ".editorconfig",        ".editorconfig"
      @copy ".gitattributes",       ".gitattributes"
      @copy ".gitignore",           ".gitignore"
      @copy ".gitignore_pw",        "src/.gitignore"
      @copy ".gitkeep",             "database/dev/.gitkeep"
      @copy ".gitkeep",             "database/prod/.gitkeep"
      @copy "setup.sh",             "setup.sh"
      @copy "private-sample.json",  "private-sample.json"
      @copy "private-sample.json",  "private.json"
      @copy "gulpfile.coffee",      "gulpfile.coffee"
      @copy "gulpconfig.json",      "gulpconfig.json"
      @template "_package.json",    "package.json"
      @template "_robots.txt",      "src/robots.txt"




    #*------------------------------------*\
    #   $PROCESSWIRE
    #*------------------------------------*/
    setupProcesswire = () =>
      @log.info "Installing ProcessWire..."
      repo_path = GitUtils.cacheRepo github(@settings.github.processwire)
      @log.info "Copying ProcessWire install..."
      GitUtils.export repo_path, dest('src/'), @props.pwBranch

      at dest('/'), ->
        shell.mv "src/site-default", "src/site"

      @log.ok('OK')

      @log.info "Installing ProcessWire MVC boilerplate..."
      repo_path = GitUtils.cacheRepo github(@settings.github.pwBoilerplate)
      GitUtils.export repo_path, dest('src/site/templates')
      at dest('src/'), () =>
        shell.ls('-A', "site/templates/\!root/*").forEach (file) ->
          shell.mv '-f', file, '.'
        shell.rm '-rf', "site/templates/\!root"
        shell.rm ".gitignore"
        shell.rm "robots.txt"

      # remove default ProcessWire templates
      at dest('src/site/templates/'), () =>
        shell.rm '-rf', "scripts"
        shell.rm '-rf', "styles"
        shell.rm "README.txt"
        shell.rm "basic-page.php"
        shell.rm "search.php"
        shell.rm "sitemap.php"
        shell.rm "home.php"
        shell.rm "_init.php"
        shell.rm "_main.php"
        shell.rm "_func.php"

      # remove alternative ProcessWire site profiles
      at dest('src/'), () =>
        shell.rm '-rf', "site-beginner"
        shell.rm '-rf', "site-blank"
        shell.rm '-rf', "site-classic"
        shell.rm '-rf', "site-languages"

      # ensure processwire assets are committed
      @copy ".gitkeep", "src/site/assets/cache/.gitkeep"
      @copy ".gitkeep", "src/site/assets/sessions/.gitkeep"
      @copy ".gitkeep", "src/site/assets/files/.gitkeep"
      @copy ".gitkeep", "src/site/assets/logs/.gitkeep"

      # setup for ProcessWire install
      at dest('src/site/'), () =>
        shell.chmod '777', "assets"
        shell.chmod '777', "assets/*"
        shell.chmod '777', "modules"
        shell.chmod '777', "config.php"

      @log.ok('OK')


    #*------------------------------------*\
    #   $KSS BOILERPLATE
    #*------------------------------------*/
    setupKSS = () =>
      @log.info "Installing KSS Boilerplate"
      repo_path = GitUtils.cacheRepo github(@settings.github.kssBoilerplate)
      @mkdir 'styleguide'
      GitUtils.export repo_path, dest('styleguide/')
      at dest('styleguide/'), () =>
        @log.info 'KSS Living Styleguide - bundle install'
        GitUtils.exec 'bundle install'
        shell.mv '-f', './scss', '../src/site/templates/assets/css'

      @log.ok('OK')


    #*------------------------------------*\
    #   $CSS FRAMEWORK
    #*------------------------------------*/
    setupCSSFramework = () =>
      @log.info "Installing CSS framework..."

      repo_path = GitUtils.cacheRepo github(@settings.github.cssFramework)
      GitUtils.export repo_path, dest('src/site/templates/assets/css/'), @props.cssBranch

      at dest('styleguide/'), ->
        shell.mv "style.css", "../src/site/templates/assets/css/style.css"
        shell.rm "style.css"

      @log.ok('OK')


    #*------------------------------------*\
    #   $GIT
    #*------------------------------------*/
    setupGit = () =>
      GitUtils.init(dest())


    #*------------------------------------*\
    #   $DO IT
    #*------------------------------------*/
    setupRepo()
    setupProcesswire()
    setupKSS()
    setupCSSFramework()
    setupGit()
