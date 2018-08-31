require "spec_helper"

describe "GET /.well-known/stellar", type: :request do
  it "exposes the stellar.toml" do
    get "/.well-known/stellar"

    expect(response.headers["Access-Control-Allow-Origin"]).to eq "*"

    toml_hash = TomlRB.parse(response.body)

    expect(toml_hash["TRANSFER_SERVER"]).to eq "http://example.com/stellar"
  end
end
