# <%= props.projectName %>

A Processwire website with the following features:

- Dockerised PHP, Apache, MySQL, and Mailhog containers
- Asset compilation and task automation with Gulp and Webpack
- Browser reloading with `browser-sync`

## Getting started with a fresh install

### 1. Install development dependencies

All task automation and asset compilation is handled via Gulp tasks and Webpack.

```shell
$ npm install
```

### 2. Set environment variables

Open `.env` and configure your local database credentials (these are used by Docker
to initialise your database and expose a virtual host).

Open `database/cnf/.my.cnf.{dev, prod}` and add your dev and production database
credentials so that MySQL Gulp tasks don't expose your credentials on the
command line.

### 3. Run Docker

A `docker-compose.yml` containerises the application with the following:

- PHP server
- Apache server with virtual host (defined in `.env` and
  `docker/apache/local.apache.conf`)
- MySQL server (credentials defined in `.env`)
- Mailhog server

To start the server:

```bash
$ docker-compose up
```

### 4. Install ProcessWire

With the docker container runnning, you can now install ProcessWire

1. Visit `localhost/install.php`
2. When entering database credentials, use `mysql` for the hostname. This is the
   hostname that the MySQL docker image exposes to the PHP container
3. Create a dev copy of `src/config.php` for local development:

    ```bash
    $ cp src/site/config{,-dev}.php
    ```
4. Open `src/site/config-dev.php` and enable debug

    ```php
    $debug -> true;
    ```

### 5. Install and run the styleguide

This project makes use of [Storybook](https://storybook.js.org/) as a living styleguide
. To get up and running:

```shell
$ cd styleguide && npm init -y && npx -p @storybook/cli sb init --type react
```

Once installed, you can start a server for the styleguide that will automatically
update on changes to styles with the following:

```shell
# from the styleguide directory
$ npm run storybook
```

## Getting started with an existing project

If you're cloning this project, you can follow these steps:

1. Install development dependencies:

    ```bash
    $ npm install
    $ cd styleguide && npm install
    ```

2. Create a copy of `.env.example`:

    ```bash
    cp .env{.example,}
    ```

3. Add MySQL user and password credentials to `database/cnf/.my.cnf.{dev, prod}`
   for Gulp automation

4. Add MySQL and Apache hostname environment variables for Docker in `.env`

5. Create a dev copy of `src/config.php` for local development:

    ```bash
    $ cp src/site/config{,-dev}.php
    ```

6. Open `src/site/config-dev.php`, enable debug, and update your database
   credentials

    ```php
    $debug -> true;
    ```

7. Start the Docker containers

    ```bash
    $ docker-compose up
    ```

8. Import the most recent dev database (assuming an export has been committed):

    ```bash
    $ $(npm bin)/gulp db-import:devtodev
    ```

You should be all good to begin work at this point.

## Working on the project

The easiest way to get started is to install tmuxinator and use the provided
`.tmuxinator.yml` to automate the running of all the services:

1. Create a copy of the `.tmuxinator.yml.example`:

    ```bash
    cp .tmuxinator.yml{.example,}
    ```
2. Install tmux and tmuxinator
3. Start the tmux session:

    ```bash
    $ tmuxinator
    ```

### Docker

To start the docker services:

```bash
$ docker-compose up
```

This will expose the following to your machine:

- a ProcessWire website at:
    - `[your-apache-hostname].localhost`,
    - `localhost:8080`
    - `localhost`
- a MySQL server with hostname `mysql`
- a Mailhog server at `localhost:8025`

### Task automation, asset compilation, and auto browser reloading

Before being able to use asset compilation make sure you've added
`src/site/config-dev.php` file with `$debug -> true`.

Assets are compiled with Gulp and Webpack. To start the dev server:

```bash
$ npm run dev
```

### Builds

To build, optimise, and rev assets:

```bash
$ npm run build
```

Make sure when deploying not to deploy `src/site/config-dev.php` as it's meant
specifically for local development.

### Gulp tasks

A number of useful Gulp tasks are available:

- MySQL:
    - dumping timestamped dev / production database
    - importing the latest dev / production dump
- Rsync:
    - deploying changes to production / staging
    - sync'ing production uploads to your local environment

Open the invidual Gulp tasks to view available commands.
