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

class Bank
  attr_reader :name 
  
  def initialize(name)
    @name = name
    @market = nil
    @accounts = Array.new
  end
  
  def createAccount account
    acc = findAccount account
    return false unless acc.nil? 
    
    unless @market.nil?
      account.setMarket @market
    end
    
    @accounts << account
    true
  end
  
  def removeAccount input
    acc = findAccount input
    
    unless acc.nil?
      @accounts.delete acc
      return true
    end
    false
  end
  
  def findAccount input
    @accounts.each do |item|
      if input.class == Account
        return item if input == item
      else
        num = input.scan(/^([0-9]{4})[ -]{0,1}([0-9]{4})[ -]{0,1}([0-9]{4})[ -]{0,1}([0-9]{4})$/)
        return item if num.join("") == item.number
      end
    end
    
    nil
  end
  
  def sendMoneyTo(senderAcc, receiverAcc, transaction)
    sender = findAccount senderAcc
    receiver = findAccount receiverAcc
    
    unless sender.nil? and receiuver.nil?
      s = sender.transaction(Transaction.new(transaction.date, "to #{receiverAcc.getAccountNumber} : #{transaction.description}", "-", transaction.money))
      return false if not s
      r = receiver.transaction(Transaction.new(transaction.date, "from #{senderAcc.getAccountNumber} : #{transaction.description}", "+", transaction.money))
      return false if not r
      
      return true
    end
    
    false
  end  
  
  def setMarket market
    @market = market
  end
  
  def accountsCount
    @accounts.size
  end
  
  def each
    @accounts.each do |item|
      yield item
    end
  end
  
  def to_s
    output = "Name\t\t: #{name}\n"
    output = "#{output}Accounts\t: #{accountsCount}\n"
    output = "#{output}====================================================\n"
    output = "#{output}\n"
    output = "#{output}:: Accounts list ::\n"
    @accounts.each do |item|
      output = "#{output}#{item.to_s_short}\n"
    end
    
    output
  end
end