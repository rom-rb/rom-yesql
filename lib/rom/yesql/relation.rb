require 'rom/relation'

module ROM
  module Yesql
    class Relation < ROM::Relation
      defines :query_proc

      option :query_proc, reader: true, default: proc { |r| r.class.query_proc }

      def self.queries
        @queries || {}
      end

      def self.inherited(klass)
        super
        Relation.queries[klass.dataset].each do |name, query|
          klass.class_eval do
            define_method(name) do |*args|
              dataset.read(query_proc.call(query, *args))
            end
          end
        end
      end

      def self.load_queries(queries)
        @queries = {}
        queries.each do |ds, ds_queries|
          @queries[ds] = ds_queries.each_with_object({}) do |(name, query), h|
            h[name] = query
          end
        end
        @queries
      end
    end
  end
end
