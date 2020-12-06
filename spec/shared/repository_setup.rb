# frozen_string_literal: true

RSpec.shared_context "gateway setup" do
  let(:root) { Pathname(__FILE__).dirname.join("../..") }
  let(:path) { root.join("spec/fixtures") }

  if RUBY_ENGINE == "jruby"
    let(:uri) { "jdbc:sqlite://#{root.join("db/test.sqlite")}" }
  else
    let(:uri) { "sqlite://#{root.join("db/test.sqlite")}" }
  end
end
