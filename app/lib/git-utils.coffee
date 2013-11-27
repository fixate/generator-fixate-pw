path = require 'path'
fs = require 'node-fs'
shell = require 'shelljs'

class GitUtils
	@fetch: (github, branch, cb) ->
		branch ||= 'master'
		repo_url = GitUtils.giturl.replace('{url}', github)
		cached_dir = path.join(GitUtils.cache_dir, github)

		if fs.existsSync(cached_dir)
			shell.pushd cached_dir
			shell.exec "git co #{branch}"
			shell.exec "git pull"
			shell.popd()
		else
			shell.exec "git clone #{repo_url} -b #{branch} #{cached_dir}"

		cached_dir

GitUtils.giturl = 'https://github.com/{url}.git'
GitUtils.cache_dir = path.resolve(path.join(__dirname, '../templates/.gitcache'))

fs.mkdirSync(GitUtils.cache_dir, 0o777, true) unless fs.existsSync(GitUtils.cache_dir)

module.exports = GitUtils
