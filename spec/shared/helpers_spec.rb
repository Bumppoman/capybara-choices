require 'spec_helper'
require 'capybara-choices/helpers'

choices_version ||= ENV['CHOICES_VERSION'] || SupportedVersions.first

def get_values(selector)
  page.evaluate_script "Array.prototype.map.call(document.querySelector('#{selector}').selectedOptions, (option) => { return option.value });"
end
alias :get_value :get_values

describe CapybaraChoices do

  include CapybaraChoices::Helpers

  context "with Choices.js version #{choices_version}", type: :feature do

    before { visit "/choices/v#{choices_version}/examples" }

    context 'with a single select box' do

      it 'should open choices control' do
        choices_open label: 'game console'
        expect(page).to have_css '.choices__item--choice', text: 'XBox'
      end

      it 'should close choices control' do
        choices_open label: 'game console'

        choices_close
        expect(page).not_to have_css '.choices__item--choice', text: 'XBox'
      end

      it 'should type into a choices search field' do
        choices_open label: 'game console'

        choices_search 'box', label: 'game console'
        expect(page).not_to have_css '.choices__item--choice', text: 'Wii'
      end

      it 'should select an option from an opened choices control' do
        choices_open label: 'game console'

        choices_select 'XBox', from: 'game console'
        expect(get_value('#console')).to eq ['xbox']
      end

      xit 'should clear selected options' do
        choices_open label: 'game console'

        choices_select 'XBox', from: 'game console'
        choices_clear label: 'game console'
        expect(get_value('#console')).to eq ''
      end
    end

    context 'witn a multi select box' do

      it 'should open select control' do
        choices_open css: '#multiple'
        expect(page).to have_css '.choices__item--choice', text: 'Go to gym'
      end

      it 'should close select control' do
        choices_open css: '#multiple'

        choices_close
        expect(page).not_to have_css '.choices__item--choice', text: 'Go to gym'
      end

      xit 'should type into a choices search field' do
        choices_open css: '#multiple'

        choices_search 'Go to gym', css: '#multiple'
        expect(page).not_to have_css '.choices__item--choice', text: 'Buy Milk'
      end

      it 'should select an option from an opened choices control' do
        choices_open css: '#multiple'

        choices_select 'Go to gym', css: '#multiple'
        expect(get_values('#todo')).to eq ['go to gym']
      end

      it 'should clear selected options' do
        choices_open css: '#multiple'

        choices_select 'Go to gym', css: '#multiple'
        choices_clear css: '#multiple'

        expect(get_values('#todo')).to eq([]).or eq(nil)
      end
    end
  end
end
