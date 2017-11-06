require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << [*"A".."Z"].sample }
    @letters
  end

  def score
      # raise
      @attempt = params[:attempt]
      @letters = params[:letters]
      @start_time = DateTime.parse(params[:time])
      @end_time = Time.now
      @result = run_game(@attempt, @letters, @start_time, @end_time)
  end

  def in_the_grid?(attempt, letters)
    attempt.upcase.split('').all? do |letter|
      attempt.upcase.count(letter) <= letters.count(letter)
    end
  end

  def english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    answer_serialized = open(url).read
    answer = JSON.parse(answer_serialized)
    answer["found"]
  end

  def run_game(attempt, letters, start_time, end_time)
    result = { score: 0 }
    if !english?(attempt)
      result[:message] = "Not an english word"
    elsif !in_the_grid?(attempt, letters)
      result[:message] = "The given word is not included in the given letters"
    else
      return compute_score(attempt, letters, start_time, end_time)
    end
    result
  end

  def compute_score(attempt, letters, start_time, end_time)
    result = {}
    result[:time] = (end_time - start_time)
    length = 1 / (letters.length - attempt.length).to_f
    result[:score] = (1 / result[:time]) * length
    result[:message] = "Well done"
    return result
  end
end

