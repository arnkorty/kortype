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
    expect(myclass.foo).to eq 'foo'
    expect(MyClass.kortype_columns[:foo].value).to eq nil
  end

  it 'test type force for class' do
    class Myclass
      include Kortype
      kortype :foo, :bar, type: Time
    end
    myclass = Myclass.new
    myclass.foo = '2012-12-01'
    expect(myclass.foo.class).to eq Time
    expect(myclass.foo.year).to eq 2012
    expect{ myclass.foo = 'fsdf' }.to raise_error(Kortype::TypeError)
  end

  it 'check default value' do
    class Myclass
      include Kortype
      kortype :foo, type: Time, default: Time.now
      kortype :bar, type: Integer, default: -> { 23 + 100}
    end
    myclass = Myclass.new
    expect(myclass.foo.class).to eq Time
    expect(myclass.foo.to_i).to eq Time.now.to_i
    expect(myclass.bar).to eq 123
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
      }, default: File.new('./Gemfile')
    end

    myclass = Myclass.new
    expect(myclass.foo).to eq nil
    myclass.foo = '/'
    expect(myclass.foo.class).to eq File
    expect(myclass.foo.path).to eq '/'
    expect(myclass.bar.class).to eq File
  end

  it 'check regexp validate column' do
    class Myclass1
      include Kortype
      kortype :foo, type: String, validate: /fff/, error_msg: 'the value is error'
    end
    myclass = Myclass1.new
    myclass.foo = 'fsdf'
    expect(myclass.valid?).to eq false
    expect(myclass.error_msg_for(:foo)).to eq 'the value is error'
    myclass.foo = 'fffff'
    expect(myclass.valid?).to eq true
    expect(myclass.error_msg_for(:foo)).to eq nil
  end
end
