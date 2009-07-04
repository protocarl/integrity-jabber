# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{integrity-jabber}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Carl Porth"]
  s.date = %q{2009-07-03}
  s.email = %q{badcarl@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "integrity-jabber.gemspec",
     "lib/integrity/notifier/config.haml",
     "lib/integrity/notifier/jabber.rb",
     "test/remote/integrity-jabber-test-config.yml.sample",
     "test/remote/integrity_jabber_remote_test.rb",
     "test/test_helper.rb",
     "test/unit/integrity_jabber_test.rb"
  ]
  s.homepage = %q{http://github.com/badcarl/integrity-jabber}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A jabber notifier for integrity}
  s.test_files = [
    "test/remote/integrity_jabber_remote_test.rb",
     "test/test_helper.rb",
     "test/unit/integrity_jabber_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<integrity>, [">= 0"])
      s.add_runtime_dependency(%q<xmpp4r>, [">= 0"])
    else
      s.add_dependency(%q<integrity>, [">= 0"])
      s.add_dependency(%q<xmpp4r>, [">= 0"])
    end
  else
    s.add_dependency(%q<integrity>, [">= 0"])
    s.add_dependency(%q<xmpp4r>, [">= 0"])
  end
end
