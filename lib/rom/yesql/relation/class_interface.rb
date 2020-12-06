# frozen_string_literal: true

module ROM
  module Yesql
    class Relation < ROM::Relation
      module ClassInterface
        # Sets dataset name for the relation class
        #
        # The class will be extended with queries registered under that name.
        # By default dataset name is derived from the class name, which doesn't
        # have to match the key under which its queries were registered
        #
        # @param name [String]
        #
        # @return [Symbol]
        #
        # @api public
        def dataset(name = Undefined)
          name = relation_name.to_sym if name == Undefined
          define_query_methods(self, Relation.queries[name] || {})
          ->(*) { self }
        end
      end
    end
  end
end
