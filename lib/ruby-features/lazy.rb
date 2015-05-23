module RubyFeatures
  module Lazy

    ACTIVE_SUPPORT_LAZY_TARGETS = %w(
      action_view action_controller action_mailer
      active_record active_job
      i18n
    ).map(&:to_sym).freeze

    class << self
      def apply(target, &block)
        if RubyFeatures.active_support_available?
          target_namespace = RubyFeatures::Utils.underscore(target.split('::').first).to_sym

          if ACTIVE_SUPPORT_LAZY_TARGETS.include?(target_namespace)
            return ActiveSupport.on_load target_namespace, yield: true, &block
          end
        end

        yield
      end
    end

  end
end
