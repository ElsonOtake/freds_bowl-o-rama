class ScoresController < ApplicationController
  def create
    render json: {
      scores: {},
      winner: '',
    }
  end
end
