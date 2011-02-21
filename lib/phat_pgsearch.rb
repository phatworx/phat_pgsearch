require 'active_support/all'
require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'
module PhatPgsearch
  autoload :IndexDefinition, 'phat_pgsearch/index_definition'
  autoload :IndexBuilder, 'phat_pgsearch/index_builder'
  autoload :ActiveRecord, 'phat_pgsearch/active_record'
  autoload :PostgreSQL, 'phat_pgsearch/postgresql'

  # default catalog
  mattr_accessor :catalog
  @@catalog = :english

  class << self
    # default
    def setup
      yield self
    end

    def init
      ::ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, PostgreSQL::TableDefinition)
      ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, PostgreSQL::SchemaStatements)
      ::ActiveRecord::ConnectionAdapters::PostgreSQLColumn.send(:include, PostgreSQL::PostgreSQLColumn)
      ::ActiveRecord::Base.send(:include, ActiveRecord)
    end
  end

end

PhatPgsearch.init