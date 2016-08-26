describe RubyFeatures::Concern::Feature do

  prepare_test_class 'DefineTestModule::DefineTestClass'

  it 'should apply class methods' do
    expect{
      define_test_feature('class_methods_feature') do
        class_methods do
          def test_class_method; end
        end
      end.apply
    }.to change{test_class.respond_to?(:test_class_method)}.from(false).to(true)


    expect(test_class.singleton_class.included_modules).to include(
      RubyFeatures::Mixins::DefineTestModule::DefineTestClass::ClassMethodsFeature::DefineTestModule::DefineTestClass::AddClassMethods
    )
  end

  it 'should apply instance methods' do
    expect{
      define_test_feature('instance_methods_feature') do
        instance_methods do
          def test_instance_method; end
        end
      end.apply
    }.to change{test_class.new.respond_to?(:test_instance_method)}.from(false).to(true)

    expect(test_class.included_modules).to include(
      RubyFeatures::Mixins::DefineTestModule::DefineTestClass::InstanceMethodsFeature::DefineTestModule::DefineTestClass::AddInstanceMethods
    )
  end

  it 'should apply rewrite instance methods' do
    test_class.class_eval do
      def test_rewrite_instance_method
        2
      end
    end

    expect{
      define_test_feature('rewrite_instance_methods_feature') do
        rewrite_instance_methods do
          def test_rewrite_instance_method
            3 * super
          end
        end
      end.apply
    }.to change{test_class.new.test_rewrite_instance_method}.from(2).to(6)

    expect(test_class.included_modules).to include(
      RubyFeatures::Mixins::DefineTestModule::DefineTestClass::RewriteInstanceMethodsFeature::DefineTestModule::DefineTestClass::RewriteInstanceMethods
    )
  end

  it 'should process applied block' do
    expect{
      define_test_feature('applied_block') do
        applied do
          attr_accessor :applied_block_accessor
        end
      end.apply
    }.to change{test_class.new.respond_to?(:applied_block_accessor)}.from(false).to(true)
  end

  it 'should check that feature name is correct' do
    expect{
      define_test_feature('wrong feature name')
    }.to raise_error(/Wrong feature name/)
  end

  it 'should raise error if target already has feature class method' do
    test_class.class_eval do
      class << self
        def existing_class_method; end
        private
        def existing_private_class_method; end
      end
    end

    expect{
      define_test_feature('existing_class_method') do
        class_methods do
          def existing_class_method; end
          private
          def existing_private_class_method; end
        end
      end.apply
    }.to raise_error(/Tried to add already existing class methods: \[:existing_class_method, :existing_private_class_method\]/)
  end

  it 'should raise error if target already has feature instance method' do
    test_class.class_eval do
      def existing_instance_method; end
      private
      def existing_private_instance_method; end
    end

    expect{
      define_test_feature('existing_instance_method') do
        instance_methods do
          def existing_instance_method; end
          private
          def existing_private_instance_method; end
        end
      end.apply
    }.to raise_error(/Tried to add already existing instance methods: \[:existing_instance_method, :existing_private_instance_method\]/)
  end

  it 'should raise error if target has no feature rewrite instance method' do
    expect{
      define_test_feature('not_existing_rewrite_instance_method') do
        rewrite_instance_methods do
          def not_existing_instance_method; end
          private
          def not_existing_private_instance_method; end
        end
      end.apply
    }.to raise_error(/Tried to rewrite not existing instance methods: \[:not_existing_instance_method, :not_existing_private_instance_method\]/)
  end

end
