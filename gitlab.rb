#!/usr/bin/env ruby

require 'cinch'
require 'sqlite3'
require 'yaml'

config = YAML.load_file('gitlab.yml')

bot = Cinch::Bot.new do
  configure do |c|
    c.nick     = config['username']
    c.realname = '#gitlab helper bot'
    c.server   = 'irc.freenode.net'
    c.channels = ['#gitlab']

    c.sasl.username = config['username']
    c.sasl.password = config['password']
  end
end

bot.start
