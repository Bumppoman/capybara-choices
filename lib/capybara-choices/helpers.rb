require 'capybara-choices/utils'
require 'capybara-choices/selectors'

module CapybaraChoices
  module Helpers
    module_function

    def choices_open(options)
      options = Utils.set_option_aliases(options)
      Utils.validate_options!(options)

      _, container, version = Utils.get_page_container_and_version(options, self)
      opener_selector = Selectors.opener_selector(version)

      container.find(:css, opener_selector).click
    end

    def choices_close(options = {})
      page.find(:css, 'body').click
    end

    def choices_search(text, options)
      options = Utils.set_option_aliases(options)
      Utils.validate_options!(options)

      page, _, version = Utils.get_page_container_and_version(options, self)
      search_input_selector = Selectors.search_input_selector(version)

      page.find(:xpath, '//body').find(:css, search_input_selector).set text
    end

    def choices_select(value, options)
      Utils.validate_options!(options)

      page, _, version = Utils.get_page_container_and_version(options, self)
      option_selector = Selectors.option_selector(version)

      find_options = options.select { |k, _| [:match, :exact_text].include?(k) }
      find_options = find_options.merge(text: value)

      #raise page.find(:xpath, '//body').all(:css, option_selector, **find_options).inspect
      page.find(:xpath, '//body').all(:css, option_selector, **find_options).last.click
    end

    def choices_clear(options)
      options = Utils.set_option_aliases(options)
      Utils.validate_options!(options)

      _, container, version = Utils.get_page_container_and_version(options, self)
      remove_option_selector = Selectors.remove_option_selector(version)

      container.all(remove_option_selector).map(&:click)
    end

  end
end
