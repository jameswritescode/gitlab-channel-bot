require 'cinch'
require 'sqlite3'
require 'yaml'

config = YAML.load_file('bot.yml')

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = 'irc.freenode.net'
    c.channels = ['#gitlab']

    c.sasl.username = config['username']
    c.sasl.password = config['password']
  end
end

bot.start
