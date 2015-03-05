module PhatPgsearch
  module PostgreSQL
    class IndexDefinition < Struct.new(:table, :name, :type, :column) #:nodoc:
    end

    module SchemaDumper
      def self.included(base)

      end

      def indexes


      end
    end

    module SchemaStatements

      # deprecated
      # use: add_index :sample_headers, :tsv, using: :gin
      def add_gin_index(table_name, column_name, options = {})
        index_name = index_name(table_name, :column => column_name)
        index_name = options[:name].to_s if options.key?(:name)
        execute "CREATE INDEX #{quote_column_name(index_name)} ON #{quote_table_name(table_name)} USING gin(#{quote_column_name(column_name)})"
      end

      # deprecated
      # use: add_index :sample_headers, :tsv, using: :gist
      def add_gist_index(table_name, column_name, options = {})
        index_name = index_name(table_name, :column => column_name)
        index_name = options[:name].to_s if options.key?(:name)
        execute "CREATE INDEX #{quote_column_name(index_name)} ON #{quote_table_name(table_name)} USING gist(#{quote_column_name(column_name)})"
      end
    end

    module PostgreSQLColumn
      def pgsearch_index(table)

      end

      def simplified_type(field_type)
        if field_type == 'tsvector'
          :string
        else
          super(field_type)
        end
      end
    end

    module TableDefinition
      def self.included(base)
        # add data type
        ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:tsvector] = {:name => "tsvector"}
      end

      # add tsvector column
      def tsvector(*args)
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, :tsvector, options) }
      end
    end
  end
end