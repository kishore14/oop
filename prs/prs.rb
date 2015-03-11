#prs.rb
module Comparable
def compare(player)
  if(self.choice == player.choice)
    puts "\nIts a tie!"
  elsif(player.choice == 'p' && choice == 'r') || (player.choice == 'r' && choice == 's') || (player.choice == 's' && choice == 'p')
    display_winning_message(player.choice)
    puts "\nYou Won!!!"
  else
    display_winning_message(choice)
    puts "\nComputer Won!"
  end
end
  def display_winning_message(winning_choice)
	  case winning_choice
	  when 'p'
		  puts "\nPaper wraps Rock!"
	  when 'r'
		  puts "\nRock breaks Scissors!"  
	  when 's'
		  puts "\nScissors shreds Paper"
	  end
	end
end

class Player
  include Comparable
  attr_accessor :choice
end

class Human < Player
  attr_accessor :name
  def initialize(name)
    @name = name
  end
  def pick_hand
    puts "#{name} please choose p/r/s"
    begin
      @choice =  gets.chomp.downcase
      if !['p', 'r', 's'].include?(choice)
        puts "\n#{name} please enter p/r/s only !! "
      end
    end until ['p', 'r', 's'].include?(choice)
    puts "Your choice: #{Game::CHOICES[choice]}"
  end
end

class Computer < Player
  def pick_hand
    @choice =  Game::CHOICES.keys.sample.downcase
    puts "Computer choice: #{Game::CHOICES[choice]}"
  end
end

class Game
  attr_accessor :player, :computer
  CHOICES = {'p' => 'Paper', 'r'=> 'Rock', 's' => "Scissors"}
  def initialize
    puts "Welcome to Paper, Rock, Scissors! "
    puts "Please enter your name: "
    name = gets.chomp.capitalize
    @player = Human.new(name)
    @computer = Computer.new
  end
  def display_menu
    system 'clear'
    CHOICES.each do | key, value |
    puts "  #{key}: #{value}"
   end
  end  
  def repeat?
    puts "\nDo you want to continue? y/n"
    choice = gets.chomp.downcase
    if choice !='y'
      puts "Thanks for playing! Good bye..."
      return false
    end
    return true
  end
  
  def play
    begin
      display_menu
      player.pick_hand
      computer.pick_hand
      computer.compare(player)
    end while repeat?
  end
end
Game.new.play   