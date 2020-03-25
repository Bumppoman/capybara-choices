module CapybaraChoices
  module Utils

    def self.set_option_aliases(options)
      options.dup.tap { |o| o[:from] ||= o[:label] }
    end

    def self.detect_choices_version(container)
      '9'
    end

    def self.validate_options!(options)
      unless options.is_a?(Hash) && [:css, :xpath, :from].any? { |k| options.key?(k) }
        fail ArgumentError.new("Please specify :css, :xpath or :from in options")
      end
    end

    def self.find_choices_container(options, page)
      container = if options[:xpath]
        page.find(:xpath, options[:xpath])
      elsif options[:css]
        page.find(:css, options[:css])
      else
        page.find(:css, 'label', text: options[:from])
          .find(:xpath, '..')
          .find(:css, '.choices')
      end

      container
    end

    def self.get_page_container_and_version(options, context)
      page = options[:page] || context.page
      container = options[:container] || find_choices_container(options, page)
      version = options[:version] || detect_choices_version(container)

      [page, container, version]
    end

  end
end
