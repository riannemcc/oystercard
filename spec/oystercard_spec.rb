require './lib/oystercard.rb'

describe Oystercard do
  let (:station) {double :station}
  let (:journey) {instance_double("journey", :entry_station => station)}

    it 'checks that the card has an empty list of journeys' do
      expect(subject.journeys).to eq []
    end

    it 'checks the balance of an oystercard' do
      expect(subject.balance).to eq 0
    end

  context '#top_up' do
    it 'allows the balance of the card to be increased by set amount' do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end

    it 'prevents card from being topped beyond £90 limit' do
      expect { subject.top_up(90) }.to raise_error "This exceeds £90 limit"
    end
  end

    xit 'deducts a fare from a card' do
      subject.top_up(20)
      expect(subject.deduct_fare(5)).to eq 15
    end

    it 'confirms that the card is in a journey' do
      subject.top_up(10)
      subject.touch_in(station)
      expect(subject.in_journey?).to be true
    end

  context '#touch_in' do
    it 'confirms that the card has touched in to a journey' do
      subject.top_up(10)
      expect(subject.touch_in(station)).to be_instance_of Journey
    end

    it 'prevents a card from touching in if the balance is < £1' do
      expect { subject.touch_in(station) }.to raise_error "The balance is too low"
    end

    it 'remembers the entry station at touch in' do
      subject.top_up(10)
      expect(subject.touch_in(station).entry_station).to eq station
    end
  end

  context '#touch_out' do

    xit 'confirms that the card has touched out of a journey' do
      expect(subject.touch_out(station)).to be false
    end

    it 'deducts fare from card after touch out' do
      expect { subject.touch_out(station) }.to change{subject.balance}.by(-1)
    end

    it 'forgets the entry station on touch out' do
      subject.top_up(10)
      subject.touch_in(station)
      expect { subject.touch_out(station) }.to change{subject.entry_station}.to nil
    end

    it 'creates one journey after touch in and out' do
      card = Oystercard.new
      card.top_up(10)
      card.touch_in(station)
      expect(card.touch_out(station)).to eq [{entry_station: station, exit_station: station}]
    end
  end
end
