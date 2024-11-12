# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec core configuration files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files (library and drivers)
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files (focused on controllers and routes)
  rails = dsl.rails
  dsl.watch_spec_files_for(rails.app_files)

  # Observes changes in controllers and runs tests on corresponding requests
  watch(%r{^app/controllers/(.+)_controller\.rb$}) do |m|
    "spec/requests/#{m[1]}_spec.rb"
  end

  # Run route tests when there are changes to config/routes.rb
  watch(rails.routes) { "#{rspec.spec_dir}/routing" }

  # Observes changes to models and runs corresponding model tests
  watch(%r{^app/models/(.+)\.rb$}) do |m|
    "spec/models/#{m[1]}_spec.rb"
  end
end
