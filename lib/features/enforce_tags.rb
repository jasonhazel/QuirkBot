module QuirkBot::Feature
  class EnforceTags
    include QuirkBot::Feature

    attr_accessor :artist, :title

    def initialize(client, opt = {}, &block)
      options(opt)
      attach(client)
      register(&block)
    end

    def enforce
      if !artist? && !title?
        @song.played_by.remove_as_dj 
        say "Sorry, @#{@song.played_by.name}, but we prefer proper tags."
      end
    end

    def artist?
      !@song.artist =~ /unknown/i && @artist
    end

    def title?
      !@song.title =~ /untitled/i && @artist
    end

    private
      def options(opt = {})
        default = { 
          artist: true, title: true
        }

        default.merge(opt).each do |key, value| 
          send("#{key.to_s}=", value)
        end
      end


      def register(&block)
        @client.on :song_started do |song|
          @song = song
          enforce
          instance_eval(&block) if block_given?
        end 
      end
  end
end