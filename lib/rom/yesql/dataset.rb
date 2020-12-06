# frozen_string_literal: true

module ROM
  module Yesql
    # Yesql dataset simply uses a sequel connection to fetch results of a query
    #
    # @api private
    class Dataset
      # @return [Sequel::Database]
      #
      # @api private
      attr_reader :connection

      # @api private
      def initialize(connection)
        @connection = connection
      end

      # Fetch results of a query using sequel connection
      #
      # @return [Array<Hash>]
      #
      # @api private
      def read(query)
        connection.fetch(query)
      end
    end
  end
end
