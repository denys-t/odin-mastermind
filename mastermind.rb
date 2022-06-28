class Game
  COLORS = %w[red green blue yellow purple orange pink cyan].freeze

  def initialize(player_role = 'codebreaker', num_colors = 4, num_moves = 12)
    @num_colors = num_colors
    @moves_left = num_moves
    @codebreaker_guess = {}
    @player_role = player_role # 'codebreaker' or 'codemaker'
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
      @codebreaker_guess = {}

      player_selection.each_with_index do |color, i|
        if color == @color_scheme[i]
          @codebreaker_guess[color] = 1
        elsif !@color_scheme.find_index(color).nil?
          @codebreaker_guess[color] = -1
        else
          @codebreaker_guess[color] = 0
        end
      end

      puts show_codebreaker_guess(player_selection)

      @moves_left -= 1

      puts '===================='
    end
  end

  def game_codemaker
    puts "Colors to choose from #{COLORS}"
    puts "Create a color scheme of #{@num_colors}, separated by \", \" (coma and space)."

    @color_scheme = gets.chomp.split(', ')

    until end_game?

    end
  end

  def generate_all_codes
    (0..@num_colors ** COLORS.length - 1).each do |i|
      code = i.to_s(COLORS.length)
      @code_pool[i] = (code.length == @num_colors ? code.split('') : code.prepend('0' * (@num_colors - code.length)).split('')).map { |str| str.to_i}
    end
  end

  def end_game?
    if @num_colors == @codebreaker_guess.values.reduce(0) { |sum, e| sum + e }
      puts 'Congrats! You won!'
      return true
    elsif @moves_left.zero?
      puts 'You couldn\'t crack the code. You lost!'
      return true
    else
      return false
    end
  end

  def show_codebreaker_guess(player_selection)
    player_selection.join(' | ') + 
      ' ===> ' +
      @codebreaker_guess.map { |_color, status|
        case status
        when 1
          'X'
        when -1
          'O'
        when 0
          ' '
        end
      }.shuffle.join(' | ')
  end
end

game = Game.new
game.start_game
