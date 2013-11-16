# ***************************************************************************
# *   Copyright (C) 2013 by Marek Hakala   *
# *   hakala.marek@gmail.com   *
# *
# *   Semester project for MI-RUB @ CTU FIT
# *   Topic: Bank API
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU Library General Public License as       *
# *   published by the Free Software Foundation; either version 2 of the    *
# *   License, or (at your option) any later version.                       *
# *                                                                         *
# *   This program is distributed in the hope that it will be useful,       *
# *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *   GNU General Public License for more details.                          *
# *                                                                         *
# *   You should have received a copy of the GNU Library General Public     *
# *   License along with this program; if not, write to the                 *
# *   Free Software Foundation, Inc.,                                       *
# *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
# ***************************************************************************/

require 'bigdecimal'
require_relative 'core_ext/string'

class Money
  attr_reader :value, :currency
  def initialize(value, currency)
    @value = BigDecimal.new("#{value}".gsub(/([,])/, '.'))
    @currency = currency.upcase
    @market = nil
  end

  def == other
    if other.class == self.class && @currency == other.currency && @value == other.value
    true
    else
    false
    end
  end

  def < other
    if @currency == other.currency
    right = other.value
    else
      right = other.send("to_#{@currency.downcase}").value
    end

    if @value < right
    true
    else
    false
    end
  end

  def > other
    not self < other and not self == other
  end

  def != other
    not self == other
  end

  def + other
    if other.class == self.class
      if @currency == other.currency
        Money.new(@value + other.value, @currency)
      else
        tmp = other.send("to_#{@currency.downcase}")

        unless tmp.nil?
          return Money.new(@value + tmp.value, @currency)
        end

      self
      end
    elsif other.class == Fixnum or other.class == Float or other.class == BigDecimal
      Money.new(@value + BigDecimal.new("#{other}"), @currency)
    else
    self
    end
  end

  def - other
    if other.class == self.class
      if @currency == other.currency
        Money.new(@value - other.value, @currency)
      else
        tmp = other.send("to_#{@currency.downcase}")

        unless tmp.nil?
          return Money.new(@value - tmp.value, @currency)
        end

      self
      end
    elsif other.class == Fixnum or other.class == Float or other.class == BigDecimal
      Money.new(@value - BigDecimal.new("#{other}"), @currency)
    else
    self
    end
  end

  def * other
    if other.class == self.class
      if @currency == other.currency
        Money.new(@value * other.value, @currency)
      else
        tmp = other.send("to_#{@currency.downcase}")

        unless tmp.nil?
          return Money.new(@value * tmp.value, @currency)
        end

      self
      end
    elsif other.class == Fixnum or other.class == Float or other.class == BigDecimal
      Money.new(@value * BigDecimal.new("#{other}"), @currency)
    else
    self
    end
  end

  def / other
    if other.class == self.class
      if @currency == other.currency
        Money.new(@value / other.value, @currency)
      else
        tmp = other.send("to_#{@currency.downcase}")

        unless tmp.nil?
          return Money.new(@value / tmp.value, @currency)
        end

      self
      end
    elsif other.class == Fixnum or other.class == Float or other.class == BigDecimal
      Money.new(@value / BigDecimal.new("#{other}"), @currency)
    else
    self
    end
  end

  def method_missing(name, *args, &block)
    methodName = "#{name}".scan(/to_[a-zA-Z]{3}/)

    unless methodName.empty?
      currencyLabel = methodName[0].split(/_/)[1]
      return Money.new(convertTo(currencyLabel), currencyLabel)
    end

    nil
  end

  def setMarket(market)
    @market = market
  end

  def to_s
    "#{@value.to_s('F')} #{@currency}"
  end

  private

  def convertToCZK
    if @currency == "CZK"
    return @value
    else
      country = @market.findCountry @currency

      unless country.nil?
      return @value * country.rate
      end
    end

    nil
  end

  def convertTo currencyLabel
    currencyLabel.upcase!
    # puts "Convert from #{@currency} to #{currencyLabel} : #{self}"

    unless @market.nil?
      # Case 1: Equal currencies => no exchange
      if @currency == currencyLabel
      return @value
      # Case 2: Exchange from any currency to CZK
      elsif currencyLabel == "CZK"
        return convertToCZK
      # Case 3: Exchange between different currencies
      else
        country = @market.findCountry currencyLabel

        unless country.nil?
          # Case 3a: Exchange from CZK to any currency
          if @currency.upcase == "CZK"
          return @value / country.rate
          # Case 3b: Exchange from any to any currency
          else
            return  to_czk.value / country.rate
          end
        end
      end
    end

    nil
  end
end
