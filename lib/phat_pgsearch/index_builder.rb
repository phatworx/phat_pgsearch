# encoding: utf-8
module PhatPgsearch
  class IndexBuilder
    attr_reader :base, :definition, :build, :connection
    def initialize(base, definition)
      @base = base
      @definition = definition
      @connection = base.class.connection
      build_index
    end

    protected

    def build_index
      p definition.index_field
      partials = []
      definition.fields.each do |field_definition|
        field = field_definition.first
        field_options = field_definition.extract_options!
        field_content = base.respond_to?(field) ? base.send(field.to_s) : ''
        if not field_options[:weight].nil? and [:a, :b, :c, :d].include? field_options[:weight].to_sym
          partial = "setweight(to_tsvector(#{base.class.sanitize(definition.catalog)}, #{base.class.sanitize(field_content)}), '#{field_options[:weight].to_s.upcase}')"
        else
          partial = "to_tsvector(#{base.class.sanitize(definition.catalog)}, #{base.class.sanitize(field_content)})"
        end
        partials << partial
      end
      base.send("#{definition.index_field}=", base.class.connection.select_value("SELECT #{partials.join(' || ')}"))
    end
  end
end