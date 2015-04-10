path = require('path')
fs = require('fs')

module.exports = class Utils
  @loadJSON: (file, dir = __dirname)->
    JSON.parse(Utils.readFileAsString(path.join(dir, file)))

  @readFileAsString: (filePath) ->
    fs.readFileSync(path.resolve(filePath), 'utf8')

  @getObjectKey: (value, object) ->
    for item in Object.keys(object)
      if value == object[item]
        return item

  @getMultiChoices: (obj) ->
    arr = new Array()
    Object.keys(obj).map (item) ->
      arr.push({
        value: "#{obj[item]}",
        name: "#{item}",
        checked: true
      })
    return arr
