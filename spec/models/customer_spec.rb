# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer, type: :model do


  describe "バリデーションチェック" do
    let!(:other_customer) { create(:customer) }
    let(:customer) { FactoryBot.build(:customer) }

    it "姓、名、自己紹介、メール、パスワードがある場合、有効である" do
      expect(customer).to be_valid
    end

    it "名がない場合、無効である" do
      customer.first_name = nil
      customer.valid?
      expect(customer.errors[:first_name]).to eq(["を入力してください", "は1文字以上で入力してください"])
    end

    it "姓がない場合、無効である" do
      customer.last_name = nil
      customer.valid?
      expect(customer.errors[:last_name]).to include("を入力してください", "は1文字以上で入力してください")
    end

    it "自己紹介が150文字以下であること：150文字は〇" do
      customer.introduction = Faker::Lorem.characters(number: 150)
      expect(customer.valid?).to eq true
    end

    it "自己紹介が150文字以下であること：151文字は×" do
      customer.introduction = Faker::Lorem.characters(number: 151)
      customer.valid?
      expect(customer.errors[:introduction]).to include("は150文字以内で入力してください")
    end

    # メソッドチェックに入れる
    it "姓、名を登録すると、姓名が取得できること" do
      customer.first_name = "tarou"
      customer.last_name = "tanaka"
      expect(customer.full_name).to eq "tanaka tarou"
    end

  end

end