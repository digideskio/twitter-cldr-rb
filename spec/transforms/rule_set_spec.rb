# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'spec_helper'

include TwitterCldr::Transforms

describe RuleSet do
  test_data = YAML.load_file(
    File.join(File.dirname(__FILE__), 'test_data.yml')
  )

  # Use this to specify a list of transform tests to run.
  # Mostly available for debugging purposes.
  ids_to_test = if ENV.include?('TRANSFORM_IDS')
    ENV['TRANSFORM_IDS'].split(',')
  else
    test_data.map { |td| td[:id] }
  end

  test_data.each do |test|
    next unless ids_to_test.include?(test[:id])
    transformer = Transformer.get(test[:id])

    test[:samples].each_pair.with_index do |(source, target), idx|
      it "transforms sample ##{idx + 1} using #{test[:id]}" do
        result = transformer.transform(source)
        expect(result).to match_normalized(target)
      end
    end
  end

  it 'transforms using Armenian-Latin' do
    transformer = Transformer.get('Armenian-Latin')
    result = transformer.transform('հեռախոսներ')
    expect(result).to eq('herrakhosner')
  end

  it 'transforms to Armenian using the inverted Latin-Armenian rule set' do
    transformer = Transformer.get('Latin-Armenian').invert
    result = transformer.transform('հեռախոսներ')
    expect(result).to eq('heṙaxosner')
  end

  it 'transforms using Armenian-Latin/BGN' do
    transformer = Transformer.get('Armenian-Latin/BGN')
    result = transformer.transform('հեռախոսներ')
    expect(result).to eq('herrakhosner')
  end
end
