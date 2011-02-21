module PhatPgsearch
  module ActiveRecord

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods #:nodoc:
      def phat_pgsearch
        include InstanceMethods
        extend SingletonMethods
      end
    end

    module SingletonMethods #:nodoc:
      # search method
      def pgsearch(*args)
        
      end

      # pgindex :tsv, :catalog => :german do
      #   field :test1
      #   field :test2, :weight => :a
      # end
      def pgindex(*args, &block)
        index = PhatPgsearch::Index.new
        yield(index)
        p index.inspect
      end
    end

    module InstanceMethods #:nodoc:

    end
  end
end