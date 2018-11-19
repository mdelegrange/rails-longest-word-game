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

    sorted_grid = @grid.split(' ').sort.group_by { |i| i }.map { |k, v| [k, v.length] }.to_h
    @sorted_word = @longest_word.upcase.split('').sort.group_by { |i| i }.map { |k, v| [k, v.length] }.to_h

    @comparison = @sorted_word.map do |letter, number|
      sorted_grid.key?(letter) && sorted_grid[letter] >= number
    end

    url = 'https://wagon-dictionary.herokuapp.com/' + @longest_word
    @word_dictionary = JSON.parse(open(url).read)
  end
end
