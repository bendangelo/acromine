require 'acromine'

RSpec.describe Acromine do
  describe '::new' do
    it 'can be constructed with the default URI' do
      acro = Acromine.new
      expect(acro).to be_a Acromine
      expect(acro.class.base_uri).to eq(Acromine::DEFAULT_URI)
    end

    it 'can be constructed with an alternate URI' do
      acro = Acromine.new('http://localhost')
      expect(acro).to be_a Acromine
      expect(acro.class.base_uri).to eq('http://localhost')
    end
  end

  describe '#longforms' do
    include HTTParty::StubResponse

    before do
      @acro = Acromine.new('http://localhost')
    end

    it 'should parse a good response' do
      stub_http_response_with('HMM_good.json')
      lfs = @acro.longforms('HMM')
      expect(lfs.size).to eq(8)
    end

    it 'should limit the number of responses' do
      stub_http_response_with('HMM_good.json')
      lfs = @acro.longforms('HMM', limit: 5)
      expect(lfs.size).to eq(5)
    end

    it 'should reject an invalid limit' do
      expect { @acro.longforms('HMM', limit: 'foo') }
        .to raise_error(RuntimeError)
      expect { @acro.longforms('HMM', limit: -1) }
        .to raise_error(RuntimeError)
      expect { @acro.longforms('HMM', limit: '-1') }
        .to raise_error(RuntimeError)
    end

    it 'should sort by year asc, freq desc' do
      stub_http_response_with('HMM_good.json')
      lfs = @acro.longforms('HMM', sort_spec: 'ya,fd')
      expect(lfs[0].longform).to eq 'heavy meromyosin'
    end

    it 'should sort by year desc, freq asc' do
      stub_http_response_with('HMM_good.json')
      lfs = @acro.longforms('HMM', sort_spec: 'yd,fa')
      expect(lfs[0].longform).to eq 'Home Management of Malaria'
    end

    it 'should reject an invalid sort spec' do
      expect { @acro.longforms('HMM', sort_spec: 'foo') }
        .to raise_error(RuntimeError)
    end

    it 'should return an empty list for an acronym not found' do
      stub_http_response_with('definitelynotfound_empty.json')
      lfs = @acro.longforms('definitelynotfound')
      expect(lfs).to eq []
    end

    it 'should raise an error if the response is not JSON' do
      stub_http_response_with('not_json.html')
      expect { @acro.longforms('not_json') }
        .to raise_error NoMethodError
    end
  end

  # Private method testing
  # Purists can register their complaints via Github issues
  describe '#validate_opts' do
    it 'raises an error on a non-numeric limit' do
      acro = Acromine.new
      expect { acro.send(:validate_opts, limit: 'foo') }
        .to raise_error(/invalid limit/)
    end

    it 'raises an error on a limit less than 1' do
      acro = Acromine.new
      expect { acro.send(:validate_opts, limit: 0) }
        .to raise_error(/invalid limit/)
      expect { acro.send(:validate_opts, limit: -3) }
        .to raise_error(/invalid limit/)
    end

    it 'raises an error on too many sort specs' do
      acro = Acromine.new
      expect { acro.send(:validate_opts, sort_spec: 'aa,bb,cc') }
        .to raise_error(/too many sort specs/)
    end

    it 'raises an error on invalid sort specs' do
      acro = Acromine.new
      expect { acro.send(:validate_opts, sort_spec: 'aa') }
        .to raise_error(/invalid sort spec/)
      expect { acro.send(:validate_opts, sort_spec: 'ya,aa') }
        .to raise_error(/invalid sort spec/)
      expect { acro.send(:validate_opts, sort_spec: 'ay,df') }
        .to raise_error(/invalid sort spec/)
    end
  end

  describe '#build_lfs' do
    it 'can construct a set of longforms from data' do
      acro = Acromine.new
      json = file_fixture_json('HMM_good.json')
      lfs = acro.send(:build_lfs, json)
      expect(lfs).to be_a Array
      expect(lfs[0]).to be_a Acromine::Longform
      expect(lfs[0].variants[0]).to be_a Acromine::LongformVariant
    end

    it 'throws an error for a bad document' do
      acro = Acromine.new
      json = file_fixture_json('definitelynotfound_empty.json')
      expect { acro.send(:build_lfs, json) }
        .to raise_error NoMethodError
    end
  end

  describe '#massage_data' do
    before do
      @acro = Acromine.new
      @json = file_fixture_json('sortable.json')
    end

    it 'should sort in fd,ya order by default' do
      lfs = @acro.send(:massage_data, @json[0]['lfs'])
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tricalcium phosphate',
        'toxin-coregulated pilus',
        'tumor control probability',
        'tranylcypromine',
        '2,4,6-trichlorophenol',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end

    it 'should sort properly by fd,ya order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'fd,ya'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tricalcium phosphate',
        'toxin-coregulated pilus',
        'tumor control probability',
        'tranylcypromine',
        '2,4,6-trichlorophenol',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end

    it 'should sort properly by fa,yd order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'fa,yd'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tropical calcific pancreatitis',
        'tricresyl phosphate',
        '3,5,6-trichloro-2-pyridinol',
        '2,4,6-trichlorophenol',
        'tranylcypromine',
        'tumor control probability',
        'toxin-coregulated pilus',
        'tricalcium phosphate'
      ])
    end

    it 'should sort properly by fd,yd order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'fd,yd'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'toxin-coregulated pilus',
        'tricalcium phosphate',
        'tumor control probability',
        '2,4,6-trichlorophenol',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end

    it 'should sort properly by fa,ya order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'fa,ya'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tropical calcific pancreatitis',
        'tricresyl phosphate',
        '3,5,6-trichloro-2-pyridinol',
        'tranylcypromine',
        '2,4,6-trichlorophenol',
        'tumor control probability',
        'tricalcium phosphate',
        'toxin-coregulated pilus'
      ])
    end

    it 'should sort properly by ya,fa order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'ya,fa'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tropical calcific pancreatitis',
        'tricresyl phosphate',
        '3,5,6-trichloro-2-pyridinol',
        'tranylcypromine',
        'tumor control probability',
        'tricalcium phosphate',
        '2,4,6-trichlorophenol',
        'toxin-coregulated pilus'
      ])
    end

    it 'should sort properly by ya,fd order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'ya,fd'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tricresyl phosphate',
        'tropical calcific pancreatitis',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricalcium phosphate',
        'tumor control probability',
        'toxin-coregulated pilus',
        '2,4,6-trichlorophenol'
      ])
    end

    it 'should sort properly by yd,fa order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'yd,fa'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        '2,4,6-trichlorophenol',
        'toxin-coregulated pilus',
        'tumor control probability',
        'tricalcium phosphate',
        '3,5,6-trichloro-2-pyridinol',
        'tranylcypromine',
        'tropical calcific pancreatitis',
        'tricresyl phosphate'
      ])
    end

    it 'should sort properly by yd,fd order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'yd,fd'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'toxin-coregulated pilus',
        '2,4,6-trichlorophenol',
        'tricalcium phosphate',
        'tumor control probability',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end

    it 'should sort properly by ya order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'ya'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tropical calcific pancreatitis',
        'tricresyl phosphate',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricalcium phosphate',
        'tumor control probability',
        'toxin-coregulated pilus',
        '2,4,6-trichlorophenol'
      ])
    end

    it 'should sort properly by yd order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'yd'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'toxin-coregulated pilus',
        '2,4,6-trichlorophenol',
        'tricalcium phosphate',
        'tumor control probability',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end

    it 'should sort properly by fa order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'fa'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tropical calcific pancreatitis',
        'tricresyl phosphate',
        '3,5,6-trichloro-2-pyridinol',
        '2,4,6-trichlorophenol',
        'tranylcypromine',
        'tumor control probability',
        'toxin-coregulated pilus',
        'tricalcium phosphate'
      ])
    end

    it 'should sort properly by fd order' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'], sort_spec: 'fd'
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tricalcium phosphate',
        'toxin-coregulated pilus',
        'tumor control probability',
        '2,4,6-trichlorophenol',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end

    it 'should limit to 3 entries' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'],
        sort_spec: 'fd', limit: 3
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tricalcium phosphate',
        'toxin-coregulated pilus',
        'tumor control probability'
      ])
    end

    it 'should not limit with a high limit' do
      lfs = @acro.send(
        :massage_data, @json[0]['lfs'],
        sort_spec: 'fd', limit: 10
      )
      terms = lfs.map { |e| e['lf'] }
      expect(terms).to eq([
        'tricalcium phosphate',
        'toxin-coregulated pilus',
        'tumor control probability',
        '2,4,6-trichlorophenol',
        'tranylcypromine',
        '3,5,6-trichloro-2-pyridinol',
        'tricresyl phosphate',
        'tropical calcific pancreatitis'
      ])
    end
  end

  describe '#build_sort_xforms' do
    before do
      @acro = Acromine.new
      @data = { 'freq' => 10, 'since' => 2000 }
    end

    it 'should return a transform for fa' do
      xforms = @acro.send(:build_sort_xforms, 'fa')
      ret = xforms.map { |x| x.call(@data) }
      expect(ret).to eq([10])
    end

    it 'should return a transform for fd' do
      xforms = @acro.send(:build_sort_xforms, 'fd')
      ret = xforms.map { |x| x.call(@data) }
      expect(ret).to eq([-10])
    end

    it 'should return a transform for ya' do
      xforms = @acro.send(:build_sort_xforms, 'ya')
      ret = xforms.map { |x| x.call(@data) }
      expect(ret).to eq([2000])
    end

    it 'should return a transform for yd' do
      xforms = @acro.send(:build_sort_xforms, 'yd')
      ret = xforms.map { |x| x.call(@data) }
      expect(ret).to eq([-2000])
    end

    it 'should return a transform for fa,yd' do
      xforms = @acro.send(:build_sort_xforms, 'fa,yd')
      ret = xforms.map { |x| x.call(@data) }
      expect(ret).to eq([10, -2000])
    end
  end

  describe '#build_lf' do
    it 'can be constructed' do
      acro = Acromine.new
      json = file_fixture_json('HMM_good_lf.json')
      lf = acro.send(:build_lf, json)
      expect(lf).to be_a Acromine::Longform
      expect(lf.longform).to eq('heavy meromyosin')
      expect(lf.frequency).to eq(267)
      expect(lf.since).to eq(1971)
      expect(lf.variants.size).to eq(6)
      expect(lf.variants[0].longform).to eq('heavy meromyosin')
    end

    it 'can be constructed with missing fields' do
      acro = Acromine.new
      json = file_fixture_json('HMM_missing_lf.json')
      lf = acro.send(:build_lf, json)
      expect(lf).to be_a Acromine::Longform
      expect(lf.longform).to eq('heavy meromyosin')
      expect(lf.frequency).to be_nil
      expect(lf.since).to eq(1971)
    end

    it 'can be constructed with extra fields' do
      acro = Acromine.new
      json = file_fixture_json('HMM_extra_lf.json')
      lf = acro.send(:build_lf, json)
      expect(lf).to be_a Acromine::Longform
      expect(lf.longform).to eq('heavy meromyosin')
      expect(lf.frequency).to eq(267)
      expect(lf.since).to eq(1971)
    end

    it 'fails to be constructed if passed a non-hash' do
      acro = Acromine.new
      json = file_fixture_json('HMM_bad_lf.json')
      expect { acro.send(:build_lf, json) }
        .to raise_error TypeError
    end
  end

  describe '#build_lfv' do
    it 'can be constructed' do
      acro = Acromine.new
      json = file_fixture_json('HMM_good_lfv.json')
      lf = acro.send(:build_lfv, json)
      expect(lf).to be_a Acromine::LongformVariant
      expect(lf.longform).to eq('heavy meromyosin')
      expect(lf.frequency).to eq(244)
      expect(lf.since).to eq(1971)
    end

    it 'can be constructed with missing fields' do
      acro = Acromine.new
      json = file_fixture_json('HMM_missing_lfv.json')
      lfv = acro.send(:build_lfv, json)
      expect(lfv).to be_a Acromine::LongformVariant
      expect(lfv.longform).to eq('heavy meromyosin')
      expect(lfv.frequency).to be_nil
      expect(lfv.since).to eq(1971)
    end

    it 'can be constructed with extra fields' do
      acro = Acromine.new
      json = file_fixture_json('HMM_extra_lfv.json')
      lfv = acro.send(:build_lfv, json)
      expect(lfv).to be_a Acromine::LongformVariant
      expect(lfv.longform).to eq('heavy meromyosin')
      expect(lfv.frequency).to eq(244)
      expect(lfv.since).to eq(1971)
    end

    it 'fails to be constructed if passed a non-hash' do
      acro = Acromine.new
      json = file_fixture_json('HMM_bad_lfv.json')
      expect { acro.send(:build_lfv, json) }
        .to raise_error TypeError
    end
  end
end
