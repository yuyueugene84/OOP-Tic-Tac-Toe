#Player to model two players
#human class is a player extension to model user
#computer class is a player extension to model computer
#TTT is the class that models game itself

require 'pry'

module HelpMethods

  def check_full_grid(arr)
    if !arr.include?(" ") #if there is no empty space, return true
      return true
    end
  end

  def check_position_filled(board, position)
    if board[position.to_i - 1] != " "
      true
    else
      false
    end
  end

  def initialize_array
    arr = []
    9.times do
      arr << " "
    end
    arr
  end

  def print_grid(arr)
    system 'clear'
    puts "#{arr[0]}|#{arr[1]}|#{arr[2]}"
    puts "-----"
    puts "#{arr[3]}|#{arr[4]}|#{arr[5]}"
    puts "-----"
    puts "#{arr[6]}|#{arr[7]}|#{arr[8]}"
    puts "-----"
    puts "     "
  end

end #end module


class Player
  attr_reader :name
  attr_accessor :choice

  def initialize(name)
    @name = name
  end
end

class Human < Player
  include HelpMethods

  def pick_grid(board)
    while true
      puts "Please choose a position, from 1 - 9:"
      user_position = gets.chomp.to_i
      if (1..9).to_a.include?(user_position) && (check_position_filled(board, user_position) == false)
        board[user_position - 1] = "X" #user input will print X in grid
        break
      else
        puts "Error: you must enter a position (from 1 to 9) of an empty grid."
      end
    end
    board
  end #end pick_grid
end

class Computer < Player
  include HelpMethods

  def pick_grid(board)
    while true
      computer_position = rand(1..9)
      if (1..9).to_a.include?(computer_position) && check_position_filled(board, computer_position) == false
        board[computer_position - 1] = "O" #user input will print X in grid
        break
      end #end if
    end
    board
  end #end pick_grid
end

class TTT

  include HelpMethods
  attr_accessor :player_choice, :computer_choice, :board, :human, :computer, :playing
  WIN_CONDITIONS = [ 210, 543, 876, 630, 741, 853, 840, 642 ] #joined index for hashing, in reversed order to avoid invalid octal digit
  @@hash = [] #used to store hashed values of the WIN_CONDITIONS
  @board = []

  def initialize
    @human = Human.new("Neo")
    @computer = Computer.new("Matrix")
    @board = initialize_array
    print_grid(@board)
    playing == true

    WIN_CONDITIONS.each do |num|
      @@hash << num.to_f / 17 #hash winning positions into unique values, put into array
    end
  end

  def check_win(arr)
    arr_player = []
    arr_computer = []
    player_combinations = []
    computer_combinations = []
    player_processed = []
    computer_processed = []

    arr.each_with_index do |value, index|
      if value == "X"
        arr_player << index
      elsif value == "O"
        arr_computer << index
      end #end if
    end #end for loop

    player_combinations << arr_player.combination(3).to_a #find out all possible combinations of the position indexes
    computer_combinations << arr_computer.combination(3).to_a

    player_combinations[0].each do |combination| #store all reversed, joined position indexes for hash evaluation
      player_processed << combination.map(&:to_s).reverse.join.to_i
    end

    computer_combinations[0].each do |combination|
      computer_processed << combination.map(&:to_s).reverse.join.to_i
    end

    player_processed.each do |value|  #check if any hashed combination value is equal to the hashed value in @@hash
      if @@hash.include?(value.to_f / 17)
        return 1 #player wins
      end
    end

    computer_processed.each do |value|
      if @@hash.include?(value.to_f / 17)
        return 2 #computer wins
      end
    end

    nil
  end #end checkwin

  def intro
    puts "Lets play Tic Tac Toe!"
  end

  def replay #ask if player wants to play again
    begin
      puts "Play Again? (Y/N)"
      user_input = gets.chomp.downcase
    end while !['y','n'].include?(user_input)
    if user_input == 'y'
      TTT.new.play
    elsif user_input == 'n'
      puts "Thank you for playing!"
      puts "=========================================================="
      puts "This game is created by Eugene Chang a.k.a ToxicStar, 2014"
      puts "=========================================================="
      exit
    end #end if
  end #end replay

  def play
    intro
    begin
      @board = human.pick_grid(board)
      print_grid(board)
      if check_full_grid(board) == true && check_win(board) == nil #check if it's a tie
        puts "It's a tie!"
        playing = false
      elsif check_full_grid(board) == true && check_win(board) == 1
        puts "YOU WIN!"
        playing = false
      elsif check_full_grid(board) == true && check_win(board) == 2
        puts "you lose..."
        playing = false
      else
        @board = computer.pick_grid(board) #if it's not a tie and the board is not full, then computer can make a move
      end

      print_grid(board)

      if check_win(board) == 1
        puts "YOU WIN!"
        playing = false
      end
      if check_win(board) == 2
        playing = false
        puts "you lose..."
      end
    end until playing == false
    replay
  end #end play

end #end class TTT

#-----------Main program starts here--------------
game = TTT.new.play
