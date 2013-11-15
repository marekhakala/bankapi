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
 
require_relative 'transaction'

class Account 
    attr_reader :number, :date, :firstName, :lastName, :headDegree, :tailDegree, :transactionList, :currency, :overdraft
  
  def initialize(number, firstName, lastName, headDegree, tailDegree, currency)
    num = number.scan(/^([0-9]{4})[ -]{0,1}([0-9]{4})[ -]{0,1}([0-9]{4})[ -]{0,1}([0-9]{4})$/)
    @number = num.join("")
    
    @firstName = firstName
    @lastName = lastName
    
    @headDegree = headDegree
    @tailDegree = tailDegree
    
    @date = Time.now
    @transactionList = Array.new
    @currency = currency.upcase
    
    @overdraft = false
  end
  
  def == other
    @number == other.number
  end
  
  def != other
    self.class != other.class or not self == other
  end
  
  def money
    currentMoney = Money.new(BigDecimal.new("0"), @currency.upcase)
    
    @transactionList.each do |transaction|
     if transaction.operation == "+"
       currentMoney += transaction.money
     else
       currentMoney -= transaction.money
     end
    end
    
    currentMoney   
  end
  
  def setMarket market
    @market = market
  end
  
  def enableOverdraft limit
    @limit = limit
    @overdraft = true
  end
  
  def disableOverdraft
    @overdraft = false
  end
  
  def transaction input
    unless @market.nil?
      input.setMarket(@market)
    end
    
    # Check currency exchange
    input.homeCurrency = false if input.money.currency != @currency
    return false if not input.homeCurrency and @market == nil
    
    # Check money account state
    m = money
    m.setMarket(@market)
    mResult = (m - input.money)

    # Exchange incoming money
    if not input.homeCurrency
      input.homeMoney = input.money.send("to_#{@currency.downcase}")
    end
    
    # Check overdraft
    if not @overdraft or @limit == nil
      return false if input.operationType.upcase == "OUT" and mResult < Money.new("0", @currency)
    elsif @overdraft 
      return false if input.operationType.upcase == "OUT" and mResult < @limit    
    end
        
    @transactionList << input
    true
  end

  def each
    @transactionList.each do |item|
      yield item      
    end
  end

  def getAccountNumber
    num = @number.scan(/^([0-9]{4})([0-9]{4})([0-9]{4})([0-9]{4})$/)[0]
    
    if num.size == 4
    "#{num[0]}-#{num[1]}-#{num[2]}-#{num[3]}"
    else
      nil
    end
  end

  def to_s_short
    "#{headDegree} #{firstName} #{lastName} #{tailDegree}, #{money}, #{getAccountNumber} [#{date}]"
  end
  
  def to_s
    output = "Name\t\t: #{headDegree} #{firstName} #{lastName} #{tailDegree}\n"
    output = "#{output}Current money\t: #{money}\n"
    output = "#{output}Account number\t: #{getAccountNumber}\n"
    output = "#{output}Creation date\t: #{date}\n"
    output = "#{output}Overdraft\t: #{overdraft}\n"
    output = "#{output}\n"
    output = "#{output}:: Transaction list ::\n"
    output = "#{output}====================================================\n"
    
    @transactionList.each do |transaction|
      output = "#{output}#{transaction}\n"  
    end 
    
    output
  end
end