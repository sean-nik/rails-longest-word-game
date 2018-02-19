require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = []
    alphabet = ('a'..'z').to_a
    10.times { @letters << alphabet.sample }
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:input]}"
    result_string = open(url).read
    result_hash = JSON.parse(result_string)
    validword = result_hash["found"]

    input_hash = {}
    ('a'..'z').to_a.each { |letter| input_hash[letter] = 0 }
    params[:input].split('').each { |letter| input_hash[letter] += 1 }

    grid_hash = {}
    ('a'..'z').to_a.each { |letter| grid_hash[letter] = 0 }
    params[:letters].gsub(' ', '').split('').each { |letter| grid_hash[letter] += 1 }

    if validword == false
      @answer = "#{params[:input]} is not a valid English word"
    else
      @answer = nil
      input = params[:input]
      letters = params[:letters]
      grid_hash.each do |letter, count|
        if (input_hash[letter] > grid_hash[letter])
          @answer = "Sorry but #{input} can't be built out of #{letters}"
          break
        end
      end
      @answer ||= "Congratulations #{input} is a valid English word"
    end
  end
end

