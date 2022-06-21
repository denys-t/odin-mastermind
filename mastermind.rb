class Game
  COLORS = ['red', 'green', 'blue', 'yellow', 'purple', 'orange', 'pink', 'cyan']

  def initialize(num_colors = 4, num_moves = 12)
    @num_colors = num_colors
    @color_scheme = COLORS.sample(num_colors)
    @moves_left = num_moves
    @player_guess = {}
  end

  def start_game
    puts "Colors to choose from #{COLORS}"
    puts 'Legend: X - color not present, O - color is in the wrong place, + - color is in the correct place.'

    until end_game?
      puts "Enter #{@num_colors} color(s) from the list above separated with ', ' (coma and space):"
      player_selection = gets.chomp.split(', ')
      @player_guess = {}

      puts player_selection.join(' | ')

      player_selection.each_with_index do |color, i|
        if color == @color_scheme[i]
          @player_guess[color] = 1
        elsif !@color_scheme.find_index(color).nil?
          @player_guess[color] = -1
        else
          @player_guess[color] = 0
        end
      end

      puts show_player_guess

      @moves_left -= 1

      puts '===================='
    end
  end

  private

  def end_game?
    if @num_colors == @player_guess.values.reduce { |sum, e| sum + e }
      puts 'Congrats! You won!'
      return true
    elsif @moves_left.zero?
      puts 'You couldn\'t crack the code. You lost!'
      return true
    else
      return false
    end
  end

  def show_player_guess
    @player_guess.map { |color, status|
      case status
      when 1
        '+'.prepend(' ' * (color.length/2)) + ' ' * (color.length.odd? ? color.length/2 : color.length/2 - 1)
      when -1
        'O'.prepend(' ' * (color.length/2)) + ' ' * (color.length.odd? ? color.length/2 : color.length/2 - 1)
      when 0
        'X'.prepend(' ' * (color.length/2)) + ' ' * (color.length.odd? ? color.length/2 : color.length/2 - 1)
      end
    }.join(' | ')
  end
end

game = Game.new
game.start_game
