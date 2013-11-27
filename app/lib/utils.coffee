path = require('path')
fs = require('fs')

module.exports = class Utils
	@loadJSON: (file, dir = __dirname)->
		JSON.parse(Utils.readFileAsString(path.join(dir, file)))

	@readFileAsString: (filePath) ->
		fs.readFileSync(path.resolve(filePath), 'utf8')


