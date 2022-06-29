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

    puts "Colors to choose from #{COLORS}. No duplicates allowed."
    puts 'Legend: " " (space) - color is not present, O - color is in the wrong place, X - color is in the right place.'

    until end_game?
      puts "Enter #{@num_colors} color(s) from the list above separated with \" \" (one space):"
      player_selection = gets.chomp.split(' ')

      check_player_selection(player_selection)

      puts show_codebreaker_guess(player_selection)

      @moves_left -= 1

      puts '===================='
    end
  end

  def game_codemaker
    puts "Colors to choose from #{COLORS}. No duplicates allowed."
    puts "Create a color scheme of #{@num_colors}, separated by \" \" (one space)."

    @color_scheme = gets.chomp.split(' ')
    @color_scheme_code = @color_scheme.map { |color| COLORS.index(color) }

    player_selection = []

    (0..3).each { |i| player_selection[i] = COLORS[i] }

    check_player_selection(player_selection)

    puts show_codebreaker_guess(player_selection)

    until end_game?
      filter_code_pool(player_selection)
    end
  end

  def filter_code_pool(player_selection)
    selected_code = player_selection.map { |color| COLORS.index(color) }

    @code_pool.delete(selected_code)

    s = []
    @code_pool.each do |code|
      guess_score = { 'X' => 0, 'O' => 0 }
      selected_code.each_with_index do |i, e|
        if e == code[i]
          guess_score['X'] += 1
        elsif !code.find_index(e).nil?
          guess_score['O'] += 1
        end
      end

      if guess_score == @codebreaker_guess
        s.push(code)
      end
    end

  end

  def check_player_selection(player_selection)
    @codebreaker_guess = { 'X' => 0, 'O' => 0 }

    player_selection.each_with_index do |color, i|
      if color == @color_scheme[i]
        @codebreaker_guess['X'] += 1
      elsif !@color_scheme.find_index(color).nil?
        @codebreaker_guess['O'] += 1
      end
    end
  end

  def generate_all_codes
    (0..COLORS.length ** @num_colors - 1).each do |i|
      code = i.to_s(COLORS.length)
      @code_pool[i] = (code.length == @num_colors ? code.split('') : code.prepend('0' * (@num_colors - code.length)).split('')).map { |str| str.to_i}
    end
  end

  def end_game?
    if @num_colors == @codebreaker_guess['X']
      puts "Congrats! #{@player_role == 'codebreaker' ? 'You' : 'Computer'} won!"
      return true
    elsif @moves_left.zero?
      puts "#{@player_role == 'codebreaker' ? 'You' : 'Computer'} couldn\'t crack the code. #{@player_role == 'codebreaker' ? 'Computer' : 'You'} won!"
      return true
    else
      return false
    end
  end

  def show_codebreaker_guess(player_selection)
    player_selection.join(' | ') + 
      ' ===> ' +
      @codebreaker_guess.map { |key, value|
        (1..value).map { key }
      }.reduce { |sum, e| sum.concat(e) }.shuffle.join(' | ')
  end
end

#game = Game.new('codemaker')
game = Game.new()
game.start_game
