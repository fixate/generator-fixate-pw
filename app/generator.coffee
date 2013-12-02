GitUtils = require './lib/git-utils'
myUtils = require './lib/utils'
yeoman = require 'yeoman-generator'
shell = require 'shelljs'
fs = require 'fs'
path = require 'path'

module.exports = class FixatePwGenerator extends yeoman.generators.Base
	constructor: (args, options, config) ->
		super args, options, config

		# @on "end", ->
		#   @installDependencies skipInstall: options["skip-install"]

		@pkg = myUtils.loadJSON("../package.json", __dirname)
		@settings = myUtils.loadJSON("./settings.json", __dirname)

	askFor: =>
		cb = @async()

		# Have Yeoman greet the user.
		console.log @yeoman
		prompts = []
		prompts.push
			name: "pwBranch"
			message: "Which branch of ProcessWire would you like to use?"
			default: "master"

		prompts.push
			type: "confirm"
			name: "pwTeflon"
			message: "Would you like to use the Teflon admin theme for proceswire?"
			default: true

		prompts.push
			name: "sgBranch"
			message: "Which branch of the styleguide would you like to use?"
			default: 'inuit'

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

		############### Repository ###############
		setupRepo = =>
			@mkdir d for d in [
				'src',
				'database/dev',
				'database/prod',
				'styleguide'
			]

			@copy "_gitignore", ".gitignore"
			@copy "_package.json", "package.json"

		############### Process Wire ###############
		setupProcesswire = =>
			@log.info "Installing ProcessWire..."
			repo_path = GitUtils.cacheRepo github(@settings.github.processwire)
			@log.info "Copying processwire install..."
			GitUtils.export repo_path, dest('src/'), @props.pwBranch

			at dest('/'), ->
				shell.mv "src/site-default", "src/site"

			@log.ok('OK')

			if @props.pwTeflon
				@log.info "Installing teflon theme..."
				teflon_path = GitUtils.cacheRepo github(@settings.github.processwireTeflon)
				GitUtils.export teflon_path, dest("src/site")

			@log.ok('OK')

			@log.info "Installing processwire boilerplate..."
			repo_path = GitUtils.cacheRepo github(@settings.github.pwBoilerplate)
			GitUtils.export repo_path, dest('src/site/templates')
			at dest('src/'), =>
				shell.ls('-A', "site/templates/\!root/*").forEach (file) ->
					shell.mv '-f', file, '.'
				shell.rm '-rf', "site/template/\!root"

			@log.ok('OK')

		############### Source JS ###############
		setupSourceJs = =>
			@log.info "Installing SourceJS..."
			repo_path = GitUtils.cacheRepo github(@settings.github.sourcejs)
			@mkdir 'Source.js'
			GitUtils.export repo_path, dest('Source.js/')
			at dest('Source.js/'), =>
				@log.info 'SOURCEJS - npm install'
				GitUtils.exec 'npm install'
				@log.info 'SOURCEJS - grunt init'
				GitUtils.exec 'grunt init'
				shell.rm '-rf', '../styleguide'
				shell.mv 'public', '../styleguide'
				shell.rm 'user/options/options.json',

			@template 'Source.js/options.json', 'Source.js/user/options/options.json',
				serverPath: dest('Source.js/')

			@log.ok('OK')

		############### SourceJS Boilerplate ###############
		setupSourceJsBoilerplate = =>
			@log.info "Installing SourceJS Boilerplate..."
			repo_path = GitUtils.cacheRepo github(@settings.github.sourcejsBoilerplate)
			GitUtils.export repo_path, dest('styleguide/')
			@log.ok('OK')

		############### Styleguide ###############
		setupStyleguide = =>
			@log.info "Installing styleguide..."

			shell.rm '-rf', 'styleguide/data/docs/*'

			repo_path = GitUtils.cacheRepo github(@settings.github.styleguide)
			GitUtils.export repo_path, dest('styleguide/data/docs'), @props.sgBranch

			at dest('styleguide/data/docs'), ->
				# Delete all files in the root
				shell.ls('-A', '.').forEach (file)->
					shell.rm file if fs.lstatSync(file).isFile()

			# This just doesn't work...
			# [user, repo] = @settings.github.styleguide.split('/')
			# @remote user, repo, @props.sgBranch, (err, remote) ->
			#   remo80te.directory '.', 'styleguide/data/docs/'

		setupGit= =>
			GitUtils.init(dest())

		# Main
		setupRepo()
		setupProcesswire()
		setupSourceJs()
		setupSourceJsBoilerplate()
		setupStyleguide()
		setupGit()

	projectfiles: =>
		@copy "_Gruntfile.coffee", "Gruntfile.coffee"
		@copy "editorconfig", ".editorconfig"

