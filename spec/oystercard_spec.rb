require './lib/oystercard.rb'

describe Oystercard do

  it 'checks the balance of an oystercard' do
    card = Oystercard.new
    expect(card.balance?).to eq 0
  end
end
