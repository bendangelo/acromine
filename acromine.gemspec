# -*- encoding: utf-8 -*-
# stub: acromine 0.1.0.20150721074443 ruby lib

Gem::Specification.new do |s|
  s.name = "acromine"
  s.version = "0.1.0.20150721074443"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James FitzGibbon"]
  s.date = "2015-07-21"
  s.description = "acromine is a client for the [Acromine REST\nService](http://www.nactem.ac.uk/software/acromine/rest.html) provided\nby the National Centre for Text Mining.\n\nThis gem provides a library to easily find the long form of an acronym.\n\nA CLI is also provided to use the library from the command line."
  s.email = ["james@nadt.net"]
  s.extra_rdoc_files = ["History.md", "Manifest.txt", "README.md"]
  s.files = ["History.md", "LICENSE", "Manifest.txt", "README.md", "acromine.gemspec", "lib/acromine.rb", "lib/acromine/core.rb", "lib/acromine/longform.rb", "lib/acromine/longform_variant.rb", "lib/acromine/version.rb"]
  s.homepage = "https://github.com/jf647/acromine"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.4"
  s.summary = "acromine is a client for the [Acromine REST Service](http://www.nactem.ac.uk/software/acromine/rest.html) provided by the National Centre for Text Mining"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gli>, ["~> 2.13"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.13"])
      s.add_runtime_dependency(%q<valuable>, ["~> 0.9"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.13"])
      s.add_development_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.3"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1"])
      s.add_development_dependency(%q<guard>, ["~> 2.12"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.5"])
      s.add_development_dependency(%q<guard-rake>, ["~> 0.0"])
      s.add_development_dependency(%q<guard-rubocop>, ["~> 1.2"])
      s.add_development_dependency(%q<guard-cucumber>, ["~> 1.6"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_development_dependency(%q<simplecov-console>, ["~> 0.2"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_development_dependency(%q<aruba>, ["~> 0.8"])
    else
      s.add_dependency(%q<gli>, ["~> 2.13"])
      s.add_dependency(%q<httparty>, ["~> 0.13"])
      s.add_dependency(%q<valuable>, ["~> 0.9"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.13"])
      s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["~> 10.3"])
      s.add_dependency(%q<rspec>, ["~> 3.1"])
      s.add_dependency(%q<guard>, ["~> 2.12"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.5"])
      s.add_dependency(%q<guard-rake>, ["~> 0.0"])
      s.add_dependency(%q<guard-rubocop>, ["~> 1.2"])
      s.add_dependency(%q<guard-cucumber>, ["~> 1.6"])
      s.add_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_dependency(%q<simplecov-console>, ["~> 0.2"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_dependency(%q<aruba>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<gli>, ["~> 2.13"])
    s.add_dependency(%q<httparty>, ["~> 0.13"])
    s.add_dependency(%q<valuable>, ["~> 0.9"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.13"])
    s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["~> 10.3"])
    s.add_dependency(%q<rspec>, ["~> 3.1"])
    s.add_dependency(%q<guard>, ["~> 2.12"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.5"])
    s.add_dependency(%q<guard-rake>, ["~> 0.0"])
    s.add_dependency(%q<guard-rubocop>, ["~> 1.2"])
    s.add_dependency(%q<guard-cucumber>, ["~> 1.6"])
    s.add_dependency(%q<simplecov>, ["~> 0.9"])
    s.add_dependency(%q<simplecov-console>, ["~> 0.2"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
    s.add_dependency(%q<aruba>, ["~> 0.8"])
  end
end
