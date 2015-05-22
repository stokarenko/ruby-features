require 'ruby-features/version'

module RubyFeatures
  autoload :Container,  'ruby-features/container'
  autoload :Mixins,     'ruby-features/mixins'
  autoload :Utils,      'ruby-features/utils'
  autoload :Lazy,       'ruby-features/lazy'

  module Concern
    autoload :ApplyTo,    'ruby-features/concern/apply_to'
    autoload :Feature,    'ruby-features/concern/feature'
  end

  module Generators
    autoload :InstallGenerator, 'generators/ruby-features/install_generator'
  end

  class ApplyError < StandardError; end

  @features = {}

  @active_support_available = begin
    require 'active_support'
    true
  rescue LoadError
    false
  end

  class << self
    def find_in_path(*folders)
      old_feature_names = @features.keys

      Dir[*folders.map{|folder| File.join(folder, '**', '*_feature.rb') }].each do |file|
        require file
      end

      Container.new(@features.keys - old_feature_names)
    end

    def define(feature_name, &feature_body)
      feature_name = feature_name.to_s
      raise NameError.new("Wrong feature name: #{name}") unless feature_name.match(/^[\/_a-z\d]+$/)
      raise NameError.new("Such feature is already registered: #{feature_name}") if @features.has_key?(feature_name)

      @features[feature_name] = Mixins.new(feature_name, feature_body)
    end

    def apply(*feature_names)
      feature_names.each do |feature_name|
        raise NameError.new("Such feature is not registered: #{feature_name}") unless @features.has_key?(feature_name)

        @features[feature_name].apply
      end
    end

    def active_support_available?
      @active_support_available
    end

  end
end
