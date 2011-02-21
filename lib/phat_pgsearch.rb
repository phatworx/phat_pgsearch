require 'active_support/all'
require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'
module PhatPgsearch
  autoload :Index, 'phat_pgsearch/index'
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
      ::ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, PostgreSQL::SchemaStatements)
    end
  end

end

PhatPgsearch.init