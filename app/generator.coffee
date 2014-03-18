GitUtils = require './lib/git-utils'
myUtils = require './lib/utils'
yeoman = require 'yeoman-generator'
shell = require 'shelljs'
fs = require 'fs'
path = require 'path'

module.exports = class FixatePwGenerator extends yeoman.generators.Base
	constructor: (args, options, config) ->
		super args, options, config

		@on "end", ->
			@installDependencies skipInstall: options["skip-install"]

		@pkg = myUtils.loadJSON("../package.json", __dirname)
		@settings = myUtils.loadJSON("./settings.json", __dirname)

	askFor: =>
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

	app: =>
		github = (repo) ->
			"https://github.com/#{repo}.git"

		dest= (p = '/')=>
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
		setupRepo = =>
			@mkdir d for d in [
				'src',
				'database/dev',
				'database/prod',
				'styleguide'
			]

			@copy "_bowerrc", ".bowerrc"
			@copy "_gitignore", ".gitignore"
			@copy "_gitattributes", ".gitattributes"
			@copy "_gitkeep", "database/dev/.gitkeep"
			@copy "_gitkeep", "database/prod/.gitkeep"
			@copy "_package.json", "package.json"
			@copy "_private-sample.json", "private-sample.json"
			@copy "_private-sample.json", "private.json"
			@template "_robots.txt", "src/robots.txt"


		#*------------------------------------*\
		#   $PROCESSWIRE
		#*------------------------------------*/
		setupProcesswire = =>
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
			at dest('src/'), =>
				shell.ls('-A', "site/templates/\!root/*").forEach (file) ->
					shell.mv '-f', file, '.'
				shell.rm '-rf', "site/templates/\!root"
				shell.rm ".gitignore"
				shell.rm "robots.txt"

			@log.ok('OK')


		#*------------------------------------*\
		#   $KSS BOILERPLATE
		#*------------------------------------*/
		setupKSS = =>
			@log.info "Installing KSS Boilerplate"
			repo_path = GitUtils.cacheRepo github(@settings.github.kssBoilerplate)
			@mkdir 'styleguide'
			GitUtils.export repo_path, dest('styleguide/')
			at dest('styleguide/'), =>
				@log.info 'KSS Living Styleguide - bundle install'
				GitUtils.exec 'bundle install'

			@log.ok('OK')


		#*------------------------------------*\
		#   $CSS FRAMEWORK
		#*------------------------------------*/
		setupCSSFramework = =>
			@log.info "Installing CSS framework..."

			repo_path = GitUtils.cacheRepo github(@settings.github.cssFramework)
			GitUtils.export repo_path, dest('styleguide/'), @props.cssBranch

			at dest('styleguide/'), ->
				shell.mv "style.css", "../src/site/templates/assets/css/style.css"
				shell.rm "style.css"

			@log.ok('OK')


		#*------------------------------------*\
		#   $GIT
		#*------------------------------------*/
		setupGit= =>
			GitUtils.init(dest())


		#*------------------------------------*\
		#   $DO IT
		#*------------------------------------*/
		setupRepo()
		setupProcesswire()
		setupKSS()
		setupCSSFramework()
		setupGit()

	projectfiles: =>
		@copy "_Gruntfile.coffee", "Gruntfile.coffee"
		@copy "_editorconfig", ".editorconfig"

