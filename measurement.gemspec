# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{measurement}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Wells"]
  s.date = %q{2010-08-24}
  s.description = %q{A library for holding, converting and formatting measurements}
  s.email = %q{jemmyw@gmail.com}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc", "lib/measurement.rb", "lib/measurement/length.rb", "lib/measurement/unit.rb", "lib/measurement/unit_group.rb", "lib/measurement/weight.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README.rdoc", "Rakefile", "lib/measurement.rb", "lib/measurement/length.rb", "lib/measurement/unit.rb", "lib/measurement/unit_group.rb", "lib/measurement/weight.rb", "spec/lib/length_spec.rb", "spec/lib/measurement_spec.rb", "spec/lib/unit_spec.rb", "spec/lib/weight_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "measurement.gemspec"]
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Measurement", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{measurement}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A library for holding, converting and formatting measurements}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
