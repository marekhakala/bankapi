#!/usr/bin/env ruby
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

require "./currencymarket"
require "./money"
require "./account"
require "./transaction"
require "./bank"

# Example usage

cm = CurrencyMarket.new
# Online - Normal mode
cm.sync
# Offline - Debug mode
#cm.offlineLoad "spec/denni_kurz.txt"

acc1 = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
acc3 = Account.new("4178-1735-8792-9135", "Paul", "Wester", "BA", "MSc.", "USD")

bank = Bank.new("AlohaBank")
bank.setMarket cm

bank.createAccount(acc1)
bank.createAccount(acc3)

acc1.transaction(Transaction.new(Time.now, "Test #1", "+", Money.new(2500, "USD")))
acc3.transaction(Transaction.new(Time.now, "Test #2", "+", Money.new(1500, "GBP")))

bank.sendMoneyTo(acc1, acc3, Transaction.new(Time.now, "Test #3", "+", Money.new(500, "USD")))
bank.sendMoneyTo(acc3, acc1, Transaction.new(Time.now, "Test #4", "+", Money.new(250, "USD")))

puts bank
puts "----------------------------------------------------------------------------------------"
puts acc1
puts "----------------------------------------------------------------------------------------"
puts acc3
puts "----------------------------------------------------------------------------------------"
