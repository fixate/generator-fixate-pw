# Yeoman Generator For ProcessWire

This is a [Yeoman generator](http://yeoman.io) for kickstarting ProcessWire projects with a [Fabricator UI Toolkit](https://github.com/fbrctr/fabricator).

The generator:

- creates a project structure allowing you to easily manage the following:
	- website source
	- database exports
	- living styleguide
- downloads [ProcessWire](http://processwire.com)
- installs Fixate's [ProcessWire MVC Boilerplate](http://github.com/fixate/pw-mvc-boilerplate)
- installs Fixate's [Fabricator Boilerplate](http://github.com/fixate/fixate-fabricator)
- installs a [SCSS Framework](http://github.com/larrybotha/styleguide)
- installs [Bower](http://bower.io) for easily managing your dependencies
- creates a number of files for smoother development and collaboration:
	- .editorconfig
	- .gitignore
	- .gitattributes
	- .bowerrc
	- robots.txt
- installs [Gulp](http://gulpjs.com) with an extensive task list (written in CoffeeScript for your viewing pleasure) fully equipped for
	- coffee and Sass compilation
	- JS uglification
	- image optimisation
	- timestamped local and production database dumps
	- rsync deployments
	- gulp auto reload
	- other treasures!

## Getting Started

### Get Yeoman

Yeoman is a [Node](http://nodejs.org]) package which can be installed via [npm](http://npmks.org):

```
$ npm install -g yo
```

### Get The Generator

Unlike many Yoeman Generators, this generator doesn't live in Yeoman's registry, as it is quite specific to our needs.

Until we decide to add our generator to the Yeoman registry, this is how you can enjoy some of the magic:

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

Once Yeoman has done all the hard work, you have a few small tasks to run before you're free to get going.

#### 1. Install ProcessWire

#### 2. Install Project Dependencies

All task automation is handled through Gulp and Webpack.

```shell
$ npm install
```

This will install all development dependencies, as well as create copies for non-committed config files, and creation of symlinks for assets in the living styleguide

#### 2. Install And Run Living Styleguide

This project makes use of [Fabricator](https://github.com/fbrctr/fabricator) as a living styleguide. To get up and running:

```shell
$ cd styleguide && npm install
```

Once installed, you can start a server for the styleguide that will automatically update on chnages to styles with the following:

```shell
# from styleguide/
$ gulp --dev
```

#### 3. Work On ProcessWire

Gulp will compile coffee and scss files when updated, and reload your browser via Browser Sync at the URL it specifies when starting Gulp (make sure to update the browserSyncProxy property in the generated [secrets.coffee](https://github.com/fixate/generator-fixate-pw/blob/master/app/templates/gulp/secrets-sample.coffee#L4) with your local site's URL)

```shell
# from project root
$ gulp
```

#### 4. Change Template Alternate Filename

For each template, visit your admin and set all templates to use `mvc`:

```
Setup -> [your template] -> Files -> Alternate Template Filename
```


## License

MIT: http://fixate.mit-license.org/
