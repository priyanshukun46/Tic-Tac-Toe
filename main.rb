class Game
  @@turn_count = 1
  @@winner = ''

  def initialize
    puts "Enter your first player name: "
    @player_name_one = gets.chomp
    puts "Enter your second player name: "
    @player_name_two = gets.chomp
    @board = Array.new(3) { Array.new(3, '_') }
  end

  def display_board(board)
    puts ""
    puts "#{board[0][0]} | #{board[0][1]} | #{board[0][2]}"
    puts "---------"
    puts "#{board[1][0]} | #{board[1][1]} | #{board[1][2]}"
    puts "---------"
    puts "#{board[2][0]} | #{board[2][1]} | #{board[2][2]}"
    puts ""
  end

  def player_turn
    # Fix #2: was calling undefined `turn`, use @@turn_count
    if @@turn_count.odd?
      player_choice(@player_name_one, 'X')
    else
      player_choice(@player_name_two, 'O')
    end
  end

  def player_choice(player, symbol)
    puts "#{player}, please enter your coordinates separated by a space (e.g. 1 2):"
    input = gets.chomp
    input_array = input.split
    coord_one = input_array[0].to_i
    coord_two = input_array[1].to_i

    # Fix #4: was `board` (undefined local), must be `@board`
    until input.match(/\s/) &&
          coord_one.between?(0, 2) &&
          coord_two.between?(0, 2) &&
          @board[coord_one][coord_two] == '_'
      puts "Please enter a valid coordinate!"
      input = gets.chomp
      input_array = input.split
      coord_one = input_array[0].to_i
      coord_two = input_array[1].to_i
    end

    add_to_board(coord_one, coord_two, symbol)
  end

  def add_to_board(coord_one, coord_two, symbol)
    @board[coord_one][coord_two] = symbol
    @@turn_count += 1
  end

  def three_across
    @board.each do |row|
      if row.all? { |cell| cell == 'X' }
        @@winner = 'X'
        @@turn_count = 10
      elsif row.all? { |cell| cell == 'O' }
        @@winner = 'O'
        @@turn_count = 10  # Fix #9: was 0, must be 10 to stop the game
      end
    end
  end

  def three_down
    # Fix #5: column check by iterating column indices directly (clean & correct)
    3.times do |col|
      col_vals = @board.map { |row| row[col] }
      if col_vals.all? { |cell| cell == 'X' }
        @@winner = 'X'
        @@turn_count = 10
      elsif col_vals.all? { |cell| cell == 'O' }
        @@winner = 'O'
        @@turn_count = 10
      end
    end
  end

  def three_diagonal
    # Fix #6: was `@board[i][1]`, `i` undefined — center is always [1][1]
    center = @board[1][1]
    return if center == '_'

    # Fix #7: was `@board[2][2] && @board[0][0] == center` (wrong precedence)
    if @board[0][0] == center && @board[2][2] == center
      @@winner = center
      @@turn_count = 10
    elsif @board[0][2] == center && @board[2][0] == center
      @@winner = center
      @@turn_count = 10
    end
  end

  def declare_winner(symbol)
    # Fix #8: corrected player-to-symbol mapping (player one → X, player two → O)
    case symbol
    when 'X'
      puts "#{@player_name_one} wins the game!"
    when 'O'
      puts "#{@player_name_two} wins the game!"
    else
      puts "It's a tie!!!"
    end
  end

  def play_game
    puts "\nHere is your empty battlefield:"
    display_board(@board)

    # Fix #3: was player_turn(@@turn_count), method takes no arguments
    until @@turn_count >= 10
      player_turn
      three_across
      three_down
      three_diagonal
      display_board(@board)
    end

    declare_winner(@@winner)
  end
end

puts "------> TIC-TAC-TOE <------"
puts ""
puts "  - Player one uses X, player two uses O"
puts ""
game = Game.new
game.play_game