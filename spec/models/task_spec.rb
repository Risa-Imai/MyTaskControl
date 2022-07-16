# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task, type: :model do

  describe "バリデーションチェック" do
    let(:customer) { create(:customer) }
    let(:task) { build(:task, customer_id: customer.id)}

    it "title, progress_statusがある場合、有効である" do
      expect(task.valid?).to eq true
    end

    context "titleカラム" do
      it "空欄でないこと" do
        task.title = ""
        expect(task.valid?).to eq false
      end
    end
    context "progress_statusカラム" do
      it "空欄でないこと" do
        task.progress_status = ""
        expect(task.valid?).to eq false
      end
    end
  end

end