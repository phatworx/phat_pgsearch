require 'active_support/all'

module PhatPgsearch
  autoload :Index, 'phat_pgsearch/index'
  autoload :Postgresql, 'phat_pgsearch/postgresql'
  autoload :ActiveRecord, 'phat_pgsearch/active_record'

  # default catalog
  mattr_accessor :catalog
  @@catalog = :english

  class << self
    # default
    def setup
      yield self
    end
  end

end