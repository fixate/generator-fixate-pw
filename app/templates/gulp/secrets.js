const secrets = {
	domain: 'example.com',
	username: 'ssh_username',
	browserSyncProxy: 'localsite.dev', // update to use your vhost for browserSync to update on changes

	db_prod: {
		name: 'db_name',
		user: 'db_username',
		pass: 'db_password',
		host: 'db_host'
	},

	db_dev: {
		name: 'db_name',
		user: 'db_username',
		pass: 'db_password',
		host: 'localhost'
	}
};

module.exports = secrets;
