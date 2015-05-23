describe RubyFeatures do

  class ConditionsTestClass; end

  RubyFeatures.define 'conditions_test_class/conditions' do
    condition(:boolean) { true }

    apply_to 'ConditionsTestClass', if: :boolean do
      class_methods do
        def boolean_true; end
      end
    end

    apply_to 'ConditionsTestClass', unless: :boolean do
      class_methods do
        def boolean_false; end
      end
    end

  end.apply

  subject { ConditionsTestClass }

  it 'should respect conditions when appling to target' do
    expect(subject).to respond_to(:boolean_true)
    expect(subject).to_not respond_to(:boolean_false)
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
