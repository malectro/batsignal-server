require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class TwitterReverse < OmniAuth::Strategies::Twitter
      option :name, 'twitter_reverse'

      def callback_phase
        if request['oauth_token'] and request['oauth_token_secret']
          @access_token = ::OAuth::AccessToken.from_hash(consumer, Hashie::Mash.new(request.params))
          meth = OmniAuth::Strategy.instance_method(:callback_phase)
          meth.bind(self).call
        else
          super
        end
      end
    end
  end
end

