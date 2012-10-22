#!/usr/bin/env ruby
#

require 'rubygems'
require 'json'
require 'httparty'
require 'irckitten'
require 'sanitize'

url = 'https://status.github.com/status.json'
statefile = '/tmp/.githubstate'

state = {}
previousstate = {}

status = JSON.parse HTTParty.get url

# get the previous state!
if File.exists?( statefile )
  previousstate = JSON.parse(IO.read(statefile))
end

state["status"] = status["status"]
state["message"] = status["days"].first["message"].split("\n").first
state["date"] = status["days"].first["date"]

# Do we need to bother?
exit if previousstate == state

body = Sanitize.clean status["days"].first["message"].split("\n").first.strip

staytuss = nil

# There's a transition state that's kind of annoying where it's
# minorproblem and all systems good. Let's hardcode around that.
if state["status"] != 'minorproblem' && body != 'All systems operational'
  if state["status"] == "good"
    staytuss = "IT LIVES, Teh hubs is up! #{body}"
  else
    staytuss = "Teh hubs is dead! It's a #{status["status"]}™: #{body}"
  end
end

IrcKitten::msg staytuss

File.open(statefile,'w'){ |f| JSON.dump(state, f) }

