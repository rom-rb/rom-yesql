require 'rom/relation'

module ROM
  module Yesql
    class Relation < ROM::Relation
      defines :query_names

      def self.inherited(klass)
        super
        klass.exposed_relations.add(*query_names)
      end

      def self.load_queries(queries)
        mod = Module.new do
          queries.each do |name, query|
            module_exec do
              define_method(name) { |opts| dataset.read(query, opts) }
            end
          end
        end

        include(mod)

        query_names(queries.keys)
      end
    end
  end
end
