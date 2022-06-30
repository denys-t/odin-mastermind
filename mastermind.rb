  class Game
    COLORS = %w[red green blue yellow purple orange pink cyan].freeze

    def initialize(player_role = 'codebreaker', num_colors = 4, num_turns = 12)
      @num_colors = num_colors
      @turns_left = num_turns
      @codebreaker_guess = {}
      @player_role = player_role # 'codebreaker' or 'codemaker'
    end

    def start_game
      case @player_role
      when 'codebreaker'
        game_codebreaker
      when 'codemaker'
        game_codemaker
      end
    end

    private

    ################# CODE-BREAKER #################

    def game_codebreaker
      @color_scheme = COLORS.sample(@num_colors)
      @color_scheme_code = @color_scheme.map { |color| COLORS.index(color) }

      puts "Colors to choose from #{COLORS}. No duplicates allowed."
      puts 'Legend: " " (space) - color is not present, O - color is in the wrong place, X - color is in the right place.'

      until end_game?
        puts "===== Turns left: #{@turns_left} ====="
        puts "Enter #{@num_colors} color(s) from the list above separated with \" \" (one space):"
        player_selection = gets.chomp.split(' ')
        player_selection_code = player_selection.map { |color| COLORS.index(color) }

        check_player_selection(player_selection_code, @color_scheme_code)

        puts show_codebreaker_guess(player_selection)

        @turns_left -= 1
      end
    end

    ################# CODE-MAKER #################

    def game_codemaker
      generate_all_codes
      knuth_codes = @all_codes
      possible_codes = @all_codes
      
      puts "Colors to choose from #{COLORS}. No duplicates allowed."
      puts "Create a color scheme of #{@num_colors}, separated by \" \" (one space)."

      @color_scheme = gets.chomp.split(' ')
      @color_scheme_code = @color_scheme.map { |color| COLORS.index(color) }

      player_selection = []

      (0..3).each { |i| player_selection[i] = COLORS[i] } # choosing the first guess
      player_selection_code = player_selection.map { |color| COLORS.index(color) }

      check_player_selection(player_selection_code, @color_scheme_code)

      puts show_codebreaker_guess(player_selection)

      until end_game?
        #filter_code_pool(player_selection)

      end
    end

    def generate_all_codes
      @all_codes = []
      (0..COLORS.length ** @num_colors - 1).each do |i|
        code = i.to_s(COLORS.length)
        @all_codes[i] = (code.length == @num_colors ? code.split('') : code.prepend('0' * (@num_colors - code.length)).split('')).map { |str| str.to_i}
      end
    end

    # def filter_code_pool(player_selection)
    #   selected_code = player_selection.map { |color| COLORS.index(color) }

    #   @code_pool.delete(selected_code)

    #   s = []
    #   @code_pool.each do |code|
    #     guess_score = { 'X' => 0, 'O' => 0 }
    #     selected_code.each_with_index do |i, e|
    #       if e == code[i]
    #         guess_score['X'] += 1
    #         code[i] = 'X'
    #       elsif !code.find_index(e).nil?
    #         guess_score['O'] += 1
    #         code[code.find_index(e)] = 'X'
    #       end
    #     end

    #     if guess_score == @codebreaker_guess
    #       s.push(code)
    #     end
    #   end

    # end

    ################# COMMON #################

    def check_player_selection(player_selection_code, code)
      @codebreaker_guess = { 'X' => 0, 'O' => 0 }

      player_selection_code.each_with_index do |color, i|
        if color == code[i]
          @codebreaker_guess['X'] += 1
        elsif !code.find_index(color).nil?
          @codebreaker_guess['O'] += 1
        end
      end
    end

    def end_game?
      if @num_colors == @codebreaker_guess['X']
        puts "Congrats! #{@player_role == 'codebreaker' ? 'You' : 'Computer'} won!"
        return true
      elsif @turns_left.zero?
        puts "#{@player_role == 'codebreaker' ? 'You' : 'Computer'} couldn\'t crack the code. #{@player_role == 'codebreaker' ? 'Computer' : 'You'} won!"
        puts @color_scheme.join(' | ')
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
