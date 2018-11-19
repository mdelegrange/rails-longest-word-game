require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      alphabet = ('A'..'Z').to_a
      @letters << alphabet.sample
    end
  end

  def score
    @longest_word = params[:longest_word]
    @grid = params[:grid]
    @score = session[:score]

    url = 'https://wagon-dictionary.herokuapp.com/' + @longest_word
    word_dictionary = JSON.parse(open(url).read)

    @word_in_grid = word_in_grid?(@longest_word, @grid)
    @english_word = word_dictionary['found'] ? true : false

    if session[:score]
      session[:score] += @longest_word.size if @word_in_grid && @english_word
    else
      session[:score] = 0
    end
  end

  private

  def word_in_grid?(word, grid)
    sorted_grid = number_of_letters(grid)
    sorted_word = number_of_letters(word)

    comparison = sorted_word.map do |letter, number|
      sorted_grid.key?(letter) && sorted_grid[letter] >= number
    end

    comparison.include?(false) ? false : true
  end

  def number_of_letters(word)
    word.upcase.split('').sort.group_by { |i| i }.map { |k, v| [k, v.length] }.to_h
  end
end
