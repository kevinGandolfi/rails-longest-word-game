require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def english_word?(url)
    test = URI.open(url).read
    data = JSON.parse(test)
    data["found"] == true
  end

  def compute_score(time, number_of_letters)
    (number_of_letters * 100) / time
  end

  def check_letters_in_grid?(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def score
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    time_taken = end_time - start_time
    if check_letters_in_grid?(attempt.upcase, grid) == false
      return { score: 0, message: 'You used some letters that are not in the grid.', time: time_taken }
    end

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    if english_word?(url)
      { score: compute_score(time_taken, attempt.size), message: 'Well done!', time: time_taken }
    else
      { score: 0, message: 'Not an English word.', time: time_taken }
    end
  end
end
