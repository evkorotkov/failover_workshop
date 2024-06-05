require 'bundler/inline'
require 'yaml'

gemfile do
  source 'https://rubygems.org'

  gem 'trilogy'
end

begin
  config = YAML.load_file('mysql.yml', symbolize_names: true).fetch(:mysql)
  client = Trilogy.new(config)

  client.select_db('test')

  loop do
    name = "User Name #{rand(100_000)}"
    client.query("INSERT INTO users (name) VALUES ('#{name}')")
    puts "Inserted #{name}, host: #{client.connected_host}"
    sleep 1
  end
rescue StandardError => e
  puts "Retrying after error: #{e.message}"
  sleep 2
  retry
end
