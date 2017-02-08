RSpec.shared_context 'database setup' do
  include_context 'gateway setup'

  let!(:conn) { Sequel.connect(uri) }

  def drop_tables
    [:users, :tasks].each { |name| conn.drop_table?(name) }
  end

  before do
    conn.loggers << LOGGER

    drop_tables

    conn.create_table :users do
      primary_key :id
      String :name, null: false
      index :name, unique: true
    end

    conn.create_table :tasks do
      primary_key :id
      String :title, null: false
      index :title, unique: true
    end
  end
end
