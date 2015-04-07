# Yeoman Generator For ProcessWire

This is a [Yeoman generator](http://yeoman.io) for kickstarting ProcessWire projects with a [KSS Styleguide](http://github.com/kneath/kss).

The generator:

- creates a project structure allowing you to easily manage the following:
	- website source
	- database exports
	- living styleguide
- downloads [ProcessWire](http://processwire.com)
- installs Fixate's [ProcessWire MVC Boilerplate](http://github.com/fixate/pw-mvc-boilerplate)
- installs Fixate's [KSS Boilerplate](http://github.com/fixate/kss-boilerplate)
- installs a [SCSS Framework](http://github.com/larrybotha/styleguide) in the KSS Boilerplate
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

#### 2. Run Gulp

Gulp will compile coffee and scss files when updated, and reload your browser via Browser Sync at the URL it specifies when starting Gulp (make sure to update the bsProxy property in the generated [private.json](https://github.com/fixate/generator-fixate-pw/blob/master/app/templates/private-sample.json#L4) with your local site's URL)

```shell
$ gulp
```

#### 3. Change Template Alternate Filename

For each template, visit your admin and set all templates to use `mvc.php`:

```
Setup -> [your template] -> Advanced -> Alternate Template Filename
```


## License

MIT: http://fixate.mit-license.org/
