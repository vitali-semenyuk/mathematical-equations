require 'server'

RSpec.describe 'Server' do
  def app
    Sinatra::Application
  end

  describe 'root url' do
    it 'redirects to current API url' do
      get '/'

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/api/v1'
    end
  end

  describe 'API index url' do
    it 'redirects to current API url' do
      get '/api'

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/api/v1'
    end
  end

  describe 'API v1 url' do
    expected_json_content = %w[
      api
      linear
      quadratic
      url
      description
      methods
      parameters
    ]

    context 'with GET request' do
      it 'display all requests acceptable by API server' do
        get '/api/v1'

        expect(last_response).to be_ok
        expected_json_content.each do |word|
          expect(last_response.body).to include word
        end
      end
    end

    context 'with OPTIONS request' do
      it 'display all requests acceptable by API server' do
        options '/api/v1'

        expect(last_response).to be_ok
        expected_json_content.each do |word|
          expect(last_response.body).to include word
        end
      end
    end
  end

  describe 'linear equations' do
    describe 'OPTIONS request' do
      it 'should return API instructions' do
        options '/api/v1/linear'

        expect(last_response).to be_ok
        %w[
          GET
          POST
          parameters
          description
          required
          type
          coefficient_a
          coefficient_b
        ].each do |word|
          expect(last_response.body).to include word
        end
      end
    end

    describe 'GET request' do
      context 'with valid data' do
        it 'should return JSON with equation solution' do
          get '/api/v1/linear', coefficient_a: 1, coefficient_b: 5

          expect(last_response).to be_ok
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          %w[input solution].each do |property|
            expect(result).to include property
          end
        end
      end

      context 'with missing url parameter(s)' do
        it 'shoult return JSON with error details' do
          get '/api/v1/linear', coefficient_a: 1

          expect(last_response.status).to eq 400
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with invalid url parameter(s)' do
        it 'shoult return JSON with error details' do
          get '/api/v1/linear', coefficient_a: 1, coefficient_b: 'wrong'

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with zero A coefficient' do
        it 'shoult return JSON with error details' do
          get '/api/v1/linear', coefficient_a: 0, coefficient_b: 5

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end
    end

    describe 'POST request' do
      context 'with valid data' do
        it 'should return JSON with equation solution' do
          post_json '/api/v1/linear', coefficient_a: 1, coefficient_b: 5

          expect(last_response).to be_ok
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          %w[input solution].each do |property|
            expect(result).to include property
          end
        end
      end

      context 'with missing JSON field(s)' do
        it 'shoult return JSON with error details' do
          post_json '/api/v1/linear', coefficient_a: 1

          expect(last_response.status).to eq 400
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with invalid JSON field(s)' do
        it 'shoult return JSON with error details' do
          post_json '/api/v1/linear', coefficient_a: 1, coefficient_b: 'wrong'

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with zero A coefficient' do
        it 'shoult return JSON with error details' do
          post_json '/api/v1/linear', coefficient_a: 0, coefficient_b: 5

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end
    end
  end

  describe 'quadratic equations' do
    describe 'OPTIONS request' do
      it 'should return API instructions' do
        options '/api/v1/quadratic'

        expect(last_response).to be_ok
        %w[
          GET
          POST
          parameters
          description
          required
          type
          coefficient_a
          coefficient_b
          coefficient_c
        ].each do |word|
          expect(last_response.body).to include word
        end
      end
    end

    describe 'GET request' do
      context 'with valid data' do
        it 'should return JSON with equation solution' do
          get '/api/v1/quadratic',
              coefficient_a: 1,
              coefficient_b: 5,
              coefficient_c: -25

          expect(last_response).to be_ok
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          %w[input solution].each do |property|
            expect(result).to include property
          end
        end
      end

      context 'with missing url parameter(s)' do
        it 'shoult return JSON with error details' do
          get '/api/v1/quadratic', coefficient_a: 1, coefficient_b: -5

          expect(last_response.status).to eq 400
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with invalid url parameter(s)' do
        it 'shoult return JSON with error details' do
          get '/api/v1/quadratic',
              coefficient_a: 1,
              coefficient_b: 'wrong',
              coefficient_c: 0

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with zero A coefficient' do
        it 'shoult return JSON with error details' do
          get '/api/v1/quadratic',
              coefficient_a: 0,
              coefficient_b: 5,
              coefficient_c: 1

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end
    end

    describe 'POST request' do
      context 'with valid data' do
        it 'should return JSON with equation solution' do
          post_json '/api/v1/quadratic',
                    coefficient_a: 1,
                    coefficient_b: 5,
                    coefficient_c: -20

          expect(last_response).to be_ok
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          %w[input solution].each do |property|
            expect(result).to include property
          end
        end
      end

      context 'with missing JSON field(s)' do
        it 'shoult return JSON with error details' do
          post_json '/api/v1/quadratic', coefficient_a: 1

          expect(last_response.status).to eq 400
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with invalid JSON field(s)' do
        it 'shoult return JSON with error details' do
          post_json '/api/v1/quadratic',
                    coefficient_a: 1,
                    coefficient_b: -5,
                    coefficient_c: 'wrong'

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end

      context 'with zero A coefficient' do
        it 'shoult return JSON with error details' do
          post_json '/api/v1/quadratic',
                    coefficient_a: 0,
                    coefficient_b: 5,
                    coefficient_c: 5

          expect(last_response.status).to eq 422
          expect { JSON.parse(last_response.body) }.not_to raise_error
          result = JSON.parse(last_response.body)
          expect(result).to include 'errors'
        end
      end
    end
  end

  describe 'invalid url' do
    it 'should return JSON with error message' do
      get '/unexisting/url'

      expect(last_response.status).to eq 404
      expect { JSON.parse(last_response.body) }.not_to raise_error
      result = JSON.parse(last_response.body)
      expect(result).to include 'errors'
    end
  end
end
