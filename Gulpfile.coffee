requireJson (f) ->
	fs   = require "fs"
	JSON.parse(fs.readFileSync(f))

pkg = requireJson 'package.json'
gulp = require "gulp"

