
# IRBRC file by Iain Hecker, http://iain.nl
# put all this in your ~/.irbrc
# with other changes integrated in
$LOAD_PATH << File.expand_path(".")
$LOAD_PATH << File.expand_path("C:/bin")
# IRB settings
require 'irb/completion'
require 'irb/ext/save-history'
require 'rubygems'
require 'yaml'


IRB.conf[:USE_READLINE] = true

alias q exit

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

ANSI = {}
ANSI[:RESET]     = "\e[0m"
ANSI[:BOLD]      = "\e[1m"
ANSI[:UNDERLINE] = "\e[4m"
ANSI[:LGRAY]     = "\e[0;37m"
ANSI[:GRAY]      = "\e[0;90m"
ANSI[:RED]       = "\e[31m"
ANSI[:GREEN]     = "\e[32m"
ANSI[:YELLOW]    = "\e[33m"
ANSI[:BLUE]      = "\e[34m"
ANSI[:MAGENTA]   = "\e[35m"
ANSI[:CYAN]      = "\e[36m"
ANSI[:WHITE]     = "\e[37m"

# Build a simple colorful IRB prompt
IRB.conf[:PROMPT][:SIMPLE_COLOR] = {
  :PROMPT_I => "#{ANSI[:BLUE]}>>#{ANSI[:RESET]} ",
  :PROMPT_N => "#{ANSI[:BLUE]}>>#{ANSI[:RESET]} ",
  :PROMPT_C => "#{ANSI[:RED]}?>#{ANSI[:RESET]} ",
  :PROMPT_S => "#{ANSI[:YELLOW]}?>#{ANSI[:RESET]} ",
  :RETURN   => "#{ANSI[:GREEN]}=>#{ANSI[:RESET]} %s\n",
  :AUTO_INDENT => true }
IRB.conf[:PROMPT_MODE] = :SIMPLE

# Loading extensions of the console. This is wrapped
# because some might not be included in your Gemfile
# and errors will be raised
def extend_console(name, care = true, required = true)
  if care
    require name if required
    yield if block_given?
    $console_extensions << "#{ANSI[:GREEN]}#{name}#{ANSI[:RESET]}"
  else
    $console_extensions << "#{ANSI[:GRAY]}#{name}#{ANSI[:RESET]}"
  end
rescue LoadError
  $console_extensions << "#{ANSI[:RED]}#{name}#{ANSI[:RESET]}"
end
$console_extensions = []

# Wirble is a gem that handles coloring the IRB
# output and history
extend_console 'wirble' do
  Wirble.init
  Wirble.colorize
end

extend_console 'wirb' do
  Wirb.start
end

# Hirb makes tables easy.
extend_console 'hirb' do
  Hirb.enable
  extend Hirb::Console
end

# awesome_print is prints prettier than pretty_print
extend_console 'ap' do
  alias pp ap
end

