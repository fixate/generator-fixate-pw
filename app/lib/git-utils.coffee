path = require 'path'
fs = require 'fs'
shell = require 'shelljs'

class GitUtils
  @cacheRepo: (repo_url) ->
    cached_dir = path.join(GitUtils.cache_dir, @pathFromUrl(repo_url))

    unless fs.existsSync(cached_dir)
      GitUtils.exec "git clone #{repo_url} #{cached_dir}"

    cached_dir

  @pathFromUrl: (gitUrl) ->
    parts = gitUrl.split('://')[1].split('/')
    path.join(parts[1], parts[2].split('.')[0])

  @exec: (cmd) ->
    if shell.exec(cmd).code != 0
      throw "Error: #{cmd} failed!"

  @init: () ->
    GitUtils.exec "git init"

  @export: (repo_path, dest_root, branch = 'master') ->
    shell.pushd repo_path
    GitUtils.exec "git pull origin #{branch}"
    GitUtils.exec "git checkout #{branch}"
    shell.cp "-R", "./*", "#{dest_root}/"
    shell.popd()

GitUtils.cache_dir = path.resolve(path.join(__dirname, '../templates/.gitcache'))

module.exports = GitUtils
