# frozen_string_literal: true

require "spec_helper"

RSpec.describe ROM::Yesql::Gateway do
  include_context "gateway setup"

  it "loads queries from file system when :path is provided" do
    gateway = ROM::Yesql::Gateway.new(uri, path: path)

    expect(gateway.queries.keys).to match_array([:users, :tasks])
  end

  it "combines queries from :queries option and loaded from provided :path" do
    queries = {reports: {true: "SELECT 1"}}
    gateway = ROM::Yesql::Gateway.new(uri, path: path, queries: queries)

    expect(gateway.queries.keys).to match_array([:users, :tasks, :reports])
  end

  it "loads queries from :queries option" do
    queries = {reports: {true: "SELECT 1"}}
    gateway = ROM::Yesql::Gateway.new(uri, queries: queries)

    expect(gateway.queries).to eql(queries)
  end

  it "loads empty queries hash when no options were provided" do
    gateway = ROM::Yesql::Gateway.new(uri)

    expect(gateway.queries).to eql({})
  end

  it "freezes queries" do
    queries = {reports: {true: "SELECT 1"}}
    gateway = ROM::Yesql::Gateway.new(uri, queries: queries)

    expect(gateway.queries).to be_frozen
  end
end
