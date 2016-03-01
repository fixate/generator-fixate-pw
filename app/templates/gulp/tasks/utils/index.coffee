exec    = require('child_process').exec
fs      = require 'fs'
path    = require 'path'
exports = module.exports

exports.execCommand = (cmd) ->
  exec cmd, (err, stdout, stderr) ->
    console.log stdout
    console.log stderr
    console.log err if err

exports.getNewestFile = (dir) ->
  files = fs.readdirSync(dir)

  newest = files.reduce (prev, next) ->
    prevPath = path.join(dir, prev)
    nextPath = path.join(dir, next)

    if fs.statSync(prevPath).ctime > fs.statSync(nextPath).ctime then prev else next

  newest
