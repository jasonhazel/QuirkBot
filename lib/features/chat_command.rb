module QuirkBot::Feature
  class ChatCommand
    include QuirkBot::Feature

    attr_accessor :triggers, :responses

    def initialize(client, opt = {}, &block)
      options(opt)
      attach(client)
      register(&block) if block_given?
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
          triggers: [], responses: []
        }

        default.merge(opt).each do |key, value| 
          send("#{key.to_s}=", value)
        end
      end


      def register(&block)
        @client.on :user_spoke do |message|
          @message = message
          instance_eval(&block)
        end 
      end
  end
end