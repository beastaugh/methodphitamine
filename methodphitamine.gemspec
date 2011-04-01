#!/usr/bin/env gem build
# encoding: utf-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'methodphitamine/version'

Gem::Specification.new do |s|
  s.name        = "methodphitamine"
  s.version     = Methodphitamine::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.author      = "Jay Phillips"
  s.email       = "jay@codemecca.com"
  s.homepage    = "http://methodphitamine.rubyforge.org"
  s.summary     = "Syntactically cleaner list comprehensions and monads in Ruby"
  s.description = "The Methodphitamine! Creates the implied block argument 'it'
                   which makes the refining and enumerating of collections much
                   simpler. For example, User.find(:all).collect
                   &its.contacts.map(&its.last_name.capitalize)".sub(/\s+/, " ")
  
  s.required_rubygems_version = ">= 1.3"
  
  s.files      = Dir.glob("lib/**/*.rb") + %w(License.txt History.txt README.markdown)
  s.test_files = Dir.glob("spec/*_spec.rb")
end
