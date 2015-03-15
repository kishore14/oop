require 'pry'

module Hand
  
  def show_hand
    puts "-----#{name}'s Hand-----"
    puts hand
    puts "Total:#{total}"
  end

  def total
    result = hand.inject(0) { |sum,card| sum += Card::VALUES[card.face_value] }
    if result > 21 && ace_count > 0
      result = handle_aces(result, ace_count)
    end
    result
  end

  def handle_aces(result,num_of_aces)
    while num_of_aces > 0 && result > 21
      result -= 10
      num_of_aces -= 1
    end
    result
  end

  def ace_count
    hand.count {|card| card.face_value == "Ace"}
  end

  def add_card(deck)
    hand << deck.deal_card
  end

  def is_busted?
   self.total > 21
  end

  def say_busted
   puts "\n#{name} busts with a card value that is over 21."
  end

  def blackjack?
   total == 21 && hand.size == 2
  end
end

class Player
  include Hand

  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    @name = name
    @hand = []
  end
end

class Dealer
  include Hand

  attr_accessor :hand, :is_turn
  attr_reader :name


  def initialize
    @name = "Dealer"
    @hand = []
    @is_turn = false
  end

  def show_hand
    puts "-----#{name}'s Hand-----"
    if hand.size == 2 && !is_turn
      puts hand[0]
      puts "One card face down"
      puts "Total:#{Card::VALUES[hand[0].face_value]}"
    else 
      puts hand
      puts "Total:#{total}"
    end
  end
end

class Card
  attr_reader :face_value, :suit
  
   VALUES = {
  "Two"   => 2,
  "Three" => 3,
  "Four"  => 4,
  "Five"  => 5,
  "Six"   => 6,
  "Seven" => 7,
  "Eight" => 8,
  "Nine"  => 9,
  "Ten"   => 10,
  "Jack"  => 10,
  "Queen" => 10,
  "King"  => 10,
  "Ace"   => 11
}

  SUITS = ["Clubs", "Spades", "Hearts", "Diamonds"]
  VALUES.freeze
  SUITS.freeze

  def initialize(v,s)
    @face_value = v
    @suit = s
  end

  def to_s
    "#{face_value} of #{suit}"
  end

end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    combine_decks
    shuffle_decks!
  end

  def combine_decks
    number_of_decks = [2,3,4,5].sample
    number_of_decks.times { cards << generate_deck }
  end

  def shuffle_decks!
    cards.shuffle!
  end

  def generate_deck
    Card::SUITS.each do |suit| 
       Card::VALUES.keys.each do |value|
        cards << Card.new(value,suit)
      end
    end
  end

  def deal_card
    cards.pop
  end
end

class BlackJack
  attr_accessor :deck, :dealer, :player
  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @dealer.add_card(deck)
    @dealer.add_card(deck)
    puts "Please enter your name:"
    @player = Player.new(gets.chomp)
    @player.add_card(deck)
    @player.add_card(deck)
  end

  def reset
    deck = Deck.new
    dealer.hand = []
    dealer.is_turn = false
    player.hand = []
    dealer.add_card(deck)
    dealer.add_card(deck)
    player.add_card(deck)
    player.add_card(deck)
  end

  def display_game
    system 'clear'
    dealer.show_hand
    player.show_hand
  end

  def play
    display_game
    if player.blackjack? || dealer.blackjack?
      declare_winner(blackjack_comparision)
    else
      player_turn
      dealer_turn if !player.is_busted?
      declare_winner(normal_hand_comparison) 
    end
  end

  def declare_winner(message)
    puts "\n#{message}"
    puts "Thanks for playing!"
  end

  def normal_hand_comparison
    if player.total == dealer.total 
      "The game ends in a tie."
    elsif (dealer.total > player.total && !dealer.is_busted?) ||
          player.is_busted? 
      "#{dealer.name}'s wins!"  
    elsif (player.total > dealer.total && !player.is_busted?) || 
          dealer.is_busted?
      "#{player.name} wins."
    end
  end

  def blackjack_comparision
    if player.blackjack? && dealer.blackjack? 
      "Both players have BlackJack, the game ends in a tie."
    elsif player.blackjack? && !dealer.blackjack? 
      "#{player.name} has BlackJack and wins the game!"
    else 
      "The #{dealer.name} has BlackJack and wins the game."
    end
  end

  def player_turn
    begin
      puts "Hit or Stay"
      answer = gets.chomp.downcase
      puts "Please type hit or stay."; next if !['hit','stay'].include?(answer) 
      player.add_card(deck) if answer == 'hit'
      sleep(1)
      display_game
      break if player.is_busted? 
    end until answer == 'stay' 
    player.say_busted if player.is_busted?
  end

  def dealer_turn
    dealer.is_turn = true
    while dealer.total < 17
      dealer.add_card(deck)
      sleep(1)
      display_game
      break if dealer.is_busted? 
    end
    display_game if dealer.total >= 17
    dealer.say_busted if dealer.is_busted?
  end
end


game = BlackJack.new
begin
  game.play
  puts "Would you like to play another round" 
  answer = gets.chomp.downcase
  game.reset if ['yes','yea','y'].include?(answer) 
end until ['no','nope','n'].include?(answer) 