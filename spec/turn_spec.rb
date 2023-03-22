require_relative "../turn"

describe Turn do
  let(:input) { double }
  subject { described_class.new(input) }

  it { expect(subject.score).to eq(input) }
  it { expect(subject.view).to eq(input) }

  context "strike" do
    let(:input) { "Strike" }

    it { is_expected.to be_strike }
    it { is_expected.to_not be_spare }
    it { is_expected.to_not be_miss }
    it { expect(subject.score).to eq(10) }
    it { expect(subject.view).to eq("X") }
  end

  context "spare" do
    let(:input) { "Spare" }

    it { is_expected.to be_spare }
    it { is_expected.to_not be_strike }
    it { is_expected.to_not be_miss }
    it { expect(subject.score).to eq(10) }
    it { expect(subject.view).to eq("/") }
  end

  context "miss" do
    let(:input) { "Miss" }

    it { is_expected.to be_miss }
    it { is_expected.to_not be_strike }
    it { is_expected.to_not be_spare }
    it { expect(subject.score).to eq(0) }
    it { expect(subject.view).to eq("-") }
  end
end
