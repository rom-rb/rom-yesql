require "rom-sql"

module ROM
  module Yesql
    class Dataset
      attr_reader :connection

      def initialize(connection)
        @connection = connection
      end

      def read(query, opts = {})
        connection.fetch(query % opts)
      end
    end

    class Relation < ROM::Relation
    end

    class Repository < ROM::SQL::Repository
      attr_reader :path, :mod

      def initialize(uri, options = {})
        super
        @path = options.fetch(:path)

        mod = Module.new

        queries = Dir["#{path}/**/*.sql"].map do |file|
          name = File.basename(file, '.*')
          sql = File.read(file)
          [name, sql.strip]
        end

        queries.each do |name, query|
          mod.module_exec do
            define_method(name) { |opts| dataset.read(query, opts) }
          end
        end

        Relation.send(:include, mod)
      end

      def dataset(_name)
        Dataset.new(connection)
      end

      def dataset?(name)
        true
      end

      def schema
        []
      end
    end
  end
end

require "rom/yesql/version"

ROM.register_adapter(:yesql, ROM::Yesql)
