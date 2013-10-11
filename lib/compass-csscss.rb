require 'compass'
require 'compass/commands/registry'
require 'compass/commands/project_base'
require 'compass/commands/update_project'

module Compass
  module Commands
    module CsscssOptionsParser
      def set_options(opts)
        opts.banner = %Q{
          Usage: compass csscss [options]* [path/to/project]*

          Description:
            Compile project at the path specified or the current
            directory if not specified and then run csscss
            against the generated CSS.

          Options:
        }.strip.split("\n").map{|l| l.gsub(/^ {0,10}/,'')}.join("\n")

        opts.on("-v", "--[no-]verbose", "Display each rule") do |verbose|
          self.options[:verbose] = verbose
        end

        opts.on("--[no-]color", "Colorize output", "(default is true)") do |color|
          self.options[:color] = color
        end

        opts.on("-n", "--num N", "Print matches with at least this many rules.", "(default is 3)") do |num|
          self.options[:num] = num
        end

        opts.on("--[no-]match-shorthand", "Expand shorthand rules and matches on explicit rules", "(default is true)") do |match_shorthand|
          self.options[:match_shorthand] = match_shorthand
        end

        opts.on("-j", "--[no-]json", "Output results in JSON") do |json|
          self.options[:json] = json
        end

        opts.on("-S", "--src", "--sass", "--scss", "Parse your sass/scss source files instead of your generated CSS") do |sass|
          self.options[:sass] = sass
        end

        opts.on("--ignore-sass-mixins", "EXPERIMENTAL: Ignore matches that come from including sass/scss mixins",
                "This is an experimental feature and may not be included in future releases",
                "(default is false)") do |ignore_sass_mixins|
          self.options[:ignore_sass_mixins] = ignore_sass_mixins
        end

        opts.on("--require file.rb", "Load ruby file before running csscss.", "Great for bootstrapping requires/configurations") do |file|
          self.options[:file] = file
        end

        opts.on("--ignore-properties property1,property2,...", "Ignore these properties when finding matches") do |ignored_properties|
          self.options[:ignored_properties] = ignored_properties
        end

        opts.on('--ignore-selectors "selector1","selector2",...', "Ignore these selectors when finding matches") do |ignored_selectors|
          self.options[:ignored_selectors] = ignored_selectors
        end

        opts.on("--show-parser-errors", "Print verbose parser errors") do |show_parser_errors|
          self.options[:show_parser_errors] = show_parser_errors
        end

        opts.on("-V", "--version", "Show version of csscss") do
          self.options[:version] = true
          self.options[:nocompile] = true
        end

        opts.on("-?", "-h", "--help", "Show this message\n\n") do
          puts opts
          exit
        end

        super
      end
    end
    class CsscssProject < ProjectBase

      require 'csscss'
      include Csscss

      register :csscss

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        @args = []

        if !options[:verbose].nil?
          @args << '--' + (options[:verbose] ? '' : 'no-') + 'verbose'
        end

        if !options[:color].nil?
          @args << '--' + (options[:color] ? '' : 'no-') + 'color'
        end

        if options[:num]
          @args << '--num'
          @args << options[:num]
        end

        if !options[:match_shorthand].nil?
          @args << '--' + (options[:match_shorthand] ? '' : 'no-') + 'match-shorthand'
        end

        if !options[:json].nil?
          @args << '--' + (options[:json] ? '' : 'no-') + 'json'
        end

        if options[:ignore_sass_mixins]
          @args << '--ignore-sass-mixins'
        end

        if options[:file]
          @args << '--require'
          @args << options[:file]
        end

        if options[:ignored_properties]
          @args << '--ignore-properties'
          @args << options[:ignored_properties]
        end

        if options[:ignored_selectors]
          @args << '--ignore-selectors'
          @args << options[:ignored_selectors]
        end

        if options[:show_parser_errors]
          @args << '--show-parser-errors'
        end

        if options[:version]
          @args << '--version'
        end

        if not(options[:nocompile] || options[:sass])
          UpdateProject.new(working_path, options).perform
        end

        Dir.chdir Compass.configuration.project_path do

          if options[:sass]

            if Compass.configuration.inherited_data.name.nil?
              @args << '--compass'
            else
              @args << '--compass-with-config'
              @args << Compass.configuration.inherited_data.name
            end

            @args << Dir.glob(project_src_subdirectory+"/**/*.s{a,c}ss")

          elsif not(options[:nocompile])

            @args << Dir.glob(project_css_subdirectory+"/**/*.css")

          end

          Csscss::CLI.run(@args.flatten)

        end
      end

      class << self

        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(CsscssOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def description(command)
          "Run csscss against your sass or generated css."
        end

        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parse_arguments!(parser, arguments)
          parser.options
        end

        def parse_arguments!(parser, arguments)
          if arguments.size == 1
            parser.options[:project_name] = arguments.shift
          elsif arguments.size == 0
            # default to the current directory.
          else
            raise Compass::Error, "Too many arguments were specified."
          end
        end
      end
    end
  end
end