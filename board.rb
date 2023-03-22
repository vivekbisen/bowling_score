require_relative "frame"
require_relative "turn"

class Board
  attr_reader :name, :frames

  def initialize(name)
    @name = name
    @frames = []
  end

  def add_input(input)
    return unless valid?(input)

    if current_frame.nil? || current_frame.completed?
      new_frame = add_frame(frames.size + 1)
      new_frame.add_input(input)
    else
      current_frame.add_input(input)
    end
  end

  def view
    frames.map { |frame| frame.view }
  end

  private

  def current_frame
    frames.last
  end

  def add_frame(frame_number)
    new_frame = Frame.new(frame_number, previous: current_frame)
    frames.push(new_frame)
    new_frame
  end

  def game_over?
    current_frame&.final_round? && current_frame&.completed?
  end

  def valid?(input)
    valid_inputs = ["Strike", "Spare", "Miss", *(1..9)]
    if game_over?
      puts "Please start a new game!"
      false
    elsif !valid_inputs.include?(input)
      puts "#{input} is invalid. Please enter a valid input"
      false
    else
      true
    end
  end
end
