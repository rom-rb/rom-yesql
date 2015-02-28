require 'rom/relation'

module ROM
  module Yesql
    class Relation < ROM::Relation
      defines :query_names

      def self.inherited(klass)
        super
        klass.exposed_relations.add(*query_names)
      end
    end
  end
end
