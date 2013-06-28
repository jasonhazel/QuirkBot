module QuirkBot::Feature
  class Bop
    include QuirkBot::Feature

    attr_accessor :triggers, :responses

    def initialize(client, opt = {}, &block)
      options(opt)
      attach(client)
      register(&block)
    end

    def triggers(triggers)
      @triggers = triggers
    end

    def responses(responses)
      @responses = responses
    end

    def triggered?
      @triggers.include?(@message.content)
    end

    def respond
      say @responses.sample
    end

    private
      def options(opt = {})
        default = { 
          triggers: %w{bop dance bounce}, responses: ['Good Song!']
        }

        default.merge(opt).each do |key, value| 
          send("#{key.to_s}=", value)
        end
      end


      def register(&block)
        @client.on :user_spoke do |message|
          @message = message
          if triggered?
            bop
            respond
          end

          instance_eval(&block) if block_given?
        end 
      end
  end
end