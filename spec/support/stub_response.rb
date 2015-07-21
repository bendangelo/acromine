module HTTParty
  module StubResponse
    def stub_http_response_with(filename)
      format = filename.split('.').last.intern
      data = file_fixture(filename)

      response = Net::HTTPOK.new('1.1', 200, 'Content for you')
      allow(response).to receive(:body).and_return(data)

      http_request = HTTParty::Request.new(
        Net::HTTP::Get, 'http://localhost', format: format
      )
      allow(http_request).to receive_message_chain(:http, :request)
        .and_return(response)

      expect(HTTParty::Request).to receive(:new).and_return(http_request)
    end
  end
end
