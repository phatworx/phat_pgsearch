module PhatPgsearch
  module ActiveRecord

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods #:nodoc:

      def pgsearch_index(*args, &block)
        unless @pgsearch_definitions.is_a? Array
          include InstanceMethods
          extend SingletonMethods
          @pgsearch_definitions = []
          before_save :build_pgsearch_index
        end
        @pgsearch_definitions << IndexDefinition.new(*args, &block)
      end

    end

    module SingletonMethods #:nodoc:

      def pgsearch_definitions
        @pgsearch_definitions
      end

    end

    module InstanceMethods #:nodoc:

      def build_pgsearch_index
        self.class.pgsearch_definitions.each do |index_definition|
          IndexBuilder.new(self, index_definition)
        end
      end

    end
  end
end