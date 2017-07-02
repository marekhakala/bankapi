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

require_relative '../currencymarket'
require_relative '../country'

describe 'CurrencyMarket' do
  before(:all) do
    loadCountries
  end

  def loadCountries
    @countries = Array.new
    file = File.new("#{File.dirname(__FILE__)}/countries.txt", "r")

    while (line = file.gets)
      l1 = line.split(/\n/)[0]
      l2 = l1.split('|')
      @countries << l2[1]
    end

    file.close
  end

  it "Should have compare file - countries" do
   state = File.exist?("#{File.dirname(__FILE__)}/countries.txt")
   state.should be true
  end

  it "Should have not empty compare file" do
    (@countries.size > 0).should be true
  end

  it "Should have Currency Market synced" do
    @cm = CurrencyMarket.new
    @cm.sync
    (@cm.syncState == "ok").should be true

    @countries.each do |item|
      c = @cm.findCountry item
      (c != nil && c.code == item.upcase).should be true
    end
  end
end
