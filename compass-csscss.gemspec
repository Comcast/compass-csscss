# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "compass-csscss"
  gem.version       = "0.0.2"
  gem.authors       = ["John Riviello"]
  gem.description   = %q{Easily integrate csscss into your projects that use the Compass CSS Framework}
  gem.summary       = %q{Runs csscss against the CSS that Sass/Compass generates}
  gem.homepage      = "https://github.com/Comcast/compass-csscss"
  gem.license       = "MIT"

  gem.files         = ['./lib/compass-csscss.rb']
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'compass'
  gem.add_runtime_dependency 'csscss'

  gem.post_install_message = %{---------------------------------------------------------------------------------------------------
    Thank you for installing csscss for Compass!
    Please note there is currently a bug in Compass that prevents this from working out of the box.
    A custom version of Compass is required to run this & other command line extensions.
    See https://github.com/Comcast/compass-csscss for further details.
---------------------------------------------------------------------------------------------------
}
end
