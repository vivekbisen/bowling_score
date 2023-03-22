require_relative "../board"

describe Board do
  let(:name) { double }

  subject { described_class.new(name) }

  it { expect(subject.name).to eq(name) }

  context "add a valid input" do
    let(:input) { 1 }
    before { subject.add_input(input) }

    describe ".frames" do
      it { expect(subject.frames).to be_one }
      it { expect(subject.frames).to include(a_kind_of(Frame)) }
    end

    describe ".view" do
      it { expect(subject.view).to eq([{frame: 1, turns: [1], score: "..."}]) }
    end
  end

  context "add two inputs" do
    before do
      subject.add_input(1)
      subject.add_input(6)
    end

    it { expect(subject.view).to eq([{frame: 1, turns: [1, 6], score: 7}]) }
  end

  context "add inputs from the challenge" do
    before do
      ["Strike", 7, "Spare", 9, "Miss", "Strike", "Miss", 8, 8, "Spare", "Miss", 6, "Strike", "Strike", "Strike", 8, 1].each do |input|
        subject.add_input(input)
      end
    end

    it "should match the challenge output" do
      expect(subject.view).to eq([
        {frame: 1, turns: ["X"], score: 20},
        {frame: 2, turns: [7, "/"], score: 39},
        {frame: 3, turns: [9, "-"], score: 48},
        {frame: 4, turns: ["X"], score: 66},
        {frame: 5, turns: ["-", 8], score: 74},
        {frame: 6, turns: [8, "/"], score: 84},
        {frame: 7, turns: ["-", 6], score: 90},
        {frame: 8, turns: ["X"], score: 120},
        {frame: 9, turns: ["X"], score: 148},
        {frame: 10, turns: ["X", 8, 1], score: 167}
      ])
    end
  end
end
