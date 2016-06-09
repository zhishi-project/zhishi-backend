require 'rails_helper'

RSpec.describe TokenManager do
  subject{ TokenManager }
  let(:user){ create(:user) }

  describe ".generate_token" do
    describe 'arguments' do
      it 'throws argument error if no arg is provided' do
        expect{ subject.generate_token }.to raise_error ArgumentError
      end
    end

    context "when generating token for a user" do
      let(:token){ subject.generate_token(user.id) }

      it 'generates a valid token' do
        expect(token.split('.').count).to eq 3
        expect{subject.decode(token)}.not_to raise_error
      end

      describe 'token expiration' do
        it 'sets expiration time to 24hrs by default' do
          decoded = subject.decode(token)
          expect(decoded.first['exp']).to eql 24.hours.from_now.to_i
        end

        it 'sets expiration time to any time given' do
          temp_token = subject.generate_token(user.id, 2.minutes.from_now)
          decoded = subject.decode(temp_token)
          expect(decoded.first['exp']).to eql 2.minutes.from_now.to_i
          expect(decoded.first['exp']).not_to eql 24.hours.from_now.to_i
        end
      end
    end

    context "when generating token for notification" do
      let(:object) { { "id" => 1, "title" => "sample object" } }
      let(:token){ subject.generate_token(nil, 5.minutes.from_now, object) }

      it 'generates a valid token' do
        expect(token.split('.').count).to eq 3
        expect{subject.decode(token)}.not_to raise_error
      end

      describe 'token expiration' do
        it 'sets expiration time to 5 minutes' do
          decoded = subject.decode(token)
          expect(decoded.first['exp']).to eql 5.minutes.from_now.to_i
        end

        it 'sets the notification object' do
          decoded = subject.decode(token)
          expect(decoded.first['payload']).to eql object
        end
      end
    end
  end

  describe ".issue_token" do
    let(:issued_token){ subject.issue_token({}) }

    it "generates valid token" do
      expect(issued_token.split('.').count).to eq 3
    end

    it "generates token with the valid specification" do
      decoded = subject.decode(issued_token)
      expect(decoded.last['typ']).to eql 'JWT'
      expect(decoded.last['alg']).to eql 'HS512'
    end

    describe "arguments" do
      it "accepts only one argument" do
        expect{ subject.issue_token }.to raise_error ArgumentError
      end
    end
  end

  describe ".secret" do
    it "uses secret from Rails secret_key_base" do
      expect(subject.secret).to eq Rails.application.secrets.secret_key_base
    end

    describe "arguments" do
      it "accepts no arguments" do
        expect{subject.secret}.not_to raise_error
        expect{subject.secret('arg1', 'arg2')}.to raise_error(ArgumentError)
        expect{subject.secret('arg1')}.to raise_error(ArgumentError)
      end
    end
  end

  describe ".decode" do
    let(:token){ subject.generate_token(user.id) }

    it 'decodes information accurately' do
      decoded = subject.decode(token)
      expect(decoded.first['user']).to eql user.id
      expect(decoded.first['exp']).to eql 24.hours.from_now.to_i
    end

    it 'throws error if token is invalid' do
      invalid = Faker::Code.ean
      expect{subject.decode(invalid)}.to raise_error JWT::DecodeError
    end

    it 'throws error if token is expired' do
      expired = subject.generate_token(user.id, 1.seconds.from_now)
      expect{ subject.decode(expired) }.not_to raise_error
      sleep(1)
      expect{ subject.decode(expired) }.to raise_error(JWT::ExpiredSignature, 'Signature has expired')
    end

    describe "arguments" do
      it "accepts only one argument" do
        expect{ subject.decode }.to raise_error ArgumentError
      end
    end
  end

  describe ".authenticate" do
    let(:token){ subject.generate_token(user.id) }

    it 'authenticates a valid token' do
      decoded = subject.decode(token)
      expect(decoded.last).to eql('alg' => 'HS512', 'typ' => 'JWT')
      expect(decoded.first['user']).to eql user.id
      expect(decoded.first['exp']).to eql 24.hours.from_now.to_i
    end

    describe "error rescue" do
      let(:rescued_response){ {} }

      it 'rescues invalid token error' do
        invalid = Faker::Code.ean
        expect{ subject.decode(invalid) }.to raise_error JWT::DecodeError
        expect{ subject.authenticate(invalid) }.not_to raise_error
        expect(subject.authenticate(invalid)).to eql rescued_response
      end

      it 'rescues expired token error' do
        expired = subject.generate_token(user.id, Time.now)
        expect{ subject.decode(expired) }.to raise_error JWT::ExpiredSignature
        expect{ subject.authenticate(expired) }.not_to raise_error
        expect(subject.authenticate(expired)).to eql rescued_response
      end
    end

    describe "arguments" do
      it "accepts only one argument" do
        expect{ subject.authenticate }.to raise_error ArgumentError
      end
    end
  end
end
