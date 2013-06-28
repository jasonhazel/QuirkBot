require 'active_support/core_ext/string'

module QuirkBot
  module Feature
    attr_reader :room, :user, :client

    def say(message)
      room.say message
    end

    def song
      room.current_song
    end

    def bop
      song.vote :up unless song.played_by == user
    end

    def become_dj
      room.become_dj
    end

    def remove_dj(dj = nil)
      user.remove_as_dj if user.dj? && dj.nil?
      dj.remove_as_dj unless dj.nil?
    end

    def attach(client)
      @client = client
      @room   = client.room
      @user   = client.user
    end

    class << self
      def load(client, name, options = {}, &block)
        require_relative "features/#{name.to_s}"

        klass = name.to_s.camelcase
        klass = "QuirkBot::Feature::#{klass}"
        klass.constantize.new(client, options, &block)
      end
    end
  end

  class Bot
    attr_accessor :client

    def initialize(email, password, room, &block)
      @client = Turntabler::Client.new(
                                        email,
                                        password,
                                        room: room,
                                        reconnect_wait: 30
                                      )
      instance_eval(&block) if block_given?
    end

    def feature(name, options = {}, &block)
      Feature.load(@client, name, options, &block)
    end
  end
end