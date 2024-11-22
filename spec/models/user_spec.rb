require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(email: 'test@example.com', password: 'password') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      described_class.create!(email: 'test@example.com', password: 'password')
      expect(subject).to_not be_valid
    end
  end

  describe 'password encryption' do
    it 'encrypts the password' do
      expect(subject.password_digest).to_not be_nil
    end
  end
end