# -*- coding: utf-8 -*-
#
# This is a sample robot using some of the plugins in this
# repository, mainly intended for testing purposes. You may
# find it useful as a working usage example of some of the
# plugins.

# Require Cinch
require "cinch"

# Require our plugins
require_relative "plugins/history"
require_relative "plugins/help"
require_relative "plugins/memo"
require_relative "plugins/vote"
require_relative "plugins/quit"
require_relative "plugins/http_server"
require_relative "plugins/github_commits"
require_relative "plugins/link_info"



# Define the robot
cinch = Cinch::Bot.new do

  configure do |config|

    ########################################
    # Cinch options

    # Server stuff
    config.server     = "192.168.1.99"
    config.port       = 6667
    config.ssl.use    = false
    config.ssl.verify = false

    # User stuff
    config.channels = ["#kiwiraildev", "#dev"]
    config.nick     = "catch_bot"
    config.user     = "catch_bot"

    ########################################
    # Plugin options

    # Default prefix is the bot’s name
    config.plugins.prefix = lambda{|msg| Regexp.compile("^#{Regexp.escape(msg.bot.nick)}:?\s*")}



    config.plugins.options[Cinch::History] = {
      :max_messages => 100
    }

    config.plugins.options[Cinch::Help] = {
      :intro => "%s at your service. Commands starting with /msg are meant to be sent privately, <> indicate mandatory, [] optional parameters."
    }

    config.plugins.options[Cinch::Quit] = {
      :op => true
    }
    config.plugins.options[Cinch::HttpServer] = {
      :host => "0.0.0.0",
      :port => 1234
    }

    # List of plugins to load
    config.plugins.plugins = [Cinch::Help,Cinch::HttpServer ,Cinch::GithubCommits, Cinch::History, Cinch::Quit, Cinch::LinkInfo]
  end

  trap "SIGINT" do
    bot.log("Cought SIGINT, quitting...", :info)
    bot.quit
  end

  trap "SIGTERM" do
    bot.log("Cought SIGTERM, quitting...", :info)
    bot.quit
  end

  # Set up a logger so we have something more persistant
  # than $stderr. Note this sadly cannot be done in a
  # plugin, because plugins are loaded after a good number
  # of log messages have already been created.
  file = open("/tmp/cinch.log", "a")
  file.sync = true
  loggers.push(Cinch::Logger::FormattedLogger.new(file))

end

cinch.start
