GitUtils = require './lib/git-utils'
myUtils  = require './lib/utils'
fs       = require 'fs'
mkdirp   = require 'mkdirp'
path     = require 'path'
shell    = require 'shelljs'
yeoman   = require 'yeoman-generator'

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

    prompts.push
      type: 'checkbox',
      name: 'pwModules',
      message: 'Which ProcessWire modules would you like to install?',
      choices: myUtils.getMultiChoices(@settings.github.pwModules)

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
      mkdirp d for d in [
        'src',
        'database/dev',
        'database/prod',
        'styleguide'
      ]

      copyFile = (obj) =>
        @fs.copy(
          @templatePath(obj.from),
          @destinationPath(obj.to)
        )

      copyTmpl = (obj) =>
        @fs.copyTmpl(
          @templatePath(obj.from),
          @destinationPath(obj.to)
        )

      [
        { from: ".babelrc", to: ".babelrc" },
        { from: ".bowerrc", to: ".bowerrc" },
        { from: ".editorconfig", to: ".editorconfig" },
        { from: ".eslintrc.json", to: ".eslintrc.json" },
        { from: ".agignore", to: ".agignore" },
        { from: ".gitignore", to: ".gitignore" },
        { from: ".gitignore_pw", to: "src/.gitignore" },
        { from: ".gitkeep", to: "database/dev/.gitkeep" },
        { from: ".gitkeep", to: "database/prod/.gitkeep" },
        { from: ".env.example", to: ".env.example" },
        { from: ".prettierrc", to: ".prettierrc" },
        { from: ".tmuxinator.yml.example", to: ".tmuxinator.yml.example" },
        { from: "bower.json", to: "bower.json" },
        { from: "gulpfile.js", to: "gulpfile.js" },
        { from: "package.json", to: "package.json" },
        { from: "setup.js", to: "setup.js" },
        { from: "gulp/secrets-sample.js", to: "gulp/secrets.js"},
        { from: "package.json", to: "package.json" },
        { from: "setup.js", to: "setup.js"},
        { from: "webpack.config.base.js", to: "webpack.config.base.js"},
        { from: "webpack.config.dev.js", to: "webpack.config.dev.js"},
        { from: "webpack.config.prod.js", to: "webpack.config.prod.js"},
        { from: "gulp", to: "gulp" },
        { from: "docker", to: "docker" },
        { from: "docker-compose.yml", to: "docker-compose.yml" },
      ].map(copyFile)

      @template "_robots.txt",              "src/robots.txt"




    #*------------------------------------*\
    #   $PROCESSWIRE
    #*------------------------------------*/
    setupProcesswire = () =>
      @log.info "Installing ProcessWire..."
      repo_path = GitUtils.cacheRepo github(@settings.github.processwire)
      @log.info "Copying ProcessWire install..."
      GitUtils.export repo_path, dest('src/'), @props.pwBranch

      at dest('/'), ->
        shell.rm "-rf", "src/site-default"

      @log.ok('OK')


      @log.info "Installing ProcessWire site profile..."
      repo_path = GitUtils.cacheRepo github(@settings.github.pwProfile)
      GitUtils.export repo_path, dest('src')
      at dest('src/'), () =>
        shell.rm ".gitignore"
        shell.rm "README.md"

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

      # remove alternative ProcessWire site profiles
      at dest('src/'), () =>
        shell.rm '-rf', "site-beginner"
        shell.rm '-rf', "site-blank"
        shell.rm '-rf', "site-classic"
        shell.rm '-rf', "site-languages"

      # ensure processwire assets are committed
      at dest('src/site/'), () =>
        shell.mkdir 'assets/cache/'
        shell.mkdir 'assets/files/'
        shell.mkdir 'assets/logs/'
        shell.mkdir 'assets/sessions/'
        shell.chmod '-rf 777', 'assets/cache/'
        shell.chmod '-rf 777', 'assets/files/'
        shell.chmod '-rf 777', 'assets/logs/'
        shell.chmod '-rf 777', 'assets/sessions/'

      @copy ".gitkeep", "src/site/assets/cache/.gitkeep"
      @copy ".gitkeep", "src/site/assets/sessions/.gitkeep"
      @copy ".gitkeep", "src/site/assets/files/.gitkeep"
      @copy ".gitkeep", "src/site/assets/logs/.gitkeep"

      # setup for ProcessWire install
      at dest('src/'), () =>
        shell.chmod '777',    "site/assets"
        shell.chmod '777',    "site/assets/*"
        shell.chmod '777',    "site/modules"
        shell.chmod '777',    "site/config.php"
        shell.chmod '777',    "site/install"
        shell.chmod '777',    "install.php"

      @log.ok('OK')




    #*------------------------------------*\
    #   $Processwire Modules
    #*------------------------------------*/
    setupProcessWireModules = () =>
      Object.keys(@settings.github.pwModules).map (item) ->
        at dest('src/site/modules/'), () =>
          shell.mkdir item

      @log.info "Installing processwire modules..."
      for module in @props.pwModules
        repo_path = GitUtils.cacheRepo github(module)
        @log.info "Copying #{module} install..."
        GitUtils.export repo_path, dest("src/site/modules/#{myUtils.getObjectKey(module, @settings.github.pwModules)}")




    #*------------------------------------*\
    #   $STYLEGUIDE
    #*------------------------------------*/
    setupStyleguide = () =>
      @log.info "Installing fabricator styleguide / UI toolkit"
      repo_path = GitUtils.cacheRepo github(@settings.github.styleguide)
      mkdirp 'styleguide'
      GitUtils.export repo_path, dest('styleguide/')

      @log.ok('OK')




    #*------------------------------------*\
    #   $CSS FRAMEWORK
    #*------------------------------------*/
    setupCSSFramework = () =>
      @log.info "Installing CSS framework..."

      repo_path = GitUtils.cacheRepo github(@settings.github.cssFramework)
      GitUtils.export repo_path, dest('src/site/templates/assets/css/'), @props.cssBranch

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
    setupProcessWireModules()
    setupStyleguide()
    setupCSSFramework()
    setupGit()
