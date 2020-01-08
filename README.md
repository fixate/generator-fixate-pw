# Yeoman Generator For ProcessWire

This is a [Yeoman generator](http://yeoman.io) for kickstarting ProcessWire
projects.

The generator:

- creates a project structure allowing you to easily manage the following:
	- website source
	- database exports
	- living styleguide / design system
- downloads [ProcessWire](http://processwire.com)
- installs Fixate's [ProcessWire MVC Boilerplate](http://github.com/fixate/pw-mvc-boilerplate)
- installs a [SCSS Framework](http://github.com/larrybotha/styleguide)
- creates a number of files for smoother development and collaboration:
	- .editorconfig
	- .gitignore
	- .gitattributes
	- robots.txt
- installs [Gulp](http://gulpjs.com) and [Webpack](https://webpack.js.org/) with an
  extensive task list fully equipped for
	- javascript and Sass compilation
	- asset minification and optimisation
	- asset revision / cache-busting
	- timestamped local and production database dumps
	- rsync deployments
	- auto reload
- a tmuxinator config to easily get your project running with a single command

## Getting Started

### Get Yeoman

Yeoman is a [Node](http://nodejs.org]) package which can be installed via [npm](http://npmks.org):

```
$ npm install -g yo
```

### Get The Generator

Unlike many Yeoman Generators, this generator doesn't live in Yeoman's registry, as
it is quite specific to our needs.

Until we decide to add our generator to the Yeoman registry, this is how you can enjoy
some of the magic:

```
# clone the generator
$ git clone https://github.com/fixate/generator-fixate-pw.git

# let Yeoman know about the generator
$ cd generator-fixate-pw
$ npm link

# install all the generator dependencies
$ npm install
```

### Get Your Project Did!

Initiate the generator from the root of your project's folder:

```
$ cd your-project-folder
$ yo fixate-pw
```

Once Yeoman has done all the hard work, you have a few small tasks to run before you
're free to get going.

#### 1. Install development dependencies

All task automation and asset compilation is handled via Gulp tasks and Webpack.

```shell
$ npm install
```

#### 2. Set environment variables

Open `.env` and configure your local database credentials (these are used by Docker
to initialise your database and expose a virtual host).

#### 3. Run Docker

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

#### 4. Install ProcessWire

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

#### 5. Install and run the styleguide

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

#### 6. Work On ProcessWire

You'll first need to start the docker containers:

```bash
# from project root
$ docker-compose up
```

Once the docker containers are running, you can watch for file changes and run
automated compilation tasks with Gulp and Webpack. `browser-sync` will reload at `
localhost:3000` by proxying `localhost:8080` exposed by Docker.

```shell
# from project root
$ npm run dev
```

#### 5. Change Template Alternate Filename

For each template, visit your admin and set all templates to use `mvc`:

```
Setup -> [your template] -> Files -> Alternate Template Filename
```


## License

MIT: http://fixate.mit-license.org/
