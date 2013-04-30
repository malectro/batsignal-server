module Mongoid
  module Realization

    class << self
      def included(base)
        base.class_eval do |base|
          extend ClassMethods
        end
      end
    end

    module ClassMethods
      def realize(id)
        begin
          self.find(id)
        rescue
          object = self.new
          object.id = id
          object
        end
      end
    end

  end
end

