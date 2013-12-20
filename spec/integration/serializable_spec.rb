# encoding: utf-8

require 'spec_helper'

class Serializable
  include Memoizable

  def method
    rand(10000)
  end
  memoize :method
end

describe 'A serializable object' do
  let(:serializable) do
    Serializable.new
  end

  before do
    serializable.method # Call the method to trigger lazy memoization
  end

  it 'is serializable with Marshal' do
    expect { Marshal.dump(serializable) }.not_to raise_error
  end

  it 'is deserializable with Marshal' do
    serialized = Marshal.dump(serializable)
    deserialized = Marshal.load(serialized)

    expect(deserialized).to be_an_instance_of(Serializable)
    expect(deserialized.method).to eql(serializable.method)
  end
end
