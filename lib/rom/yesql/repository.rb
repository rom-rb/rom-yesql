require 'sequel'

require 'rom/yesql/dataset'
require 'rom/yesql/relation'

module ROM
  module Yesql
    class Repository < ROM::Repository
      attr_reader :connection

      def initialize(uri, options = {})
        @connection = Sequel.connect(uri, options)

        path = options.fetch(:path)
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
        Relation.query_names(queries.map(&:first).map(&:to_sym))
      end

      def dataset(_name)
        @dataset ||= Dataset.new(connection)
      end

      def dataset?(_name)
        ! @dataset.nil?
      end

      def schema
        []
      end
    end
  end
end

