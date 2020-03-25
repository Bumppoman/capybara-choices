require 'spec_helper'
require 'capybara-choices/helpers'

choices_version ||= ENV['CHOICES_VERSION'] || SupportedVersions.first

def open_choices(page, selector)
  CapybaraChoices::Helpers.choices_open(page: page, container: page.find(:css, selector))
end

describe CapybaraChoices do

  context "with Choices.js version #{choices_version}" do

    before { visit "/choices/v#{choices_version}/examples" }

    context 'with a single select box' do

      it 'should confirm that the page has a choices option with a specific text' do
        open_choices(page, '#single')
        expect(page).to have_choices_option('XBox')
      end

      it 'should confirm that there is no choices option with a specific text' do
        open_choices(page, '#single')
        expect(page).not_to have_choices_option('PC4')
      end
    end

    context 'witn a multi select box' do

      it 'should confirm that there is a choices option with a specific text' do
        open_choices(page, '#multiple')
        expect(page).to have_choices_option('Buy Milk')
      end

      it 'should confirm that there is no choices option with a specific text' do
        open_choices(page, '#multiple')
        expect(page).not_to have_choices_option('Travel to Minsk')
      end
    end
  end
end
