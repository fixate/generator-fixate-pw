# <%= props.projectName %>

A Processwire website with the following features:

- Dockerised PHP, Apache, MySQL, and Mailhog containers
- Asset compilation and task automation with Gulp and Webpack
- Browser reloading with `browser-sync`

## Getting Started

1. Install development dependencies:

   ```bash
   $ npm install && (cd src && composer install)
   $ cd styleguide && npm install
   ```

1. Create a copy of `.env.example`:

   ```bash
   $ cp .env{.example,}
   $ cat .env
   ```

1. Add MySQL and Apache hostname environment variables for Docker in `.env`

1. Add MySQL user and password credentials to `database/cnf/.my.cnf.{dev, prod}`
   for Gulp automating database tasks

   ```bash
   $ cp database/cnf/.my.cnf.{example,dev,prod}

   # ensure credentials in .my.cnf.dev match those in .env
   $ cat database/cnf/.my.cnf.dev
   ```

1. Create a dev copy of `src/config.php` for local development:

   ```bash
   $ cp src/site/config{,-dev}.php
   ```

1. Open `src/site/config-dev.php`, enable debugging, and set your database
   credentials

   ```php
   $debug->true;

   //...

   $config->dbHost = 'mysql'; // use docker service name for host if using docker
   // local db configs, as defined in .env
   ```

1. Start the Docker containers

   ```bash
   $ docker compose up
   ```

1. Install a new ProcessWire instance, or import an existing database export

   - if this is a new project, visit [http://localhost/install.php](http://localhost/install.php)
   - if this is an existing project with database exports in [./database/dev](./database/dev):

     ```bash
     $ $(npm bin)/gulp db-import:devtodev
     ```

1. Watch and rebuild changes to SCSS, Javascript, and images:

   ```bash
   $ npm run dev
   ```

Your environment should be up and running on [localhost:8080](http://localhost:8080),
with a livereload server running at [localhost:3000](http://localhost:3000).

See [./docker/apache/local.apache.conf](./docker/apache/local.apache.conf) for Apache
VirtualHost configurations.

## Working on the project

The easiest way to start the full environment is to install tmuxinator and use
the provided `.tmuxinator.yml` to automate the running of all the services:

1. Create a copy of the `.tmuxinator.yml.example`:

   ```bash
   cp .tmuxinator.yml{.example,}
   ```

2. Install tmux and tmuxinator
3. Start the tmux session from the project root:

   ```bash
   $ tmuxinator
   ```

### Docker

To start the docker services:

```bash
$ docker compose up
```

This will expose the following to your machine:

- a ProcessWire website at:
  - `[your-apache-hostname].localhost`,
  - `localhost:8080`
  - `localhost`

### Email

The docker container will start a MailHog server running at
[localhost:8025](http://localhost:8025).

### Task automation, asset compilation, and auto browser reloading

Before being able to use asset compilation make sure you've enabled debugging in
`src/site/config-dev.php`:

```php
$debug->true;
```

Assets are compiled with Gulp and Webpack. To start the dev server:

```bash
$ npm run dev
```

To see all available Gulp tasks, visit [./gulp/tasks](./gulp/tasks), or on the
command line:

```bash
$ $(npm bin)/gulp --tasks-simple
```

### Building and deploying

To build, optimise, and rev assets:

```bash
$ npm run build
```

Assets can be rsynced to production with the following commands:

```bash
# dry run
$ $(npm bin)/gulp rsync:prod:updry
# rsync
$ $(npm bin)/gulp rsync:prod:up
```

See [./gulp/gulpconfig.js](./gulp/gulpconfig.js) for rsync options, and
[./gulp/tasks/rsync.js](./gulp/tasks/rysnc.js) for the rsync scripts.

### Gulp tasks

There are a number of useful Gulp tasks are available:

- MySQL:
  - dumping timestamped dev / production database
  - importing the latest dev / production dump
- Rsync:

  - deploying changes to production / staging
  - sync'ing production uploads to your local environment

    To see all available Gulp tasks, visit [./gulp/tasks](./gulp/tasks), or on the
