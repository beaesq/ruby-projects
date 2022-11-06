# frozen_string_literal: true

require './lib/caesar.rb'

describe 'Caesar Cipher' do
  it 'shifts a string forward' do
    expect(caesar_cipher('stan loona', 5)).to eql('xyfs qttsf')
  end

  it 'keeps the same case' do
    expect(caesar_cipher('stan LOONA', 5)).to eql('xyfs QTTSF')
  end

  it 'wraps from z to a' do
    expect(caesar_cipher('stan loona', 15)).to eql('hipc addcp')
  end
end