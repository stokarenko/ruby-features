require 'ruby-features/version'

module RubyFeatures
  autoload :Container,  'ruby-features/container'
  autoload :Single,     'ruby-features/single'
  autoload :Mixins,     'ruby-features/mixins'
  autoload :Concern,    'ruby-features/concern'
  autoload :Utils,      'ruby-features/utils'

  module Generators
    autoload :InstallGenerator, 'generators/ruby-features/install_generator'
  end

  @@features = {}

  class << self
    def find_in_path(*folders)
      old_feature_names = @@features.keys

      Dir[*folders.map{|folder| File.join(folder, '**', '*_feature.rb') }].each do |file|
        require file
      end

      Container.new(@@features.keys - old_feature_names)
    end

    def define(feature_name, &feature_body)
      feature = Single.new(feature_name, feature_body)
      feature_name = feature.name
      raise NameError.new("Such feature is already registered: #{feature_name}") if @@features.has_key?(feature_name)

      @@features[feature_name] = feature
    end

    def apply(*feature_names)
      feature_names.each do |feature_name|
        raise NameError.new("Such feature is not registered: #{feature_name}") unless @@features.has_key?(feature_name)

        @@features[feature_name].apply
      end
    end

  end
end
