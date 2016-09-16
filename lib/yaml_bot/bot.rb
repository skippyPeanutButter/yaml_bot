module YamlBot
  class Bot
    def initialize(yaml_file, rules)
      @yaml_file  = yaml_file
      @rules      = rules
    end

    def scan
      unless File.exists? @yaml_file
        raise Exception.new("File #{@yaml_file} does not exist")
      else
        yaml_file = YAML.load(File.open(@yaml_file))
      end
    end
  end
end
