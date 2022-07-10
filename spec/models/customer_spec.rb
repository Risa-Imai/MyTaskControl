# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer, type: :model do

  describe "バリデーションチェック" do
    # 事前評価
    let!(:other_customer) { create(:customer) }
    # 遅延評価
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
  end

  describe "メソッドチェック" do
    # 遅延評価
    let(:customer) { FactoryBot.build(:customer) }
    context "first_nameカラム last_nameカラム" do
      it "姓、名を登録すると、姓名が取得できること" do
        customer.first_name = "tarou"
        customer.last_name = "tanaka"
        expect(customer.full_name).to eq "tanaka tarou"
      end
    end
    context "active_for_authentication?" do
    subject { customer.active_for_authentication? }
    let!(:customer) { create(:customer) }
      it "退会していない場合" do
        customer.is_delete = false
        is_expected.to eq true
      end
      it "退会している場合" do
        customer.is_delete = true
        is_expected.to eq false
      end
    end
    context "self.guest"
  end

  describe "Activestorageのチェック" do
    # 事前評価
    let!(:customer) { create(:customer) }
    it "何も画像が登録されていない場合" do
      customer.get_customer_image(150, 150)
      expect(customer.customer_image.filename.to_s).to eq "no_image.jpg"
    end
    it "画像が変更された場合" do
      customer.customer_image = fixture_file_upload("test.jpg", content_type: "image/*")
      expect(customer.customer_image.filename.to_s).to eq "test.jpg"
    end
  end

  describe "アソシエーションのテスト" do
    context "Taskモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:tasks).macro).to eq :has_many
      end
    end
    context "Task_Commentモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:task_comments).macro).to eq :has_many
      end
    end
    context "Favoriteモデルとの関係" do
      it "1:Nとなっている" do
        expect(Customer.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context "Relationshipモデルとの関係" do
      it "N:Nとなっている" do
        expect(Customer.reflect_on_association(:relationships).macro).to eq :has_many
        expect(Customer.reflect_on_association(:reverse_of_relationships).macro).to eq :has_many
      end
      it "N:Nとなっている" do
        expect(Customer.reflect_on_association(:followings).macro).to eq :has_many
        expect(Customer.reflect_on_association(:followers).macro).to eq :has_many
      end
    end
  end

end