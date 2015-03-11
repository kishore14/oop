class Board
  
  attr_accessor :board
  def initialize
    @board = {}
    (1..9).each { |position| @board[position] = position }
  end
  
  def display_board
    system 'clear'
    puts " Tic Tac Toe "
    puts "  "+"#{board[1].to_s.sub(/1/,' ')} | #{board[2].to_s.sub(/2/,' ')} | #{board[3].to_s.sub(/3/,' ')}"
    puts "  "+"----------"
    puts "  "+"#{board[4].to_s.sub(/4/,' ')} | #{board[5].to_s.sub(/5/,' ')} | #{board[6].to_s.sub(/6/,' ')}"
    puts "  "+"----------"
    puts "  "+"#{board[7].to_s.sub(/7/,' ')} | #{board[8].to_s.sub(/8/,' ')} | #{board[9].to_s.sub(/9/,' ')}"
  end
  
  def empty_squares
    board.select {|k, v| v.to_s!='X' && v.to_s!='O' }.keys
  end

  def select_a_square(square, value)
    board[square] = value
  end
    
  def winner?
    Tictactoe::WINNING_LINES.each do |line|
      return "Player" if board.values_at(*line).count('X') == 3
      return "Computer" if board.values_at(*line).count('O') == 3
    end #end do
    return false
  end #end method
end

class Player
  attr_accessor = :choice
end

class Human < Player
  
  attr_accessor :name
  def initialize(name)
    @name = name
  end
  
  def pick_a_square(board_in_play)
    puts "#{name} ... Pick a square ... "
    begin
      choice = gets.chomp.to_i
      empty_square = board_in_play.empty_squares.include? choice
      if !empty_square
        puts "Invalid selection! Please select empty squares only! "
      end
    end until empty_square
    board_in_play.select_a_square(choice, 'X') 
  end
end

class Computer < Player
  def pick_a_square(board_in_play)
    winner = choose_to_win(board_in_play)
    if !winner
      defend = choose_to_defend(board_in_play)
      if !defend
        board_in_play.select_a_square(board_in_play.empty_squares.sample, 'O')
      else
      end 
    end 
  end

  def choose_to_defend(board_in_play)
    Tictactoe::WINNING_LINES.each do |line|
      line_values_arr = [board_in_play.board[line[0]], board_in_play.board[line[1]], board_in_play.board[line[2]]] 
      if line_values_arr.count('X') == 2 && line_values_arr.count('O')==0 
        choice =  line_values_arr.select {|position| position.to_s!='X'}.first
        board_in_play.select_a_square(choice, 'O')
        return true
      end # end for if
    end # end for do 
    return false
  end # Method end

  def choose_to_win(board_in_play)
    if board_in_play.board[5] == 5 #always choose center. That's my strategy .. lol.. 
      choice = 5 #since I am getting array from below, I am coding this way
      board_in_play.select_a_square(choice, 'O')
      return true
    else
      Tictactoe::WINNING_LINES.each do|line|
      line_values_arr = [board_in_play.board[line[0]], board_in_play.board[line[1]], board_in_play.board[line[2]]] 
        if line_values_arr.count('O') == 2 and line_values_arr.count('X')==0 
          choice =  line_values_arr.select {|position| position.to_s!='O'}.first
          board_in_play.select_a_square(choice, 'O')
          return true
        end # end for if
      end # end for do 
    end #end of if
    return false
  end # Method end
end

class Tictactoe
  
  attr_accessor :board, :player, :computer, :board_in_play, :winner
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9,], [3,5,7]]
  @@total_games = 0
  @@total_player_wins = 0
  @@total_customer_wins = 0
  @@total_ties = 0
  def initialize(name)
    @board_in_play = Board.new
    @player = Human.new(name)
    @computer = Computer.new
  end

  def play
    begin
      if @@total_games.odd? && board_in_play.board[5] == 5 
        computer.pick_a_square(board_in_play)
      end
      board_in_play.display_board
      player.pick_a_square(board_in_play)
      computer.pick_a_square(board_in_play)
      winner = board_in_play.winner?
    end until winner|| board_in_play.empty_squares.empty?
  end

  def display_history
    board_in_play.display_board
    winner = board_in_play.winner?
    @@total_games += 1
    if winner 
      if winner == "Player"
        @@total_player_wins += 1
        puts "You Won!"
      elsif winner == "Computer"
        @@total_customer_wins += 1
        puts "Computer Won!"
      end
    else
      @@total_ties += 1
      puts "Its a tie!"
    end
    puts "History: Total Games => #{@@total_games}, Player => #{@@total_player_wins}, Computer => #{@@total_customer_wins}, Tie => #{@@total_ties}"
  end
end

  puts "Lets play Tic Tac Toe! What's your name... "
  name = gets.chomp.capitalize
begin
  game = Tictactoe.new(name)
  game.play
  game.display_history
  puts "Do you wish to play again, #{name}? (y/n)"
  play_again = gets.chomp.downcase
end until play_again !='y'
puts "Thanks for playing, #{name} .... Good bye!!"