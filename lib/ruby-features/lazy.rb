module RubyFeatures
  module Lazy

    ACTIVE_SUPPORT_LAZY_TARGETS = %w(
      action_view action_controller action_mailer
      active_record active_job
      i18n
    ).map(&:to_sym).freeze

    @active_support_available = begin
      require 'active_support'
      true
    rescue LoadError
      false
    end

    class << self
      def active_support_available?
        @active_support_available
      end

      def apply(target, &block)
        if active_support_available?
          target_namespace = RubyFeatures::Utils.underscore(target.split('::').first).to_sym

          if ACTIVE_SUPPORT_LAZY_TARGETS.include?(target_namespace)
            ActiveSupport.on_load target_namespace, yield: true, &block

            return
          end
        end

        yield
      end
    end

  end
end
