require 'spec_helper'
describe Kortype do
  it 'add kortype define attribute' do
    class MyClass
      include Kortype
      kortype :foo, :bar, type: :String
      kortype :foo1, :bar1, type: Time
    end
    expect(MyClass.kortype_columns.size).to eq  4
    expect(MyClass.new.kortype_columns.size).to eq 4
    expect(MyClass.new.kortype_columns[:foo].is_a? Kortype::Type).to eq true
    expect(MyClass.kortype_columns.keys == [:foo, :bar, :foo1, :bar1]).to eq true
  end

  it 'child class do not change parent class kortype columns' do
    class MyClass
      include Kortype
      kortype :foo, :bar, type: :String
      kortype :foo1, :bar1, type: Time
    end
    myclass = MyClass.new
    myclass.foo = 'foo'
    myclass.foo == 'foo'
    myclass.foo != MyClass.kortype_columns[:foo].value
  end

  it 'test type force for class' do
    class Myclass
      include Kortype
      kortype :foo, :bar, type: Time
    end
    myclass = Myclass.new
    myclass.foo = '2012-12-01'
    expect(myclass.foo.class).to eq Time
    myclass.foo.year == 2012
    expect{ myclass.foo = 'fsdf' }.to raise_error(Kortype::TypeError)
  end

  it 'check default value' do
    class Myclass
      include Kortype
      kortype :foo, type: Time, default: Time.now
      kortype :bar, type: Integer, default: -> { 23 + 100}
    end
    myclass = Myclass.new
    myclass.foo.class == Time
    myclass.foo.to_i == Time.now.to_i
    myclass.bar == 123
  end

  it 'check custom parse' do
    class Myclass
      include Kortype
      kortype :foo, type: File, parse: ->(val) {
        if String === val
          File.new val
        else
          val
        end
      }
      kortype :bar, type: File, parse: ->(val) {
        if String === val
          File.new val
        else
          val
        end
      }, default: './Gemfile'
    end

    myclass = Myclass.new
    myclass.foo == nil
    myclass.foo = '/'
    myclass.foo.class == File
    myclass.foo.path == '/'
    myclass.bar.class == File
  end
end
