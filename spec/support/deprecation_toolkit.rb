# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

require 'deprecation_toolkit/rspec'

DeprecationToolkit::Configuration.test_runner = :rspec

# Treat Ruby deprecation warnings as errors.
DeprecationToolkit::Configuration.warnings_treated_as_deprecation = [ %r{deprecat}i ]

# Ignore deprecation warnings from dependencies.
DeprecationToolkit::Configuration.allowed_deprecations = [
  lambda do |_message, stack|
    path = stack.first.absolute_path.to_s
    path.include?('/ruby/') || path.include?('/gems/')
  end
]
