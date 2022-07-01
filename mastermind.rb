  class Game
    COLORS = %w[red green blue orange pink cyan].freeze

    def initialize(player_role = 'codebreaker', num_colors = 4, num_turns = 12)
      @num_colors = num_colors
      @num_turns = num_turns
      @codebreaker_guess = {}
      @player_role = player_role # 'codebreaker' or 'codemaker'
    end

    def start_game
      @turns_left = @num_turns

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
      @color_scheme = @num_colors.times.map {COLORS.sample}
      @color_scheme_code = @color_scheme.map { |color| COLORS.index(color) }

      puts "Colors to choose from #{COLORS}. Duplicates are allowed."
      puts "Enter #{@num_colors} color(s) from the list above separated with \" \" (one space):"
      puts 'Legend: " " (space) - color is not present, O - color is in the wrong place, X - color is in the right place.'

      until end_game?
        puts "===== Turns left: #{@turns_left} ====="
        player_selection = gets.chomp.split(' ')
        player_selection_code = player_selection.map { |color| COLORS.index(color) }

        @codebreaker_guess = get_feedback(player_selection_code, @color_scheme_code)

        puts show_codebreaker_guess(player_selection)

        @turns_left -= 1
      end
    end

    ################# CODE-MAKER #################

    def game_codemaker
      generate_all_codes # @all_codes
      knuth_codes = Array.new(@all_codes)
      possible_codes = Array.new(@all_codes)
      
      puts "Colors to choose from #{COLORS}. Duplicates are allowed."
      puts "Create a color scheme of #{@num_colors}, separated by \" \" (one space)."

      @color_scheme = gets.chomp.split(' ')
      @color_scheme_code = @color_scheme.map { |color| COLORS.index(color) }

      player_selection_code = [0, 0, 1, 1] # choosing the first guess
      player_selection = player_selection_code.map { |color_code| COLORS[color_code] }

      @codebreaker_guess = get_feedback(player_selection_code, @color_scheme_code)

      puts "===== Turns left: #{@turns_left} ====="
      puts show_codebreaker_guess(player_selection)

      until end_game?
        @turns_left -= 1
        puts "===== Turns left: #{@turns_left} ====="

        possible_codes.delete(player_selection_code)
        prune_list(player_selection_code, knuth_codes)
        player_selection_code = get_new_code(knuth_codes, possible_codes)
        player_selection = player_selection_code.map { |color_code| COLORS[color_code] }
        @codebreaker_guess = get_feedback(player_selection_code, @color_scheme_code)
        
        puts show_codebreaker_guess(player_selection)
      end
    end

    def generate_all_codes
      @all_codes = []
      (0..COLORS.length ** @num_colors - 1).each do |i|
        code = i.to_s(COLORS.length)
        @all_codes[i] = (code.length == @num_colors ? code.split('') : code.prepend('0' * (@num_colors - code.length)).split('')).map { |str| str.to_i}
      end
    end

    def prune_list(last_guess_code, knuth_codes)
      knuth_codes.each do |code|
        retrieved_feedback = get_feedback(code, last_guess_code)
        knuth_codes.delete(code) if retrieved_feedback != @codebreaker_guess
      end
    end

    def get_new_code(knuth_codes, possible_codes)
      guess_codes = minimax(knuth_codes, possible_codes)
      code = get_guess_code_from_list(knuth_codes, guess_codes)
      code
    end

    def minimax(knuth_codes, possible_codes)
      scores = {}

      possible_codes.each do |code|
        times_found = Hash.new(0)

        knuth_codes.each do |code_to_crack|
          feedback = get_feedback(code_to_crack, code)
          feedback_str = feedback_to_string(feedback)
          times_found[feedback_str] += 1 if !feedback_str.to_s.strip.empty?
        end

        maximum = times_found.values.max
        scores[code] = (maximum.nil? ? 0 : maximum)
      end

      minimum = scores.values.min
      guess_codes = []

      possible_codes.each do |code|
        guess_codes.push(code) if scores[code] == minimum
      end

      return guess_codes
    end

    def feedback_to_string(feedback)
      feedback.map { |key, value|
        (1..value).map { key }
      }.reduce { |sum, e| sum.concat(e) }.sort.join
    end

    def get_guess_code_from_list(knuth_codes, guess_codes)
      knuth_codes.each do |code|
        if !guess_codes.find_index(code).nil?
          return code
        end
      end

      return guess_codes[0]
    end

    ################# COMMON #################

    def get_feedback(player_selection_code, code)
      feedback = { 'X' => 0, 'O' => 0 }
      tested_code = Array.new(code)

      player_selection_code.each_with_index do |color, i|
        if color == tested_code[i]
          feedback['X'] += 1
          tested_code[i] = 'X'
        elsif !tested_code.find_index(color).nil?
          feedback['O'] += 1
          tested_code[tested_code.find_index(color)] = 'X'
        end
      end

      feedback
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

  game = Game.new('codemaker')
  #game = Game.new()
  game.start_game
