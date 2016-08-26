describe RubyFeatures do

  class ConditionsTestClass; end

  RubyFeatures.define 'conditions_test_feature' do
    condition(:boolean) { true }
    condition(:string) { 'string' }

    apply_to 'ConditionsTestClass', if: :boolean do
      class_methods if: {string: 'string'} do
        def boolean_true; end
      end
    end

    apply_to 'ConditionsTestClass', unless: :boolean do
      class_methods do
        def boolean_false; end
      end
    end

    apply_to 'ConditionsTestClass' do
      class_methods if: :boolean do
        def class_boolean_true; end
      end

      class_methods unless: :boolean do
        def class_boolean_false; end
      end

      instance_methods if: :boolean do
        def instance_boolean_true; end
      end

      instance_methods unless: :boolean do
        def instance_boolean_false; end
      end

      applied if: :boolean do
        attr_accessor :boolean_true_accessor
      end

      applied unless: :boolean do
        attr_accessor :boolean_false_accessor
      end

    end

  end.apply

  subject { ConditionsTestClass }

  it 'should respect conditions when appling to target' do
    expect(subject).to respond_to(:boolean_true)
    expect(subject).to_not respond_to(:boolean_false)

    expect(subject.singleton_class.included_modules).to include(
      RubyFeatures::Mixins::ConditionsTestFeature::ConditionsTestClass::AddClassMethodsIfBooleanIsTrueAndStringIsString
    )
  end

  it 'should respect conditions for class methods' do
    expect(subject).to respond_to(:class_boolean_true)
    expect(subject).to_not respond_to(:class_boolean_false)
  end

  it 'should respect conditions for instance methods' do
    expect(subject.new).to respond_to(:instance_boolean_true)
    expect(subject.new).to_not respond_to(:instance_boolean_false)
  end

  it 'should respect conditions for applied blocks' do
    expect(subject.new).to respond_to(:boolean_true_accessor)
    expect(subject.new).to_not respond_to(:boolean_false_accessor)
  end

  it 'should raise error if such condition is aready defined' do
    expect{
      RubyFeatures.define 'conditions_test_class/duplicate_conditions' do
        condition(:duplicate_condition){ :duplicate_condition }
        condition('duplicate_condition'){ 'duplicate_condition' }
      end
    }.to raise_error(/Such condition is already defined/)
  end

end
