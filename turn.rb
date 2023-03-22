class Turn
  attr_reader :score, :view

  def initialize(input)
    @frame = nil
    @input = input
    evaluate
  end

  def strike?
    @input == "Strike"
  end

  def spare?
    @input == "Spare"
  end

  def miss?
    @input == "Miss"
  end

  private

  def evaluate
    if strike?
      @view = "X"
      @score = 10
    elsif spare?
      @view = "/"
      @score = 10
    elsif miss?
      @view = "-"
      @score = 0
    else
      @view = @score = @input
    end
  end
end
