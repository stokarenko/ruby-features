module RubyFeatures
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copy RubyFeatures initializer'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'ruby-features.rb', 'config/initializers/ruby-features.rb'
      end

    end
  end
end
