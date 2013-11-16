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
require_relative '../money'
require_relative '../account'
require_relative '../transaction'

describe 'Account' do

  it "Should have correct money state" do
    cm = CurrencyMarket.new
    cm.offlineLoad "spec/denni_kurz.txt"

    acc = Account.new("4878-9871-1191-2131", "Martin", "Pavel", "Ing.", "PhD.", "CZK")
    acc.setMarket cm

    acc.transaction(Transaction.new(Time.now, "Test #1", "+", Money.new(2000, "USD")))
    acc.transaction(Transaction.new(Time.now, "Test #2", "-", Money.new(500, "GBP")))
    acc.transaction(Transaction.new(Time.now, "Test #3", "+", Money.new(500, "CZK")))
    
    (acc.money == Money.new(BigDecimal.new("23035.5"), "CZK")).should be true
  end
end
