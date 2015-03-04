#!/usr/bin/env ruby

require 'cinch'
require 'sinatra'
require 'sqlite3'
require 'terminal-table'
require 'yaml'
require 'pry'

$config   = YAML.load_file('gitlab.yml')
$database = SQLite3::Database.new($config['db'])

Dir['plugins/*.rb'].each { |file| require_relative file }

$bot = Cinch::Bot.new do
  configure do |config|
    config.nick     = $config['username']
    config.realname = '#gitlab helper bot'
    config.server   = 'irc.freenode.net'
    config.channels = $config['channels']

    config.plugins.plugins = [Factoid]

    config.sasl.username = $config['username']
    config.sasl.password = $config['password']
  end
end

# Thread.new { $bot.start }

Thread.new do
  set :port, $config['sinatra_port']

  get '/' do
    headers 'Content-Type' => 'text/plain'

    facts = $database.execute('SELECT word, fact FROM factoids')

    Terminal::Table.new(headings: ['Word', 'Fact'], rows: facts).to_s
  end
end
