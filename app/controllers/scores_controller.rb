class ScoresController < ApplicationController
  def create
    data = json_payload
    puts "data #{data}"
    return render json: { error: 'Wrong data format.' }, status: :bad_request if data == []
    scores = {}
    winner = ''
    num_frames = 0 # Variable created to check different number of frames
    data.each_pair do |key, value|
      scores[key] = 0 # Initalize the player score with zero points 
      num_frames = value.size if num_frames == 0 # Initialize the number of frames with the number of frames of the first player
      return render json: { error: 'More than ten frames.' }, status: :unprocessable_entity if value.size > 10
      return render json: { error: 'Different number of frames.' }, status: :unprocessable_entity if value.size != num_frames
      extra_points = Array.new(21, 1) # Array use to calculate the points. Weight for each throw. Add one to strikes and spares.
      num_of_throw = 0
      value.each_with_index do |frame, index|
        return render json: { error: 'Wrong number of throws.' }, status: :unprocessable_entity if (frame.size > 2 && index != 9) ||
          frame.size > 3
        return render json: { error: 'Wrong number of knocked over pins.' }, status: :unprocessable_entity if (frame.sum > 10 &&
          index != 9) || frame.sum > 30
        return render json: { error: 'Missing throw.' }, status: :unprocessable_entity if (frame.sum != 10 && frame.size == 1) || 
          ((frame.sum == 10 || frame.sum == 20) && frame.size == 2 && index == 9)
      end
    end
    render json: {
      scores: {},
      winner: '',
    }
  end
end
