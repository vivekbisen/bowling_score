class Frame
  attr_reader :number,  :first_turn,  :second_turn,  :final_turn,  :score, :last_score

  def initialize(board, number)
    @board = board
    @number = number
    @first_turn = nil
    @second_turn = nil
    @final_turn = nil
    @score = 0
    @last_score = 0
  end
  
  def add_turn(input)
    update_last_score

    if first_turn.nil?
      @first_turn = Turn.new(self, input)
      @score = first_turn.score
    elsif second_turn.nil? && !first_turn.strike?
      @second_turn = Turn.new(self, input)

      @score = [first_turn, second_turn].sum(&:score)
    elsif final_round? && final_turn.nil?
      @final_turn = Turn.new(self, input)
      @score = [first_turn, second_turn, final_turn].sum(&:score)
    end
  end
  
  def last_frame
    return if number < 2

    @board.frames.find { |frame| frame.number == number - 1 }
  end

  def update_last_score
    return unless last_frame

    @last_score = last_frame.score + last_frame.last_score
  end

  def completed?
    return true if first_turn&.strike?

    completed = first_turn && second_turn
    final_round? ? (completed && final_turn) : completed
  end

  def turns
    if first_turn.strike?
      [first_turn]
    elsif final_round?
      [first_turn, second_turn, final_turn]
    else
      [first_turn, second_turn]
    end
  end

  def final_round?
    number == 10
  end

  def view
    {
      frame_number: @number,
      turns: turns.map(&:view),
      current_score: score,
      last_score: last_score,
      score: total_score
    }
  end

  def total_score
    cumulative_score = score + last_score
    if first_turn.strike?
      cumulative_score
    elsif second_turn&.spare?
      cumulative_score
    else
      cumulative_score
    end
  end
end

class Turn
  attr_reader :frame, :input

  def initialize(frame, input)
    @frame = frame
    @input = input
  end

  def strike?
    input == "X"
  end

  def spare?
    input == "/"
  end

  def score
    if strike?
      20
    elsif spare?
      10
    else
      input
    end
  end
  
  def view
    input
  end
end

class Board
  attr_reader :frames

  def initialize(name)
    @name = name
    @frames = []
  end

  def current_frame
    @frames.last
  end

  def add_frame(frame_number)
    Frame.new(self, frame_number)
  end

  def game_over?
    frames.size == 10 && current_frame.completed?
  end

  def add_score(input)
    if game_over? 
      puts "Please start a new game!"
      return
    end

    if current_frame == nil || current_frame.completed?
      new_frame = add_frame(frames.size + 1)
      new_frame.add_turn(input)
      frames.push(new_frame)
    else
      current_frame.add_turn(input)
    end
  end

  def view
    puts frames.map { |frame| frame.view }
  end
end

board = Board.new("The dudes")
board.add_score("X")
board.add_score("X")
board.add_score("X")
board.add_score(1)
board.add_score(2)
# (1..25).to_a.each do |score|
#   board.add_score(score)
# end

board.view
