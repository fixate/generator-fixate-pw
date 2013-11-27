gitUtils = require './lib/git-utils'
myUtils = require './lib/utils'
yeoman = require 'yeoman-generator'
shell = require 'shelljs'
path = require 'path'

module.exports = class FixatePwGenerator extends yeoman.generators.Base
	constructor: (args, options, config) ->
		super args, options, config

		# @on "end", ->
		#   @installDependencies skipInstall: options["skip-install"]

		@pkg = myUtils.loadJSON("../package.json", __dirname)
		@settings = myUtils.loadJSON("./settings.json", __dirname)

		@prompts = []
		@prompts.push
			name: "pwBranch"
			message: "Which branch of ProcessWire would you like to use?"
			default: "master"

	askFor: =>
		cb = @async()

		# Have Yeoman greet the user.
		console.log @yeoman
		@prompt @prompts, (props) =>
			@props = props
			cb()

	app: =>
		setupProcesswire = =>
			@mkdir 'src'
			console.log "Fetching repo #{@settings.github.processwire}..."
			repo_path = gitUtils.fetch @settings.github.processwire, @pwBranch

			console.log "Copying processwire install..."
# http://stackoverflow.com/questions/160608/how-to-do-a-git-export-like-svn-export
			debugger
			@directory "#{repo_path}", "src/"
			# Remove .git from dest
			shell.rm '-rf', path.join(@destinationRoot(), 'src/.git')

		setupSourceJs = =>

		setupStyleguide = =>

		# Call helpers
		setupProcesswire()
		setupSourceJs()
		setupStyleguide()
		@copy "_package.json", "package.json"

	projectfiles: =>
		@copy "_Gruntfile.coffee", "Gruntfile.coffee"
		@copy "editorconfig", ".editorconfig"

