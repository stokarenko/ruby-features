describe RubyFeatures::Single do

  prepare_test_class 'DefineTestModule::DefineTestClass'

  it 'should apply class methods' do
    expect{
      define_test_feature('class_methods') do
        class_methods do
          def test_class_method; end
        end
      end.apply
    }.to change{test_class.respond_to?(:test_class_method)}.from(false).to(true)
  end

  it 'should apply instance methods' do
    expect{
      define_test_feature('instance_methods') do
        instance_methods do
          def test_instance_method; end
        end
      end.apply
    }.to change{test_class.new.respond_to?(:test_instance_method)}.from(false).to(true)
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

end