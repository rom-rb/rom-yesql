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

      def to_a
        read.to_a
      end
    end
  end
end
