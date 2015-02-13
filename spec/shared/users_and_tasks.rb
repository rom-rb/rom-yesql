shared_context 'users' do
  include_context 'database setup'

  before do
    conn[:users].insert id: 1, name: 'Jane'
    conn[:users].insert id: 2, name: 'Joe'
    conn[:users].insert id: 3, name: 'Jade'
  end
end
