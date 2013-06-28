require 'turntabler'
require_relative 'lib/quirkbot'

EMAIL     = 'email@example.com'
PASSWORD  = 'password'
ROOM      = 'room_id'

Turntabler.run do
  QuirkBot::Bot.new(EMAIL, PASSWORD, ROOM) do
    feature :bop
    feature :dj
  end
end