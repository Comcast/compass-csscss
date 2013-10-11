# csscss for Sass & Compass

Easily integrate Zach Moazeni's [csscss](http://zmoazeni.github.io/csscss/) into your projects that use the Compass CSS Framework by providing a `compass csscss` command line option.

## Installation

There is currently a [bug in Compass](https://github.com/chriseppstein/compass/issues/1053) that prevents external Compass commands from being registered if they're required in a project's config.rb file. So until that is resolved, you'll have to build this [custom version of Compass](https://github.com/Comcast/compass/tree/command_extensions) that [adds support for command-line extensions](https://github.com/chriseppstein/compass/pull/1261):

https://github.com/Comcast/compass

Clone that project, then from the project root run

    $ git checkout command_extensions
    $ gem build compass.gemspec

Be sure to take note of the .gem filename

Once that builds, you'll need to first uninstall your existing Compass gem

    $ gem uninstall compass

And then install your locally-built version of Compass

    $ gem install compass-0.13.alpha.4.<hash>.gem

Be sure to use the actual filename that the build command created.

Once that is installed, you can safely install compass-csscss:

    $ gem install compass-csscss

## Usage

Run the following command from the root of your Compass project:

    $ compass csscss

To view options:

    $ compass csscss --help

## Additional Links

For a bare-bones sample project to see this in action, checkout the [compass-extensions-sample](https://github.com/Comcast/compass-extensions-sample) repo

## Authors

* John Riviello - https://github.com/JohnRiv