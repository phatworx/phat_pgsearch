module PhatPgsearch
  module ActiveRecord

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods #:nodoc:

      def pgsearch_index(*args, &block)
        unless @pgsearch_definitions.is_a? Hash
          include InstanceMethods
          extend SingletonMethods
          @pgsearch_definitions = {}
          before_save :build_pgsearch_index
        end
        @pgsearch_definitions[args.first.to_sym] = IndexDefinition.new(*args, &block)
      end

    end

    module SingletonMethods #:nodoc:

      def pgsearch_definitions
        @pgsearch_definitions
      end

      def pgsearch(*args)
        options = args.extract_options!
        normalization = options.delete(:normalization) || 32
        rank = options.delete(:rank)

        scope = self

        search_query = pgsearch_query(args.first, args.second, options)

        if rank.nil? or rank == true
          scope = scope.select("#{self.connection.quote_table_name(self.table_name)}.*, ts_rank_cd(#{self.connection.quote_column_name(args.first)}, #{search_query}, #{normalization.to_i}) AS rank")
        end

        scope.where("#{self.connection.quote_table_name(self.table_name)}.#{self.connection.quote_column_name(args.first)} @@ #{search_query}")
      end

      def pgsearch_query(*args)
        options = args.extract_options!
        raise ArgumentError, "invalid field given" unless pgsearch_definitions.include? args.first.to_sym
        raise ArgumentError, "invalid query" if not args.second or not args.second.is_a? String

        definition = pgsearch_definitions[args.first.to_sym]
        catalog = options[:catalog] || definition.catalog

        "plainto_tsquery(#{self.sanitize(catalog)}, #{self.sanitize(args.second)})"
      end

    end

    module InstanceMethods #:nodoc:

      def build_pgsearch_index
        self.class.pgsearch_definitions.each_pair do |index_field, index_definition|
          IndexBuilder.new(self, index_definition)
        end
      end

    end
  end
end