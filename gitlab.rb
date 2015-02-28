#!/usr/bin/env ruby

require 'cinch'
require 'sqlite3'
require 'yaml'
require 'pry'

$config   = YAML.load_file('gitlab.yml')
$database = SQLite3::Database.new($config['db'])

Dir['plugins/*.rb'].each { |file| require_relative file }

Cinch::Bot.new do
  configure do |config|
    config.nick     = $config['username']
    config.realname = '#gitlab helper bot'
    config.server   = 'irc.freenode.net'
    config.channels = $config['channels']

    config.plugins.plugins = [Factoid]

    config.sasl.username = $config['username']
    config.sasl.password = $config['password']
  end
end.start
