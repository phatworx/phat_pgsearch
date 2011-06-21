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

        if args.first.is_a? Symbol or args.first.to_s.split('.', 2) == 1
          vector_column = "#{self.connection.quote_table_name(self.table_name)}.#{self.connection.quote_column_name(args.first.to_s)}"
        else
          vector_column = args.first.split('.', 2).collect{ |f| self.connection.quote_column_name(f) }.join('.')
        end

        if rank.nil? or rank == true
          scope = scope.select("#{self.connection.quote_table_name(self.table_name)}.*, ts_rank_cd(#{vector_column}, #{search_query}, #{normalization.to_i}) AS rank")
        end

        scope.where("#{vector_column} @@ #{search_query}")
      end

      def pgsearch_query(*args)
        options = args.extract_options!
        plain = options.delete(:plain) || true
        raise ArgumentError, "invalid field given" if args.first.nil? or not (args.first.is_a? String or args.first.is_a? Symbol)
        raise ArgumentError, "invalid query given" if args.second.nil? or not (args.second.is_a? String)

        field = args.first.to_s.split(".", 2)

        table_class = self

        if field.count == 2
          begin
            table_class = field.first.classify.constantize
          rescue
            raise ArgumentError, "unknown table in field given"
          end
        end

        raise ArgumentError, "table has no index defined" unless table_class.respond_to? :pgsearch_definitions
        raise ArgumentError, "table has no index defined for '#{field.last.to_sym}'" if table_class.pgsearch_definitions[field.last.to_sym].nil?


        definition = table_class.pgsearch_definitions[field.last.to_sym]
        if definition
          catalog = options[:catalog] || definition.catalog
        else
          catalog = options[:catalog] || definition.catalog
        end

        "#{plain ? 'plain' : ''}to_tsquery(#{self.sanitize(catalog)}, #{self.sanitize(args.second)})"
      end

      # rebuild complete index for model
      def rebuild_pgindex!
        self.all.each { |model| model.rebuild_pgindex! }
      end

    end

    module InstanceMethods #:nodoc:

      # rebuild pgindex für object without update timestamps
      def rebuild_pgindex!
        last_state = self.class.record_timestamps
        self.class.record_timestamps = false
        self.build_pgsearch_index
        self.save!
        self.class.record_timestamps = last_state
      end

      protected

      def build_pgsearch_index
        self.class.pgsearch_definitions.each_pair do |index_field, index_definition|
          IndexBuilder.new(self, index_definition)
        end
      end

    end
  end
end