# When you're using Rails 2 console, show queries in the console
extend_console 'rails2', (ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')), false do
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

# When you're using Rails 3 console, show queries in the console
# http://rbjl.net/49-railsrc-rails-console-snippets
extend_console 'rails3', defined?(ActiveSupport::Notifications), false do

  # loggers
  if defined?(ActiveRecord)
    ActiveRecord::Base.logger     = Logger.new STDOUT
    ActiveRecord::Base.clear_reloadable_connections!
  end

  ActionController::Base.logger = Logger.new STDOUT

  # named routes and helpers
  include Rails.application.routes.url_helpers
  default_url_options[:host] = Rails.application.class.parent_name.downcase

  # include ActionView::Helpers           # All Rails helpers
  include ApplicationController._helpers # Your own helpers

  # unfortunately that breaks some functionality (e.g. the named route helpers above)
  #  so, look at actionpack/lib/action_view/helpers.rb and choose the helpers you need
  #  (and which don't break anything), e.g.
  include ActionView::Helpers::DebugHelper
  include ActionView::Helpers::NumberHelper
  # include ActionView::Helpers::RawOutputHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TranslationHelper

  if defined?(Hirb)
    # hirb view for a route
    class Hirb::Helpers::Route < Hirb::Helpers::AutoTable
      def self.render(output, options = {})
        super( output.requirements.map{ |k,v|
          [k, v.inspect]
        }, options.merge({
          :headers     => [output.name || '', "#{ output.verb || 'ANY' } #{ output.path }"],
          :unicode     => true,
          :description => nil,
        }) )
      end
    end
    Hirb.add_view ActionDispatch::Routing::Route, :class => Hirb::Helpers::Route

    # short and long route list
    def routes(long_output = false)
      if long_output
        Rails.application.routes.routes.each{ |e|
          puts Hirb::Helpers::Route.render(e)
        }
        true
      else
        Hirb::Console.render_output Rails.application.routes.routes.map{|e|
          [e.name || '', e.verb || 'ANY', e.path]
        },{
          :class   => Hirb::Helpers::AutoTable,
          :headers => %w<name verb path>,
        }
      end
    end

    # misc db helpers (requires hirb)
    module DatabaseHelpers
      extend self

      def tables
        Hirb::Console.render_output ActiveRecord::Base.connection.tables.map{|e|[e]},{
          :class   => Hirb::Helpers::AutoTable,
          :headers => %w<tables>,
        }
        true
      end

      def table(which)
        Hirb::Console.render_output ActiveRecord::Base.connection.columns(which).map{ |e|
          [e.name, e.type, e.sql_type, e.limit, e.default, e.scale, e.precision, e.primary, e.null]
        },{
          :class   => Hirb::Helpers::AutoTable,
          :headers => %w<name type sql_type limit default scale precision primary null>,
        }
        true
      end

      def counts
        Hirb::Console.render_output ActiveRecord::Base.connection.tables.map{|e|
          [e, ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM #{e}")]
        },{
          :class   => Hirb::Helpers::AutoTable,
          :headers => %w<table count>,
        }
        true
      end

      # ...
    end
    def db; DatabaseHelpers; end

  end

  # get a specific route via index or name
  def route(index_or_name)
    route = case index_or_name
            when Integer
              Rails.application.routes.routes[ index_or_name ]
            when Symbol # named route
              Rails.application.routes.named_routes.get index_or_name
            end
  end

  # access to routeset for easy recognize / generate
  def r
    ActionController::Routing::Routes
  end


  # # #
  # plain sql
  def sql(query)
    ActiveRecord::Base.connection.select_all(query)
  end

  # # #
  # instead of User.find(...) you can do user(...)
  #   without arguments it only returns the model class
  #   based on http://www.clarkware.com/blog/2007/09/03/console-shortcut
  Dir.glob( File.join(Dir.pwd, *%w<app models ** *.rb>) ).map { |file_name|
    table_name = File.basename(file_name).split('.')[0..-2].join
    Object.instance_eval do
      define_method(table_name) do |*args|
        table_class = table_name.camelize.constantize
        if args.empty?
          table_class
        else
          table_class.send(:find, *args)
        end
      end
    end
  }



end

# Add a method pm that shows every method on an object
# Pass a regex to filter these
extend_console 'pm', true, false do
  def pm(obj, *options) # Print methods
    methods = obj.methods
    methods -= Object.methods unless options.include? :more
    filter  = options.select {|opt| opt.kind_of? Regexp}.first
    methods = methods.select {|name| name =~ filter} if filter

    data = methods.sort.collect do |name|
      method = obj.method(name)
      if method.arity == 0
        args = "()"
      elsif method.arity > 0
        n = method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")})"
      elsif method.arity < 0
        n = -method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")}, ...)"
      end
      klass = $1 if method.inspect =~ /Method: (.*?)#/
        [name.to_s, args, klass]
    end
    max_name = data.collect {|item| item[0].size}.max
    max_args = data.collect {|item| item[1].size}.max
    data.each do |item|
      print " #{ANSI[:YELLOW]}#{item[0].to_s.rjust(max_name)}#{ANSI[:RESET]}"
      print "#{ANSI[:BLUE]}#{item[1].ljust(max_args)}#{ANSI[:RESET]}"
      print "   #{ANSI[:GRAY]}#{item[2]}#{ANSI[:RESET]}\n"
    end
    data.size
  end
end

# extend_console 'interactive_editor' do
#   # no configuration needed
# end

# Show results of all extension-loading
puts "#{ANSI[:GRAY]}~> Console extensions:#{ANSI[:RESET]} #{$console_extensions.join(' ')}#{ANSI[:RESET]}"

def try_require(gem_name)
  begin
  require gem_name
  yield if block_given?
  
  rescue ScriptError
    puts "#{gem_name} has no found."
  end
end

# Load third party gems
try_require 'map_by_method'
try_require 'interactive_editor'
# can't load on windows
#try_require 'looksee'
try_require 'awesome_print' do
  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
end

# on windows 7 , fancy_irb requires ansicons 
# to be installed to path
# http://adoxa.110mb.com/ansicon/
# to install, have devkit on path, 
# run make -i, 
# copy x64 or x86 files into a directory on your path
try_require 'fancy_irb' do
  FancyIrb.start
end

module TweakIRB
  def self.included(base)
    base.send(:include, IO)
    base.send(:include, Documentation)
    base.send(:include, Rails)
    base.send(:include, Core)
  end

  module IO
    def dir
      `ls`.split("\n")
    end

    def cd(dir)
      Dir.chdir(dir)
      Dir.pwd
    end

    def pwd
      Dir.pwd
    end

    # http://timelessrepo.com/copy-paste
    # Installation: sudo apt-get install xclip
    def copy(str)
      ::IO.popen('xclip -i', 'w') { |f| f << str.to_s }
    end

    def paste
      `xclip -o`
    end

    # Evaluate the code on the clipboard.
    def ep
      IRB.CurrentContext.workspace.evaluate(self, paste)
    end
  end

  module Documentation
    RI_DELEMITER = "ri_"

    def ri(method = nil)
      unless method && method =~ /^[A-Z]/
        klass = self.kind_of?(Class) ? name : self.class.name
        method = [klass, method].compact.join('#')
      end

      system 'ri', method.to_s
    end

    def method_missing(method_sym, *args)
      name = method_sym.to_s

      return ri(name[RI_DELEMITER.length..-1]) if name.start_with? RI_DELEMITER

      super
    end
  end

  module Rails
    extend self

    def rails?
      ($0 == 'irb' && ENV['RAILS_ENV']) || ($0 == 'script/rails' && ::Rails.env)
    end

    if rails?
      def change_log(stream)
        ::ActiveRecord::Base.logger = Logger.new(stream)
        ::ActiveRecord::Base.clear_active_connections!
      end

      def show_log
        change_log(STDOUT) && true
      end

      def hide_log
        change_log(nil) && true
      end

      def sql(query)
        ::ActiveRecord::Base.connection.select_all(query)
      end

      try_require 'hirb' do
        Hirb.enable
      end
    end
  end

  module Core
    unless respond_to?(:singleton_class)
      Kernel.module_eval do
        def singleton_class
          class << self; self; end
        end
      end
    end
  end
end

class Object
  include TweakIRB

  def my_methods
    (methods - self.class.superclass.instance_methods).sort
  end

  # Reload IRB
  def reload
    puts "IRB has been reloaded."
    exec($0)
  end

  def clear
    system('clear')
  end

  # Quick benchmarking facility
  # Based on rue's irbrc => http://pastie.org/179534
  def quick(repetitions=100, &block)
    require 'benchmark'

    Benchmark.bmbm do |b|
      b.report {repetitions.times &block} 
    end
    nil
  end

  alias :reset :reload
  alias :restart :reload

  alias :cls :clear
  alias :mm :my_methods
  alias :m :method
  alias :q :exit
end

