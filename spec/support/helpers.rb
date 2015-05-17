RSpec.configure do

  def prepare_test_class(class_parts)
    class_parts = class_parts.split('::') unless class_parts.kind_of?(Array)

    test_class = Object

    until class_parts.empty?
      test_class = class_parts.size > 1 ?
        test_class.const_set(class_parts.shift, Module.new) :
        test_class.const_set(class_parts.shift, Class.new)
    end

    let(:test_class){ test_class }
  end

  def define_test_feature(feature_name_postfix, &block)
    test_class_name = test_class.name
    feature_name = test_class_name.
      gsub(/([A-Z][a-z\d]*)/){ "_#{$1.downcase}" }.
      gsub(/^_/, '').
      gsub('::', '/') + '/' + feature_name_postfix

    RubyFeatures.define feature_name do
      apply_to test_class_name, &block
    end
  end
end
