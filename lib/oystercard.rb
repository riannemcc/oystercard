require_relative 'journey'

class Oystercard
  attr_reader :balance, :entry_station, :journeys
  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @journeys =[]
  end

  def top_up(amount)
    raise "This exceeds £#{MAX_BALANCE} limit" if @balance + amount >= MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    @journeys.last.in_journey?
  end

  def touch_in(station)
    raise "The balance is too low" if @balance < MIN_BALANCE
    current_journey = Journey.new(station)
    @journeys << current_journey
    @journeys.last
  end

  def touch_out(station)
    deduct_fare(1)
    @journeys.last.set_exit_station(station)
  end

  private

  def deduct_fare(amount)
    @balance -= amount
  end

end
