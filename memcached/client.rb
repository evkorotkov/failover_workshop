require 'bundler/inline'
require 'yaml'

gemfile do
  source 'https://rubygems.org'

  gem 'dalli', '3.2.8'
end

def print_stats(client)
  client.stats.dup.map { |s, v| s.split('.').first + ':' + (v ? v['total_items'] : 'down') }.join(' | ')
end

begin
  config = YAML.load_file('memcached.yml', symbolize_names: true).fetch(:memcached)
  client = Dalli::Client.new(config.delete(:servers), **config)

  loop do
    id = rand(10)
    user_key = "user_#{id}"

    client.fetch(user_key) do
      puts "Cache miss for #{user_key}"
      sleep 0.1
      "User Name ##{id}"
    end

    puts "Fetched for #{user_key}. Stats: #{print_stats(client)}"

    sleep 1
  end
rescue Dalli::DalliError => e
  puts "Retrying after error: #{e.message}"
  sleep 1
  retry
end
