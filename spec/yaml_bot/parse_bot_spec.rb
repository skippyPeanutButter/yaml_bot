require 'spec_helper'
require 'yaml_bot/parse_bot'

describe YamlBot::ParseBot do
  describe '::get_object_value' do
    before :each do
      yaml_file = '/../fixtures/get_obj_val_test.yml'
      @yaml = YAML.load_file(File.dirname(File.realpath(__FILE__)) + yaml_file)
    end

    context 'Successfully retrieve value from Hash' do
      it 'returns a value from a Hash when passed a valid address' do
        {
          'language' => 'go',
          'jdk' => 'oraclejdk7',
          'jenkins.sudo' => true,
          'jenkins.collect.artifacts' => ["**/App/build/**/*.apk"],
          'jenkins.secrets' => [{"key" => "VAR_NAME", "pass" => "password" }]
        }.each do |key_address, expected_value|
          expect(YamlBot::ParseBot.get_object_value(@yaml, key_address)).to eq(expected_value)
        end
      end
    end

    context 'Non-existent YAML address is passed' do
      it 'returns nil when it cannot locate a particular key address' do
        ['jenkins.sup', 'key1', 'min.max.avg', 'herp'].each do |fake_key_addr|
          expect(YamlBot::ParseBot.get_object_value(@yaml, fake_key_addr)).to be_nil
        end
      end
    end

    after :each do
      @yaml = nil
    end
  end
end
