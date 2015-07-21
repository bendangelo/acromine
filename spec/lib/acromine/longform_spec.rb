require 'acromine/longform'

RSpec.describe Acromine::Longform do
  describe '#new' do
    it 'can be constructed empty' do
      lf = Acromine::Longform.new
      expect(lf).to be_a Acromine::Longform
    end

    it 'can be constructed with parameters' do
      lf = Acromine::Longform.new(
        longform: 'Transmission Control Protocol',
        frequency: 5,
        since: 2010
      )
      expect(lf).to be_a Acromine::Longform
      expect(lf.longform).to eq('Transmission Control Protocol')
      expect(lf.frequency).to eq(5)
      expect(lf.since).to eq(2010)
    end
  end

  describe '#longform' do
    it 'should allow the long form to be set' do
      lf = Acromine::Longform.new
      expect(lf.longform).to be_nil
      lf.longform 'heavy meromyosin'
      expect(lf.longform).to eq('heavy meromyosin')
    end
  end

  describe '#frequency' do
    it 'should allow the frequency to be set' do
      lf = Acromine::Longform.new
      expect(lf.frequency).to be_nil
      lf.frequency 5
      expect(lf.frequency).to eq(5)
    end

    it 'should cast frequency strings to integers' do
      lf = Acromine::Longform.new
      expect(lf.frequency).to be_nil
      lf.frequency '5'
      expect(lf.frequency).to eq(5)
    end
  end

  describe '#since' do
    it 'should allow the since to be set' do
      lf = Acromine::Longform.new
      expect(lf.since).to be_nil
      lf.frequency 2010
      expect(lf.frequency).to eq(2010)
    end

    it 'should cast since strings to integers' do
      lf = Acromine::Longform.new
      expect(lf.since).to be_nil
      lf.frequency '2010'
      expect(lf.frequency).to eq(2010)
    end
  end

  describe '#variants' do
    it 'should allow the variants to be set' do
      lf = Acromine::Longform.new
      expect(lf.since).to be_nil
      lf.frequency 2010
      expect(lf.frequency).to eq(2010)
    end

    it 'should allow the variants to be mutated' do
      lf = Acromine::Longform.new
      expect(lf.variants).to eq([])
      lfv = Acromine::LongformVariant.new
      lf.variants = [lfv]
      expect(lf.variants).to include(lfv)
    end

    it 'should fail if something other than a variant is added' do
      lf = Acromine::Longform.new
      expect(lf.variants).to eq([])
      expect { lf.variants = ['foo'] }.to raise_error NoMethodError
    end

    it 'should convert hashes to variants when mutating' do
      lf = Acromine::Longform.new
      lfvdata = {
        longform: 'heavy meromyosin', frequency: 5, since: '2010'
      }
      lf.variants = [lfvdata]
      expect(lf.variants[0]).to be_a Acromine::LongformVariant
      expect(lf.variants[0].since).to eq(2010)
    end
  end
end
