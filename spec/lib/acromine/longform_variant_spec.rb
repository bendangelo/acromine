require 'acromine/longform_variant'

RSpec.describe Acromine::LongformVariant do
  describe '#new' do
    it 'can be constructed empty' do
      lfv = Acromine::LongformVariant.new
      expect(lfv).to be_a Acromine::LongformVariant
    end

    it 'can be constructed with parameters' do
      lfv = Acromine::LongformVariant.new(
        longform: 'Transmission Control Protocol',
        frequency: 5,
        since: 2010
      )
      expect(lfv).to be_a Acromine::LongformVariant
      expect(lfv.longform).to eq('Transmission Control Protocol')
      expect(lfv.frequency).to eq(5)
      expect(lfv.since).to eq(2010)
    end
  end

  describe '#LongformVariant' do
    it 'should allow the long form to be set' do
      lfv = Acromine::LongformVariant.new
      expect(lfv.longform).to be_nil
      lfv.longform 'heavy meromyosin'
      expect(lfv.longform).to eq('heavy meromyosin')
    end
  end

  describe '#frequency' do
    it 'should allow the frequency to be set' do
      lfv = Acromine::LongformVariant.new
      expect(lfv.frequency).to be_nil
      lfv.frequency 5
      expect(lfv.frequency).to eq(5)
    end

    it 'should cast frequency strings to integers' do
      lfv = Acromine::LongformVariant.new
      expect(lfv.frequency).to be_nil
      lfv.frequency '5'
      expect(lfv.frequency).to eq(5)
    end
  end

  describe '#since' do
    it 'should allow the since to be set' do
      lfv = Acromine::LongformVariant.new
      expect(lfv.since).to be_nil
      lfv.frequency 2010
      expect(lfv.frequency).to eq(2010)
    end

    it 'should cast since strings to integers' do
      lfv = Acromine::LongformVariant.new
      expect(lfv.since).to be_nil
      lfv.frequency '2010'
      expect(lfv.frequency).to eq(2010)
    end
  end
end
