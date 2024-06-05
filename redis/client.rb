require 'bundler/inline'
require 'yaml'

gemfile do
  source 'https://rubygems.org'

  gem 'redis', '5.2.0'
end

begin
  config = YAML.load_file('redis.yml', symbolize_names: true).fetch(:redis)
  client = Redis.new(config)

  loop do
    name = "User Name #{rand(100_000)}"
    client.lpush('users', name)
    puts "Pushed #{name}, host: #{client.id}"
    sleep 1
  end

rescue StandardError => e
  puts "Retrying after error: #{e.message}"
  sleep 1
  retry
end
