module CapybaraChoices
  module Selectors

    module_function

    OpenerSelectors = {
      '9' => '.choices__inner'
    }.freeze

    def opener_selector(choices_version)
      OpenerSelectors.fetch(choices_version)
    end

    SearchInputSelectors = {
      '9' => '.choices__list.is-active input.choices__input'
    }.freeze

    def search_input_selector(choices_version)
      SearchInputSelectors.fetch(choices_version)
    end

    OptionSelectors = {
      '9' => '.choices__list .choices__item'
    }.freeze

    def option_selector(choices_version)
      OptionSelectors.fetch(choices_version)
    end

    RemoveOptionSelectors = {
      '9' => '.choices__button'
    }.freeze

    def remove_option_selector(choices_version)
      RemoveOptionSelectors.fetch(choices_version)
    end

  end
end
