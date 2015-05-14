require 'ruby-features/version'

module RubyFeatures
  autoload :Container,  'ruby-features/container'
  autoload :Single,     'ruby-features/single'
  autoload :Mixins,     'ruby-features/mixins'
  autoload :Concern,    'ruby-features/concern'
  autoload :Utils,      'ruby-features/utils'

  class << self
    def find(*folders)
      Container.new(folders)
    end

    def define(feature_name, &feature_body)
      Single.new(feature_name, feature_body)
    end
  end
end
