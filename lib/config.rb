module Config
  def self.[](key)
    unless @config
      @config = YAML.load_file("./config.yml")
    end
    @config[key]
  end

  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
end