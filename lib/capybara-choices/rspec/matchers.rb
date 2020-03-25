require 'rspec/expectations'
require 'capybara-choices/selectors'

RSpec::Matchers.define :have_choices_option do |expected|
  def option_matcher(element)
    choices_container = element.find('.choices', match: :first)

    choices_version = CapybaraChoices::Utils.detect_choices_version(choices_container)

    CapybaraChoices::Selectors.option_selector(choices_version)
  end

  match do |element|
    expect(element).to have_css option_matcher(element), text: expected
  end

  match_when_negated do |element|
    expect(element).not_to have_css option_matcher(element), text: expected
  end
end
