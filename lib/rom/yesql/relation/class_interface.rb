module ROM
  module Yesql
    class Relation < ROM::Relation
      module ClassInterface
        # Set dataset name for the relation class
        #
        # The class will be extended with queries registered under that name.
        # By default dataset name is derived from the class name, which doesn't
        # have to match they key under which its queries were registered
        #
        # @return [Symbol]
        #
        # @api public
        def dataset(name = Undefined)
          return @dataset if name == Undefined
          @dataset = name
          define_query_methods(self, Relation.queries[name] || {})
          @dataset
        end
      end
    end
  end
end
