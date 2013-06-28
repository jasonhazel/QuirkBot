module QuirkBot::Feature
  class Dj
    include QuirkBot::Feature

    attr_accessor :min_djs

    def initialize(client, opt = {}, &block)
      options(opt)
      attach(client)
      register
    end

    private
      def options(opt = {})
        default = { 
          min_djs: 2
        }

        default.merge(opt).each do |key, value| 
          send("#{key.to_s}=", value)
        end
      end

      def playing?
        current_song.played_by == user
      end

      def played?(song)
        song.played_by == user
      end

      def solo?
        room.djs.count == 1 && currently?
      end

      def currently?
        user.dj?
      end

      def needed?
        room.djs.count <= @min_djs || solo?
      end

      def update
        needed? ? become_dj : remove_dj
      end

      def register
        update 
        
        [:dj_added, :dj_removed].each do |event|
          client.on event do |dj|
            update if dj != user
          end
        end

        client.on :song_ended do |song|
          if solo? && played?(song)
            remove_dj
            become_dj
          end
        end
      end
  end
end