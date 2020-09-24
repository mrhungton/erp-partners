$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "erp/partners/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "erp_partners"
  s.version     = Erp::Partners::VERSION
  s.authors     = ["Hung Nguyen"]
  s.email       = ["hungnt@hoangkhang.com.vn"]
  s.homepage    = "http://globalnaturesoft.com/"
  s.summary     = "Partners features of Erp System."
  s.description = "Partners features of Erp System."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 5.1.7"
  s.add_dependency "erp_core"
  s.add_dependency "deface"
end
