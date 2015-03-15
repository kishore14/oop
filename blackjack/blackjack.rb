#blackjack.rb
class Card
  attr_accessor :face_value, :suit
  
  def initialize(suit, face_value)
    @face_value = face_value
    @suit = suit
  end
  
  def display_card
    print "#{face_value} #{symbol_of_suit.encode('utf-8')}"
  end
  
  def symbol_of_suit
    case suit
    when 'H' then "\u2665"
    when 'S' then "\u2660"
    when 'C' then "\u2663"
    when 'D' then "\u2666"
    end
  end
end

class Deck
  attr_accessor :cards
  
  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
  end
  
  def scramble!
    cards.shuffle!
  end
  
  def deal_card
    cards.shift
  end
end

module Hand
  def add_card_to_hand(card)
    hand << card
  end
  
  def display_cards
    puts "#{name}"
    puts "------------"
    hand.each do |card|
      card.display_card
      print("   ")  
    end
    puts "\nHand value: #{cards_total}"
    puts
  end
  
  def cards_total
    hand_values = hand.map { |card| card.face_value} 
    total = 0
    hand_values.each do |value|
      if value == 'A'
        total += 11
      elsif value.to_i == 0 # this is for J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end 
    hand_values.select{|value| value == "A"}.count.times do 
      total -= 10 if total >21
      end
    total
  end
  
  def busted?
    cards_total > 21 
  end
  
  def blackjack?
    cards_total == 21 
  end
end

class Player
  include Hand
  attr_accessor :name, :hand, :stayed
  
  def initialize(player_name)
    @name = player_name
    @stayed = false
    @hand = []
  end
end

class Dealer
  include Hand
  attr_accessor :name, :hand
  
  def initialize
    @name = 'Dealer'
    @hand = []
  end
  def display_one_card
    puts "#{name}"
    puts "------------"
    puts "#{hand[0].display_card}" + " and *" 
    puts
  end
end

class Blackjack
  attr_accessor :deck, :dealer, :player, :player_name
  
  def initialize(player_name)
    @player_name = player_name
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new(player_name)
  end
  
  def start_game
    system 'clear'
    deck.scramble!
    deal_initial_hands
    dealer.display_one_card
    player.display_cards
    if !player.blackjack?
      player_turn
      dealer_turn if player.stayed 
    end
    display_winner
  end
  
  def deal_initial_hands
    2.times do 
      player.add_card_to_hand(deck.deal_card)
      dealer.add_card_to_hand(deck.deal_card)
    end
  end
 
  def player_turn
      begin
        choice = player_choice? 
        if choice == 'h'
          player.add_card_to_hand(deck.deal_card)
          dealer.display_one_card
          player.display_cards
        else
          player.stayed = true
        end
      end until player.busted? || player.stayed
  end
  
  def player_choice?
    puts "\nDo you want to Hit or Stay (h/s)"
    player_choice = gets.chomp.downcase
    system 'clear'
    if !['h', 's'].include?(player_choice)
      puts "\nInvalid selection! Please enter 'h' to Hit or 's' to Stay !! "
    end
    player_choice
  end
  
  def dealer_turn
    while dealer.cards_total < 17
      dealer.add_card_to_hand(deck.deal_card)
      dealer.display_cards
      player.display_cards
    end 
  end
  
  def compute_winner
  case
    when player.cards_total > 21
      return 'dealer'
    when dealer.cards_total > 21
      return 'player'
    when dealer.cards_total > player.cards_total 
      return 'dealer'
    when dealer.cards_total < player.cards_total
      return 'player'
    else
      return 'push'
    end
  end
  
  def display_winner
    system 'clear'
    dealer.display_cards
    player.display_cards
  case compute_winner
    when 'dealer'
      puts "*** Dealer wins!! ***"
    when 'player' 
      puts "*** You won!! ***"
    else
      puts "*** Its a push!! ***"
    end
  end
  
  def play_again?
  puts "\nDo you want to play again? (y/n)"
  player_choice = gets.chomp.downcase
  player_choice =='y' ? true : false
  end
end

puts "Welcome to blackjack!"
puts "What's your name? ..."
name = gets.chomp.capitalize
begin
  game = Blackjack.new(name)
  game.start_game
end while game.play_again?
puts "Thanks for playing, #{name}! Good bye.... "