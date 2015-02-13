shared_context 'database setup' do
  subject(:rom) { setup.finalize }

  let(:root) { Pathname(__FILE__).dirname.join('../..') }
  let(:path) { "#{root}/spec/fixtures" }

  if RUBY_ENGINE == 'jruby'
    let(:uri) { "jdbc:sqlite://#{root.join('db/test.sqlite')}" }
  else
    let(:uri) { "sqlite://#{root.join('db/test.sqlite')}" }
  end

  let(:conn) { Sequel.connect(uri) }
  let(:setup) { ROM.setup(:yesql, [uri, path: path]) }

  def drop_tables
    [:users].each { |name| conn.drop_table?(name) }
  end

  before do
    conn.loggers << LOGGER

    drop_tables

    conn.create_table :users do
      primary_key :id
      String :name, null: false
      index :name, unique: true
    end
  end
end
