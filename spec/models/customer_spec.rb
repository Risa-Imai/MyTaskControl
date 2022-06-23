# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer, type: :model do

  it "姓、名、自己紹介、メール、パスワードがある場合、有効である" do
    # customerのそれぞれのカラムに対して値を入れてオブジェクト化する
    customer = Customer.new(
        first_name: "tarou",
         last_name: "tanaka",
      introduction: "田中太郎と申します。よろしくお願いします。",
             email: "tanaka@example.com",
          password: "password"
      )
    expect(customer).to be_valid
  end

  it "姓、名を登録すると、姓名が取得できること" do
    customer = Customer.new(
         last_name: "tanaka",
        first_name: "tarou"
    )
    expect(customer.full_name).to eq "tanaka tarou"
  end

  it "名がない場合、無効である" do
    # first_nameでnilを設定する
    customer = Customer.new(
        first_name: nil,
         last_name: "tanaka",
      introduction: "田中太郎と申します。よろしくお願いします。",
             email: "tanaka@example.com",
          password: "password"
        )
    customer.valid?
    expect(customer.errors[:first_name]).to include("を入力してください", "は1文字以上で入力してください")
  end
end