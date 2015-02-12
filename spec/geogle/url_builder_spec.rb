describe Geogle::UrlBuilder do
  let(:uri)       { "https://www.foo.com" }
  let(:builder)   { described_class.new(uri, business_attrs)}
  let(:params) do
    {
      address: "Street FooBar",
      language: "de",
      sensor:  true
    }
  end
  let(:built_url) { builder.build(params) }

  describe "when the client_id and crypto_key are not passed as arguments" do
    let(:business_attrs) { {} }

    it "the built url doesn't contain a query param signature" do
      expect(built_url.to_s).to eq("https://www.foo.com?address=Street+FooBar&language=de&sensor=true")
    end
  end

  describe "when the client_id and crypto_key are passed as arguments" do
    let(:business_attrs) do
      {
        client_id:  "gme-clientid",
        crypto_key: "crypto-key"
      }
    end

    it "the built url contains a query param signature" do
      expect(built_url.to_s).to eq("https://www.foo.com?client=gme-clientid&address=Street+FooBar&language=de&sensor=true&signature=1klekRivPNXr3vOpOixX16LNGuI=")
    end
  end

  describe "when the optional channel is passed with client_id and crypto_key" do
    let(:business_attrs) do
      {
        client_id:  "gme-clientid",
        crypto_key: "crypto-key",
        channel: "channel"
      }
    end

    it "the built url contains a query param signature and the channel" do
      expect(built_url.to_s).to eq("https://www.foo.com?client=gme-clientid&channel=channel&address=Street+FooBar&language=de&sensor=true&signature=CDBE_pAvcrm33PdvQ9NHzh4in38=")
    end
  end

end
