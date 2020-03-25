require 'capybara-choices/version'
require 'capybara-choices/utils'
require 'capybara-choices/helpers'

module CapybaraChoices

  def choices(*args)
    options = args.pop
    values = args

    Utils.validate_options!(options)

    container = Utils.find_choices_container(options, page)
    options_with_choices_details =
      options.merge({ container: container, page: page })

    values.each do |value|
      Helpers.choices_open(options_with_choices_details)

      if options[:search] || options[:tag]
        term = options[:search].is_a?(String) ? options[:search] : value
        Helpers.choices_search(term, options_with_choices_details)
      end

      Helpers.choices_select(value, options_with_choices_details)
    end
  end
end

if defined?(RSpec)
  require 'rspec/core'
  require 'capybara-choices/rspec/matchers'

  RSpec.configure do |config|
    config.include CapybaraChoices
  end
end

if respond_to?(:World)
  World(CapybaraChoices)
end
