# These are some RSpec tests to get you started and give a clear idea how we
# will test this on our end. Please feel free to add any tests you want here.
require 'rails_helper'

RSpec.describe '/scores requests', type: :request do
  let(:request_headers) { {
    'Accepts': 'application/json',
    'Content-Type': 'application/json',
  } }
  let(:request_body) do
    {}.to_json
  end
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    post '/scores', params: request_body, headers: request_headers
  end

  describe 'POST /scores' do
    # A perfect game of bowling is 300 points
    context 'happy path - a perfect game' do
      let(:request_body) do
        {
          'Nikola Tesla': [
            [10],
            [10],
            [10],
            [10],
            [10],
            [10],
            [10],
            [10],
            [10],
            [10, 10, 10],
          ],
        }.to_json
      end

      it 'responds with 200 status' do
        expect(response.status).to be 200
      end

      it 'chooses the correct winner' do
        expect(parsed_response['winner']).to eq 'Nikola Tesla'
      end

      it 'scores the game correctly' do
        expect(parsed_response['scores']['Nikola Tesla']).to eq 300
      end
    end

    # For a complete game, the output should be the final score.
    context 'a complete game' do
      let(:request_body) do
        {
          'Frank Zappa': [
            [3, 5],
            [0, 10],
            [1, 9],
            [5, 4],
            [10],
            [2, 0],
            [10],
            [10],
            [7, 2],
            [7, 1],
          ],
          'Don Van Vliet': [
            [10],
            [10],
            [10],
            [0, 0],
            [0, 0],
            [1, 1],
            [4, 5],
            [2, 7],
            [9, 1],
            [10, 4, 3],
          ],
        }.to_json
      end

      it 'responds with 200 status' do
        expect(response.status).to be 200
      end

      it 'chooses the correct winner' do
        expect(parsed_response['winner']).to eq 'Frank Zappa'
      end

      it 'scores the game correctly' do
        expect(parsed_response['scores']['Frank Zappa']).to eq 120
        expect(parsed_response['scores']['Don Van Vliet']).to eq 117
      end
    end

    # For an incomplete game, it should score the game so far and output the
    # scores as they currently stand. The output key `winner` should be whoever
    # is currently ahead in the score.
    context 'an incomplete game' do
      let(:request_body) do
        {
          'Tom Rowlands': [
            [3, 5],
            [0, 10],
            [1, 9],
            [5, 4],
          ],
          'Ed Simons': [
            [10],
            [10],
            [10],
            [0, 0],
          ],
        }.to_json
      end

      it 'responds with 200 status' do
        expect(response.status).to be 200
      end

      it 'chooses the correct winner' do
        expect(parsed_response['winner']).to eq 'Ed Simons'
      end

      it 'scores the game correctly' do
        expect(parsed_response['scores']['Tom Rowlands']).to eq 43
        expect(parsed_response['scores']['Ed Simons']).to eq 60
      end
    end

    # context 'a malformatted game' do
    #   let(:request_body) do
    #     {
    #       'Duane Allman': [
    #         { '3': 5},
    #         { '17': 9},
    #       ],
    #     }.to_json
    #   end

    #   it 'responds with 400 status' do
    #     expect(response.status).to be 400
    #   end
    # end

    context 'an unprocessable game - case 1' do
      let(:request_body) do
        {
          'Herbie Hancock': [
            [10],
            [3, 7],
            [3, 9], # More than 10 pins total
          ],
        }.to_json
      end

      it 'responds with 422 status' do
        expect(response.status).to be 422
      end
    end

    context 'an unprocessable game - case 2' do
      let(:request_body) do
        {
          'Gordon Mumma': [
            [10],
            [3, 7],
            [3, 2, 1, 0, 1], # Too many throws in the same frame
          ],
        }.to_json
      end

      it 'responds with 422 status' do
        expect(response.status).to be 422
      end
    end

    context 'an unprocessable game - non array data' do
      let(:request_body) do
        {
          'Gordon Mumma': [
            [10],
            [3, 7],
            3, # non array data
          ],
        }.to_json
      end

      it 'responds with 422 status' do
        expect(response.status).to be 422
      end
    end

    context 'an unprocessable game - different number of frames' do
      let(:request_body) do
        {
          'Tom Rowlands': [
            [3, 5],
            [0, 10],
            [1, 9],
            [5, 4],
          ],
          'Ed Simons': [
            [10],
            [10],
            [10],
          ],
        }.to_json
      end

      it 'responds with 422 status' do
        expect(response.status).to be 422
      end
    end
  end
end
