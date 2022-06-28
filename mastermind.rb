class Game
  COLORS = ['red', 'green', 'blue', 'yellow', 'purple', 'orange', 'pink', 'cyan']
  

  def initialize(player_role = 'codebreaker', num_colors = 4, num_moves = 12)
    @num_colors = num_colors
    @moves_left = num_moves
    @player_guess = {}
    @player_role = player_role
    @code_pool = []
  end

  def start_game
    case @player_role
    when 'codebreaker'
      game_codebreaker
    when 'codemaker'
      generate_all_codes
      game_codemaker
    end
  end

  private

  def game_codebreaker
    @color_scheme = COLORS.sample(@num_colors)

    puts "Colors to choose from #{COLORS}"
    puts 'Legend: " " (space) - color is not present, O - color is in the wrong place, X - color is in the correct place.'

    until end_game?
      puts "Enter #{@num_colors} color(s) from the list above separated with \", \" (coma and space):"
      player_selection = gets.chomp.split(', ')
      @player_guess = {}

      player_selection.each_with_index do |color, i|
        if color == @color_scheme[i]
          @player_guess[color] = 1
        elsif !@color_scheme.find_index(color).nil?
          @player_guess[color] = -1
        else
          @player_guess[color] = 0
        end
      end

      puts show_player_guess(player_selection)

      @moves_left -= 1

      puts '===================='
    end

    def game_codemaker
      puts "Colors to choose from #{COLORS}"
      puts "Create a color scheme of #{@num_colors}, separated by \", \" (coma and space)."

      @color_scheme = gets.chomp.split(', ')

      until end_game?

      end
    end
  end

  def generate_all_codes
    (0..@num_colors ** COLORS.length - 1).each do |i|
      code = i.to_s(COLORS.length)
      @code_pool[i] = (code.length == @num_colors ? code.split('') : code.prepend('0' * (@num_colors - code.length)).split(''))
    end
  end

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

  def show_player_guess(player_selection)
    result = player_selection.join(' | ') + 
            ' ===> ' +
            @player_guess.map { |color, status|
              case status
              when 1
                'X'
              when -1
                'O'
              when 0
                ' '
              end
            }.join(' | ')
  end
end

game = Game.new
game.start_game
