require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    @input = params[:word]
    @letters = params[:letters].chars
    @start_time = params[:start_time].to_time
    message = ''
    grid_ok = check_grid(@input, @letters)
    englishword_ok = check_word(@input)
      if grid_ok && englishword_ok
        score = (@input.length * 10) / (end_time - @start_time).to_f
        message = 'Well done!'
      else
        score = 0
        message << 'Your word is not in the grid!' unless grid_ok
        message << 'Your word is not an English word!' unless englishword_ok
      end
      @result = { time: end_time - @start_time, score: score, message: message }
    # @input = params[:word]
    # @letters = params[:letters]
    # if included?(@input, @letters)
    #   if english_word?(@input)
    #     [100, "Congratulations! #{@input} is a valid English word!"]
    #   else
    #     [0, "Dumbass! This is not an English word!"]
    #   end
    # else
    #   [0, "Dumbass! #{@input} is not in the grid #{@letters}!"]
  end

  private

  def check_grid(attempt, grid)
    letters = attempt.upcase.split(//)
    grid.sort!
    letters.all? do |letter|
      letters.count(letter) <= grid.count(letter)
    end
  end

  def check_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    englishword = JSON.parse(user_serialized)
    englishword['found']
  end
end
