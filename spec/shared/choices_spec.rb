require 'spec_helper'

choices_version ||= ENV['CHOICES_VERSION'] || SupportedVersions.first

def get_values(selector)
  page.evaluate_script "Array.prototype.map.call(document.querySelector('#{selector}').selectedOptions, (option) => { return option.value });"
end
alias :get_value :get_values

describe CapybaraChoices, type: :feature do

  context "with Choices.js version #{choices_version}" do

    before { visit "/choices/v#{choices_version}/examples" }

    it "should select several options at once" do
      choices 'Buy Milk', 'Go to gym', css: '#multiple'
      expect(get_values('#todo')).to eql ['buy milk', 'go to gym']
    end

    context 'when no options are specified' do

      it 'should raise error that user must specify :css, :xpath or :from options' do
        expect {
          choices 'Buy Milk'
        }.to raise_error "Please specify :css, :xpath or :from in options"
      end

    end

    context 'with a single select box' do

      it 'should select an option from a select found by an XPath selector' do
        choices 'XBox', xpath: "//div[@id='single']"
        expect(get_value('#console')).to eql ['xbox']
      end

      it 'should select an option from a select found by a CSS selector' do
        choices 'XBox', css: '#single'
        expect(get_value('#console')).to eql ['xbox']
      end

      it 'should select an option from a select found by a label' do
        choices 'XBox', from: 'Select game console'
        expect(get_value('#console')).to eql ['xbox']
      end

      it 'should allow to re-select an already selected option' do
        choices 'XBox', css: '#single'
        choices 'XBox', css: '#single'

        expect(get_values('#console')).to eql ['xbox']
      end

      context 'searching for an option' do

        it 'should search by an option text if used with "{ search: true }"' do
          expect(CapybaraChoices::Helpers)
            .to receive(:choices_search).with('XBox', any_args)

          choices 'XBox', css: '#single', search: true
        end

        it 'should search by the passed string if used with "{ search: "a string" }"' do
          expect(CapybaraChoices::Helpers)
            .to receive(:choices_search).with('Box', any_args)

          choices 'XBox', css: '#single', search: 'Box'
        end

        it 'should select the first matched option from the search results' do
          choices 'PlayStation', css: '#single', search: true, match: :first
          expect(get_value('#console')).to eql ['playstation 3']
        end

        it 'should select an option by exact text from the search results' do
          choices 'PlayStation', css: '#single', search: true, exact_text: true
          expect(get_value('#console')).to eql ['playstation']
        end

        it 'should select an option within the context of a parent element' do
          within '#single' do
            choices 'Wii', css: '.choices', search: true
          end
          expect(get_value('#console')).to eql ['wii']
        end
      end
    end

    context 'with a grouped select box' do

      it 'should select an option from the grouped select box' do
        choices 'Big Boom Wooh', css: '#grouped'
        expect(get_values('#movie')).to eql ['Big Boom Wooh']
      end

    end

    context 'with a multi select box' do

      it 'should select an option from a select found by an XPath selector' do
        choices 'Buy Milk', xpath: "//div[@id='multiple']"
        expect(get_values('#todo')).to eql ['buy milk']
      end

      it 'should select an option from a select found by a CSS selector' do
        choices 'Buy Milk', css: '#multiple'
        expect(get_values('#todo')).to eql ['buy milk']
      end

      it 'should select an option from a select found by a label' do
        choices 'Buy Milk', from: 'Things to do'
        expect(get_values('#todo')).to eql ['buy milk']
      end

      xit 'should select a new option from a select with already selected option' do
        choices 'Buy Milk', css: '#multiple', search: true
        choices 'See Malaysia', css: '#multiple', search: true

        expect(get_values('#todo')).to eql ['buy milk', 'see malaysia']
      end

      context 'searching for an option' do

        it 'should search by an option text if used with "{ search: true }"' do
          expect(CapybaraChoices::Helpers)
            .to receive(:choices_search).with('Buy Milk', any_args)

          choices 'Buy Milk', css: '#multiple', search: true
        end

        it 'should search by the passed string if used with "{ search: "a string" }"' do
          expect(CapybaraChoices::Helpers)
            .to receive(:choices_search).with('Buy', any_args)

          choices 'Buy Milk', css: '#multiple', search: 'Buy'
        end

      end
    end
  end
end
