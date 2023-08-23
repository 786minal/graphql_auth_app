require 'rails_helper'
RSpec.describe User, type: :model do
  before(:all) do
    @user1 = create(:user)
  end
  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end
  it "format of an email" do 
    user2 = build(:user, email: 'bob.com')
    expect(user2).to_not be_valid
  end
  it "has a unique email" do
    user1 = create(:user)
    user2 = build(:user, email: user1.email)
    expect(user2).to_not be_valid
  end
  it "is not valid without a email" do 
    user2 = build(:user, email: nil)
    expect(user2).to_not be_valid
  end
  it "is not valid without a password" do 
    user2 = build(:user, password: nil)
    expect(user2).to_not be_valid
  end
  it "minimum length 8 of a password" do 
    user2 = build(:user, password: 'blah')
    expect(user2).to_not be_valid
  end

end