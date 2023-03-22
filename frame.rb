class Frame
  attr_reader :previous_frame, :frame_score
  attr_accessor :total_score

  def initialize(number, previous: previous_frame)
    @number = number
    @previous_frame = previous
    @first_turn = @second_turn = @final_turn = nil
    @frame_score = @total_score = 0
  end

  def view
    {
      frame: number,
      turns: turns_played.map(&:view),
      score: score_view
    }
  end

  def add_input(input)
    new_turn = Turn.new(input)

    if first_turn.nil?
      @first_turn = new_turn
    elsif second_turn.nil?
      @second_turn = new_turn
    elsif final_round? && final_turn.nil?
      @final_turn = new_turn
    end
    update_scores
  end

  def final_round?
    number == 10
  end

  def completed?
    turns == turns_played
  end

  def strike?
    first_turn.strike?
  end

  def spare?
    second_turn&.spare?
  end

  private

  attr_reader :number, :first_turn, :second_turn, :final_turn

  def score_view
    incomplete_score = total_score.zero? || total_score == previous_frame&.total_score
    incomplete_score ? "..." : total_score
  end

  def update_scores
    update_frame_score
    update_total_score
  end

  def all_clear?
    !final_round? && (strike? || spare?)
  end

  def update_frame_score
    @frame_score = all_clear? ? 10 : turns_played.sum(&:score)
  end

  def update_total_score
    return unless completed?

    if !(spare? || strike?)
      @total_score += frame_score
    end

    if previous_frame
      if previous_frame.strike?
        if previous_frame.previous_frame&.strike?
          previous_frame.previous_frame.total_score += first_turn.score
          previous_frame.total_score = previous_frame.previous_frame.total_score
        end

        if final_round?
          previous_frame.total_score += previous_frame.frame_score + first_turn.score + second_turn.score
          @total_score += frame_score
        else
          previous_frame.total_score += previous_frame.frame_score + frame_score
        end
      elsif previous_frame.spare?
        previous_frame.total_score += previous_frame.frame_score + first_turn.score
      end
      @total_score += previous_frame.total_score
    end
  end

  def turns
    if final_round?
      [first_turn, second_turn, final_turn]
    elsif first_turn.strike?
      [first_turn]
    else
      [first_turn, second_turn]
    end
  end

  def turns_played
    turns.compact
  end
end
