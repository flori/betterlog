require 'spec_helper'

describe Betterlog::GlobalMetadata do
  class FakeNotifierClass
    def notify(message, hash) end

    def context(data_hash) end
  end

  let :notifier do
    FakeNotifierClass.new
  end

  around do |example|
    Betterlog::Notifiers.register(notifier)
    example.run
  ensure
    Betterlog::Notifiers.notifiers.clear
    described_class.data.clear
  end

  it 'can haz empty data' do
    expect(described_class.data).to eq({})
  end

  it 'can haz some data' do
    described_class.data |= { foo: 'bar' }
    expect(described_class.data).to eq({ foo: 'bar' })
  end

  it 'can "add" data' do
    expect_any_instance_of(FakeNotifierClass).to receive(:context).with(foo: 'bar')
    expect(described_class.add(foo: 'bar')).to eq described_class.instance
  end

  it 'can "add" data via Log.context' do
    expect_any_instance_of(FakeNotifierClass).to receive(:context).with(foo: 'bar')
    Betterlog::Log.context(foo: 'bar')
  end
end
