# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer, type: :model do

  describe "バリデーションチェック" do
    # 遅延評価
    let!(:other_customer) { create(:customer) }
    # 事前評価
    let(:customer) { FactoryBot.build(:customer) }

    it "姓、名、自己紹介、メール、パスワードがある場合、有効である" do
      expect(customer).to be_valid
    end

    context "first_nameカラム" do
      it "名がない場合、無効である" do
        customer.first_name = nil
        customer.valid?
        expect(customer.errors[:first_name]).to eq(["を入力してください", "は1文字以上で入力してください"])
      end

      it "名が1文字以上であること：1文字は〇" do
        customer.first_name = Faker::Lorem.characters(number: 1)
        expect(customer.valid?).to eq true
      end

      it "名は10文字以下であること：10文字は〇" do
        customer.first_name = Faker::Lorem.characters(number: 10)
        expect(customer.valid?).to eq true
      end

      it "名が10文字以下であること：11文字は×" do
        customer.first_name = Faker::Lorem.characters(number: 11)
        customer.valid?
        expect(customer.errors[:first_name]).to include("は10文字以内で入力してください")
      end
    end

    context "last_nameカラム" do
      it "姓がない場合、無効である" do
        customer.last_name = nil
        customer.valid?
        expect(customer.errors[:last_name]).to include("を入力してください", "は1文字以上で入力してください")
      end

      it "姓が1文字以上であること：1文字は〇" do
        customer.last_name = Faker::Lorem.characters(number: 1)
        expect(customer.valid?).to eq true
      end

      it "姓が10文字以下であること：10文字は〇" do
        customer.last_name = Faker::Lorem.characters(number: 10)
        expect(customer.valid?).to eq true
      end

      it "姓が10文字以下であること：11文字は×" do
        customer.last_name = Faker::Lorem.characters(number: 11)
        customer.valid?
        expect(customer.errors[:last_name]).to include("は10文字以内で入力してください")
      end
    end

    context "introductionカラム" do
      it "自己紹介が150文字以下であること：150文字は〇" do
        customer.introduction = Faker::Lorem.characters(number: 150)
        expect(customer.valid?).to eq true
      end

      it "自己紹介が150文字以下であること：151文字は×" do
        customer.introduction = Faker::Lorem.characters(number: 151)
        customer.valid?
        expect(customer.errors[:introduction]).to include("は150文字以内で入力してください")
      end
    end

    context "メソッドチェック" do
      it "姓、名を登録すると、姓名が取得できること" do
        customer.first_name = "tarou"
        customer.last_name = "tanaka"
        expect(customer.full_name).to eq "tanaka tarou"
      end
    end

  end

end