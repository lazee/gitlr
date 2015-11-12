module Gitlr

  class << self
    attr_writer :configuration
  end


  def self.configuration
    @configuration ||= Configuration.new
  end


  def self.reset
    @configuration = Configuration.new
  end


  def self.configure
    yield(configuration)
  end


  class Configuration
    attr_accessor :organization, :debug, :show_header

    def initialize
      @default_organization = nil
      @debug = false
      @show_header = true
    end

    def load
      # Probably needs some more work to work on Windows?
      config_path = Dir.home + '/.config/gitlr/config.yaml'
      if File.exist?(config_path)
        data = YAML.load_file(config_path)
        @organization = data['organization'] unless data['organization'].nil?
      end
    end

  end

end
