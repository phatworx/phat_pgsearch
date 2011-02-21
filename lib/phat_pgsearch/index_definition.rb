module PhatPgsearch
  class IndexDefinition
    attr_reader :options, :fields, :index_field
    def initialize(*args, &block)
      @options = args.extract_options!
      @index_field = args.first
      @fields = []
      instance_eval(&block)
    end

    def field(*args)
      @fields << args
    end

    def catalog
      options[:catalog] || PhatPgsearch.catalog
    end
  end
end