require 'spec_helper'

describe ROM::Yesql::Repository do
  include_context 'repository setup'

  it 'loads queries from file system when :path is provided' do
    repository = ROM::Yesql::Repository.new(uri, path: path)

    expect(repository.queries.keys).to match_array([:users, :tasks])
  end

  it 'combines queries from :queries option and loaded from provided :path' do
    queries = { reports: { true: 'SELECT 1' } }
    repository = ROM::Yesql::Repository.new(uri, path: path, queries: queries)

    expect(repository.queries.keys).to match_array([:users, :tasks, :reports])
  end

  it 'loads queries from :queries option' do
    queries = { reports: { true: 'SELECT 1' } }
    repository = ROM::Yesql::Repository.new(uri, queries: queries)

    expect(repository.queries).to eql(queries)
  end

  it 'loads empty queries hash when no options were provided' do
    repository = ROM::Yesql::Repository.new(uri)

    expect(repository.queries).to eql({})
  end

  it 'freezes queries' do
    queries = { reports: { true: 'SELECT 1' } }
    repository = ROM::Yesql::Repository.new(uri, queries: queries)

    expect(repository.queries).to be_frozen
  end
end
