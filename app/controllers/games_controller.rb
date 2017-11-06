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
      run_game(@attempt, @letters, @start_time, @end_time)
      if session[:total].nil?
        session[:total] = @score
      else
        session[:total] += @score
      end
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
    if !english?(attempt)
      @message = "Not an english word"
    elsif !in_the_grid?(attempt, letters)
      @message = "The given word is not included in the given letters"
    else
      return compute_score(attempt, letters, start_time, end_time)
    end

  end

  def compute_score(attempt, letters, start_time, end_time)
    @time = (end_time - start_time)
    length = 1 / (letters.length - attempt.length).to_f
    @score = ((1 /@time) * length  * 10000).to_i
    @message = "Well done"
  end
end

