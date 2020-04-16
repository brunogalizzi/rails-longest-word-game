require 'open-uri'
# games controller class
class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
    $start_time = Time.now
    $letters = @letters
  end

  def score
    @result = run_game(params[:answer], $letters)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    @array = []
    (0...grid_size).each do
      @array << ('A'..'Z').to_a.sample
    end
    @array
  end
end

def parse_prog(attempt)
  url = 'https://wagon-dictionary.herokuapp.com/' + attempt
  word_info = open(url).read
  word = JSON.parse(word_info)
  word
end

def run_game(attempt, grid)
  # TODO: runs the game and return detailed hash of result
  end_time = Time.now
  word = parse_prog(attempt)
  pow = (word['length']**3).positive? ? (word['length']**3) : 0 if word['found'] == true
  if attempt.upcase.chars.map { |char| attempt.upcase.chars.count(char) <= grid.count(char) }.all? == true
    result = {
      time: (end_time - $start_time),
      score: (word['found'] == true ? pow - (end_time - $start_time).to_i : 0),
      message: (word['found'] == true ? 'Well done!' : 'Not an english word!')
    }
  else result = { time: 0, score: 0, message: "It's not in the grid!" }
  end
  result
end
