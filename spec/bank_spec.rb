#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

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

require 'spec_helper'
require 'bigdecimal'
require_relative '../bank'
require_relative '../money'
require_relative '../account'
require_relative '../transaction'

describe 'Bank' do

  it "Should have unique accounts (account number)" do
    cm = CurrencyMarket.new
    cm.offlineLoad "spec/denni_kurz.txt"

    acc1 = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
    acc2 = Account.new("4878-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    acc3 = Account.new("4178-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    
    bank = Bank.new("AlohaBank")
    bank.setMarket cm
    
    (bank.createAccount(acc1)).should be true
    (bank.createAccount(acc1)).should be false
    (bank.accountsCount == 1).should be true
    (bank.createAccount(acc2)).should be false
    (bank.createAccount(acc3)).should be true
    (bank.accountsCount == 2).should be true
  end

  it "Should have account garbage method" do
    
  end

  it "Should have search method" do
    cm = CurrencyMarket.new
    cm.offlineLoad "spec/denni_kurz.txt"

    acc1 = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
    acc2 = Account.new("4878-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    acc3 = Account.new("4178-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    
    bank = Bank.new("AlohaBank")
    bank.setMarket cm
    
    bank.createAccount(acc1)
    bank.createAccount(acc3)
    
    (bank.findAccount("4878-9871-1191-2131") == acc1).should be true
    (bank.findAccount("4178-9871-1191-2131") == acc3).should be true
  end

  it "Should send money to another account" do
    cm = CurrencyMarket.new
    cm.offlineLoad "spec/denni_kurz.txt"

    acc1 = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
    acc3 = Account.new("4178-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    
    bank = Bank.new("AlohaBank")
    bank.setMarket cm
    
    bank.createAccount(acc1)
    bank.createAccount(acc3)

    acc1.transaction(Transaction.new(Time.now, "Test #1", "+", Money.new(2500, "USD")))
    acc3.transaction(Transaction.new(Time.now, "Test #2", "+", Money.new(1500, "GBP")))

    bank.sendMoneyTo(acc1, acc3, Transaction.new(Time.now, "Test #3", "+", Money.new(500, "USD")))
    bank.sendMoneyTo(acc3, acc1, Transaction.new(Time.now, "Test #4", "+", Money.new(250, "USD")))

    (acc3.money == Money.new("2676.906611701284287299825590614", "USD")).should be true
    (acc1.money == Money.new("42572.25", "CZK")).should be true
  end
  
  it "Should have overdraft - (disable)" do
    cm = CurrencyMarket.new
    cm.offlineLoad "spec/denni_kurz.txt"

    acc1 = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
    acc3 = Account.new("4178-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    
    bank = Bank.new("AlohaBank")
    bank.setMarket cm
    
    bank.createAccount(acc1)
    bank.createAccount(acc3)

    acc1.transaction(Transaction.new(Time.now, "Test #1", "+", Money.new(100, "USD")))
    acc3.transaction(Transaction.new(Time.now, "Test #2", "+", Money.new(80, "GBP")))

    s1 = bank.sendMoneyTo(acc1, acc3, Transaction.new(Time.now, "Test #3", "+", Money.new(101, "USD")))
    s2 = bank.sendMoneyTo(acc3, acc1, Transaction.new(Time.now, "Test #4", "+", Money.new(81, "GBP")))

    (s1).should be false
    (s2).should be false
  end

  it "Should have overdraft - (enable)" do
    cm = CurrencyMarket.new
    cm.offlineLoad "spec/denni_kurz.txt"

    acc1 = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
    acc3 = Account.new("4178-9871-1191-2131", "Paul", "Wester", "BA", "MSc.", "USD")
    
    bank = Bank.new("AlohaBank")
    bank.setMarket cm
    
    bank.createAccount(acc1)
    bank.createAccount(acc3)

    acc1.transaction(Transaction.new(Time.now, "Test #1", "+", Money.new(100, "CZK")))
    acc3.transaction(Transaction.new(Time.now, "Test #2", "+", Money.new(80, "GBP")))
    acc1.enableOverdraft(Money.new("-1000", "CZK"))
    acc3.enableOverdraft(Money.new("0", "GBP"))
    
    s1 = bank.sendMoneyTo(acc1, acc3, Transaction.new(Time.now, "Test #3", "+", Money.new(150, "CZK")))
    s2 = bank.sendMoneyTo(acc3, acc1, Transaction.new(Time.now, "Test #4", "+", Money.new(80, "GBP")))

    (s1).should be true
    (s2).should be true
  end
end
