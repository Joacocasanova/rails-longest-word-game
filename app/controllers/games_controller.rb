require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    cookies[:score] = 0
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def continue
    cookies[:score] = 0 unless cookies[:score]
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @game_score = 0
    grid = params[:grid].split("")
    if valid_word?(params[:answer]) && included?(params[:answer], grid)
      @result = "Congratulations <strong>#{params[:answer]}</strong> is a valid English word!"
      @game_score = params[:answer].length * 2
      cookies[:score] = cookies[:score].to_i + @game_score
    elsif valid_word?(params[:answer]) && !included?(params[:answer], grid)
      @result = "Sorry but <strong>#{params[:answer]}</strong> can't be build out of #{grid.join(" ")}"
    else
      @result = "Sorry but <strong>#{params[:answer]}</strong> doest not seem to be a valid English word"
    end
  end

  def valid_word?(attempt)
    file_path = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    JSON.parse(open(file_path).read)["found"]
  end

  def included?(attempt, grid)
    attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
  end

end
