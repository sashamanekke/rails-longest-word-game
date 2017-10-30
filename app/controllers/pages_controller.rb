require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def game
    @grid = generate_grid(10)
    @grid_string = ""
    @grid.each do |lettre|
      @grid_string += lettre[0]
    end
    @start_time = Time.now
  end

  def score
    @grid = params[:grid]
    @word = params[:query]
    @start_time = params[:start_time].to_time
    @end_time = Time.now
    @result = run_game(@word,@grid,@start_time,@end_time)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid_size.times do
      grid << ('A'..'Z').to_a.sample(1)
    end
    grid
  end

  def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
    final_score = 0
    if word_exists(attempt)
      word_in_grid_exact(attempt, grid) ? (message = "well done") : (message = "not in the grid")
      final_score = compute_score(attempt, start_time, end_time) if message == "well done"
    else
      message = "not an english word"
    end
    time_taken = end_time - start_time
    { time: time_taken, score: final_score, message: message }
  end

  def word_in_grid_exact(word, grid)
    answer = true
    word.chars.each do |letter|
      if grid.include?(letter.upcase)
        grid.slice!(grid.index(letter.upcase))
      else
        return false
      end
    end
    answer
  end

  def word_exists(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/' + attempt.to_s
    test_word = open(url).read
    answer = JSON.parse(test_word)
    answer['found']
  end

  def compute_score(attempt, start_time, end_time)
    attempt.size * 100 - (end_time - start_time).to_i
  end

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end
end
