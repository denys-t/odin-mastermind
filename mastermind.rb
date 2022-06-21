class Game
  COLORS = ['red', 'green', 'blue', 'yellow', 'purple', 'orange', 'pink', 'cyan']

  def initialize(num_colors = 4, num_moves = 12)
    @num_colors = num_colors
    @color_scheme = COLORS.sample(num_colors)
    @moves_left = num_moves
    @player_guess = Array.new(num_colors, 0)
  end

  def start_game
    puts "Colors to choose from #{COLORS}"

    until end_game?
      puts "Enter #{@num_colors} from the list above separated with ', ' (coma and space):"
      @player_selection = gets.chomp.split(', ')

      @player_selection.each_with_index do |color, i|
        if color == @color_scheme[i]
          puts "You have put #{color} in the right place."
          @player_guess[i] = 1
        elsif !@color_scheme.find_index(color).nil?
          puts "You have put #{color} in the wrong place."
          @player_guess[i] = -1
        else
          puts "The #{color} is not present."
          @player_guess[i] = 0
        end
      end

      @moves_left -= 1
    end
  end

  private

  def end_game?
    if @num_colors == @player_guess.reduce{ |sum,e| sum + e }
      puts 'Congrats! You won!'
      return true
    elsif @moves_left.zero?
      puts 'You couldn\'t crack the code. You lost!'
      return true
    else
      return false
    end
  end

end

game = Game.new
game.start_game