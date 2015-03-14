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
  attr_accessor :deck
  
  def initialize
    @deck = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @deck << Card.new(suit, face_value)
      end
    end
  end
  
  def scramble!
    deck.shuffle!
  end
  
  def deal_a_card
    deck.shift
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
    puts "Hand value: #{cards_total}\n"
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
    cards_total > 21 ? true : false
  end
  
  def blackjack?
    cards_total == 21 ? true : false
  end
end

class Player
  include Hand
  attr_accessor :name, :hand, :stayed, :bet_amount, :blackjack
  
  def initialize(player_name)
    @name = player_name
    @stayed = false
    @blackjack = false
    @hand = []
    @bet_amount = 0
  end
  
  def play(deck, dealer)
    collect_bet
    display_hands_while_player_plays(dealer)
    if !blackjack?
      begin
        choice = player_choice? 
        if choice == 'h'
          add_card_to_hand(deck.deal_a_card)
          display_hands_while_player_plays(dealer)
        else
          display_hands_after_player_plays(dealer)
          self.stayed = true
        end
      end while !busted? && !stayed
    else
      blackjack = true
    end
  end
  
  def collect_bet
    begin
    puts "Enter bet: "
    bet_amount = gets.chomp.to_i
    if bet_amount <= 0  
      puts "Invalid Input!  "
    end
    end until bet_amount > 0
  end
   
  def display_hands_while_player_plays(dealer)
    system 'clear'
    dealer.display_dealer_one_card 
    display_cards
  end
    
  def display_hands_after_player_plays(dealer)
    system 'clear'
    dealer.display_cards
    display_cards
  end
    
  def player_choice?
    puts "\nDo you want to Hit or Stay (h/s)"
    player_choice = gets.chomp.downcase
    if !['h', 's'].include?(player_choice)
      puts "\nInvalid selection! Please enter 'h' to Hit or 's' to Stay !! "
    end
    player_choice
  end
end

class Dealer
  include Hand
  attr_accessor :name, :hand
  
  def initialize
    @name = 'Dealer'
    @hand = []
  end
  
  def deal_initial_hands(deck, player, dealer)
    2.times do 
      player.add_card_to_hand(deck.deal_a_card)
      dealer.add_card_to_hand(deck.deal_a_card)
    end
  end
  
  def display_dealer_one_card
    puts "#{name}"
    puts "------------"
    puts "#{hand[0].display_card}" + " and *" 
    puts
  end
  def play(deck, player)
    while cards_total < 17
      add_card_to_hand(deck.deal_a_card)
      display_cards
      player.display_cards
    end 
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
    deck.scramble!
    dealer.deal_initial_hands(deck, player, dealer)
    player.play(deck, dealer)
    if player.stayed && !player.blackjack
      dealer.play(deck, player)
    end
    display_winner
  end
  
  def winner?
   dealer_hand_value = dealer.cards_total
   player_hand_value = player.cards_total
  case
    when player_hand_value > 21
      return 'dealer'
    when dealer_hand_value > 21
      return 'player'
    when dealer_hand_value > player_hand_value 
      return 'dealer'
    when dealer_hand_value < player_hand_value
      return 'player'
    else
      return 'push'
    end
  end
  
  def display_winner
  player.display_hands_after_player_plays(dealer)  
  case winner?
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