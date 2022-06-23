require "rails_helper"

RSpec.describe Customer, type: :model do

  it "姓、名、自己紹介、メール、パスワードがある場合、有効である" do
    # customerのそれぞれのカラムに対して値を入れてオブジェクト化する
    customer = Customer.new(
        first_name: "tarou",
         last_name: "tanaka",
      introduction: "田中太郎と申します。よろしくお願いします。",
             email: "tanaka@example.com",
          password: "password",
      )
    expect(customer).to be_valid
  end

end