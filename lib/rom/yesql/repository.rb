require 'sequel'

require 'rom/yesql/dataset'
require 'rom/yesql/relation'

module ROM
  module Yesql
    class Repository < ROM::Repository
      include Options

      option :path, reader: true

      attr_reader :connection
      attr_reader :queries

      def initialize(uri, options = {})
        super
        @connection = Sequel.connect(uri, options)
        initialize_queries
        Relation.load_queries(queries)
      end

      def dataset(_name)
        @dataset ||= Dataset.new(connection)
      end

      def dataset?(_name)
        ! @dataset.nil?
      end

      private

      def initialize_queries
        @queries = Dir["#{path}/**/*.sql"].each_with_object({}) do |file, h|
          name = File.basename(file, '.*').to_sym
          sql = File.read(file)
          h[name] = sql.strip
        end
      end
    end
  end
end
