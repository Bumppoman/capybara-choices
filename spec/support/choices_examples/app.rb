require 'sinatra/base'

module ChoicesExamples
  class App < Sinatra::Base

    def self.boot
      instance = new
      Capybara::Server.new(instance).tap { |server| server.boot }
    end

    get '/choices/v:version/examples' do
      choices_version = params['version']
      ERB.new(File.read(File.join(__dir__, 'index.html.erb'))).result(binding)
    end

  end
end
