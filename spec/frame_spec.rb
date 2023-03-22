require_relative "../frame"

describe Frame do
  let(:number) { 0 }

  subject { described_class.new(number) }

  it { expect(subject.previous_frame).to be_nil }
  it { expect(subject.frame_score).to be_zero }
  it { expect(subject.total_score).to be_zero }

  describe ".final_round" do
    context "when frame number is 10" do
      let(:number) { 10 }
      it { is_expected.to be_final_round }
    end

    context "when frame number is not 10" do
      let(:number) { 7 }
      it { is_expected.to_not be_final_round }
    end
  end

  context "when Strike" do
    before { subject.add_input("Strike") }
    it { is_expected.to be_strike }
    it { is_expected.to_not be_spare }
    it { is_expected.to be_completed }
    it { expect(subject.view).to eq(frame: number, turns: ["X"], score: "...") }
  end

  context "when Spare" do
    before { subject.add_input(8) }
    before { subject.add_input("Spare") }
    it { is_expected.to be_spare }
    it { is_expected.to_not be_strike }
    it { is_expected.to be_completed }
    it { expect(subject.view).to eq(frame: number, turns: [8, "/"], score: "...") }
  end

  context "when first turn not strike or spare" do
    before { subject.add_input(8) }

    it { is_expected.to_not be_spare }
    it { is_expected.to_not be_strike }
    it { is_expected.to_not be_completed }
    it { expect(subject.view).to eq(frame: number, turns: [8], score: "...") }
  end

  context "when completed with no strike or spare" do
    before { subject.add_input(8) }
    before { subject.add_input(1) }

    it { is_expected.to_not be_spare }
    it { is_expected.to_not be_strike }
    it { is_expected.to be_completed }
    it { expect(subject.view).to eq(frame: number, turns: [8, 1], score: 9) }
  end
end
